package com.OmkarIndustry.web;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import org.json.JSONArray;
import org.json.JSONObject;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/AIChatServlet")
public class AIChatServlet extends HttpServlet {
    
    	// Hardcode your key directly for the college demo to avoid environment variable issues
    	private static final String API_KEY = "AIzaSy...Your_Real_Key"; 
    	private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + API_KEY;

    	@Override
    	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	    // 1. Capture parameters from the JSP fetch request
    	    String repairType = request.getParameter("tyreType"); 
    	    String width = request.getParameter("width");
    	    String length = request.getParameter("length");

    	    // 2. Build the context using the Bestpatch catalog data you uploaded
    	    String knowledgeBase = 
    	        "CONTEXT: You are a technical assistant for Omkar Industry tire repairs.\n" +
    	        "CATALOG RULES:\n" +
    	        "- For punctures: Stem size must be larger than injury. 6mm injury -> Uni Plug 6W (Ref 3001).\n" +
    	        "- For tube repairs: 25mm hole -> Round Patch (Ref 4001).\n" +
    	        "- SAFETY: If damage is in the 'Non-Repairable Area' (Sidewall Area A-B), tell user to SCRAP the tire.\n";

    	    String prompt = knowledgeBase + String.format("\nUSER INPUT: Type: %s, Width: %smm, Length: %smm.", repairType, width, length);

    	    // 3. Call the API and send the single JSON response back to JSP
    	    String aiResponse = callGeminiAPI(prompt);
    	    response.setContentType("application/json");
    	    response.setCharacterEncoding("UTF-8");
    	    response.getWriter().write(aiResponse); // Only one write call
    	}
    

    private String callGeminiAPI(String promptText) {
        try {
            // Construct JSON object properly
            JSONObject root = new JSONObject();
            JSONArray contents = new JSONArray();
            JSONObject content = new JSONObject();
            JSONArray parts = new JSONArray();
            JSONObject part = new JSONObject();

            part.put("text", promptText);
            parts.put(part);
            content.put("parts", parts);
            contents.put(content);
            root.put("contents", contents);

            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = root.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            int status = conn.getResponseCode();
            if (status != 200) {
                return "{\"error\": \"API returned status " + status + "\"}";
            }

            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
                return response.toString();
            }
        } catch (Exception e) {
            return "{\"error\": \"Connection failed: " + e.getMessage() + "\"}";
        }
    }
}