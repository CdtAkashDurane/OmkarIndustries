package com.OmkarIndustry.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.OmkarIndustry.db.DBConnection;

@WebServlet("/submitContact")
public class ContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Capture Form Data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // 2. Database Logic
        try (Connection con = DBConnection.getConnection()) {
            // We only insert name, email, and message. 
            // ID and Submitted_at are automatic in your schema.
            String sql = "INSERT INTO contact_messages (name, email, message) VALUES (?, ?, ?)";
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, message);

                int rowsAffected = ps.executeUpdate();
                
                if (rowsAffected > 0) {
                    request.setAttribute("status", "success");
                } else {
                    request.setAttribute("status", "error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Check your console for errors if it still fails
            request.setAttribute("status", "error");
        }
        
        // 3. Forward back to contact.jsp
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }
}