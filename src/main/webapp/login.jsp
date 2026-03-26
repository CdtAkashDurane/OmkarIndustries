<html>
<head>
    <link rel="stylesheet" href="assets/css/styles.css">
    <title>Admin Login | OmkarIndustry</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body style="background: var(--dark); display: flex; align-items: center; justify-content: center; height: 100vh; font-family: sans-serif;">
    
    <div style="background: white; padding: 40px; border-radius: 10px; width: 350px; border-bottom: 8px solid var(--primary); box-shadow: 0 10px 25px rgba(0,0,0,0.2);">
        
        <h2 style="text-align: center; color: var(--primary); margin-bottom: 25px;">Restricted Access</h2>
        
        <%-- 1. SUCCESS MESSAGES (e.g., Logout success) --%>
        <% if(request.getParameter("message") != null) { %>
            <div style="background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; border: 1px solid #c3e6cb; font-size: 0.9rem;">
                <i class="fas fa-check-circle"></i> <%= request.getParameter("message") %>
            </div>
        <% } %>

        <%-- 2. ERROR MESSAGES (e.g., Wrong password) --%>
        <% if(request.getParameter("error") != null || request.getAttribute("error") != null) { %>
            <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; border: 1px solid #f5c6cb; font-size: 0.9rem;">
                <i class="fas fa-exclamation-triangle"></i> Invalid Credentials. Please try again.
            </div>
        <% } %>

        <form action="loginServlet" method="post">
            <label style="font-size: 0.8rem; color: #666;">Username</label>
            <input type="text" name="user" placeholder="Enter username" required 
                   style="width: 100%; margin: 5px 0 15px 0; padding: 12px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box;">
            
            <label style="font-size: 0.8rem; color: #666;">Password</label>
            <input type="password" name="pass" placeholder="Enter password" required 
                   style="width: 100%; margin: 5px 0 15px 0; padding: 12px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box;">
            
            <button type="submit" class="btn-main" 
                    style="width: 100%; margin-top: 10px; padding: 12px; cursor: pointer; font-weight: bold; text-transform: uppercase;">
                Login to Dashboard
            </button>
        </form>

        <div style="text-align: center; margin-top: 20px;">
            <a href="index.jsp" style="color: #666; text-decoration: none; font-size: 0.85rem;">
                <i class="fas fa-arrow-left"></i> Back to Live Site
            </a>
        </div>
    </div>

</body>
</html>