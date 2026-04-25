<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Tyre Repair Assistant</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; padding: 50px; background: #f4f7f6; }
        .ai-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 350px; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        button:hover { background: #219150; }
        #ai-result { margin-top: 20px; padding: 15px; background: #e8f4fd; border-left: 5px solid #3498db; display: none; font-size: 0.9em; line-height: 1.4; }
    </style>
</head>
<body>

<div class="ai-container">
    <h3>🛠️ AI Repair Assistant</h3>
    <p>Enter damage dimensions:</p>
    
    <input type="text" id="tyreType" placeholder="Tyre Type (e.g. Radial)">
    <input type="number" id="width" placeholder="Damage Width (mm)">
    <input type="number" id="length" placeholder="Damage Length (mm)">
    
    <button onclick="getRecommendation()">Get Recommendation</button>

    <div id="ai-result"></div>
</div>

<script>
function getRecommendation() {
    // 1. Get user input
    const width = document.getElementById('width').value;
    const length = document.getElementById('length').value;
    const tyreType = document.getElementById('tyreType').value;
    const resultDiv = document.getElementById('ai-result');

    // Show a loading state
    resultDiv.innerHTML = "Consulting AI Specialist...";

    // 2. Make the request to your AIChatServlet
    fetch('AIChatServlet', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/x-www-form-urlencoded' 
        },
        body: `width=${encodeURIComponent(width)}&length=${encodeURIComponent(length)}&tyreType=${encodeURIComponent(tyreType)}`
    })
    .then(response => {
        if (!response.ok) {
            throw new Error("Network response was not ok");
        }
        return response.json();
    })
    .then(data => {
        // --- ADDED LOGIC STARTS HERE ---
        if (data.error) {
            resultDiv.innerHTML = "<span style='color:red;'>Error: " + data.error + "</span>";
        } 
        else if (data.candidates && data.candidates[0].content && data.candidates[0].content.parts) {
            // Extracting the text from Gemini's specific JSON structure
            const recommendation = data.candidates[0].content.parts[0].text;
            
            // Display the result
            resultDiv.innerHTML = "<strong>Recommended Patch:</strong><br>" + recommendation;
        } 
        else {
            resultDiv.innerHTML = "AI could not determine a specific patch. Please check dimensions.";
        }
        // --- ADDED LOGIC ENDS HERE ---
    })
    .catch(error => {
        resultDiv.innerHTML = "<span style='color:red;'>Error connecting to server.</span>";
        console.error('Fetch Error:', error);
    });
}
</script>

</body>
</html>