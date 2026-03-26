<html>
<head>
    <link rel="stylesheet" href="assets/css/styles.css">
    <title>Contact Us | OmkarIndustry</title>
</head>
<body>
    <nav style="overflow: visible;"> <div class="logo-container">
        <a href="index.jsp">
            <img src="assets/images/logo.png" class="logo-img" alt="Omkar Industry Logo">
        </a>
    </div>
    
    <div class="nav-links">
    <a href="index.jsp">Home</a>
    
    <a href="index.jsp#products">Products</a>
    <a href="index.jsp#about">About</a>

    <% if(session.getAttribute("adminUser") != null) { %>
        <a href="admin.jsp" class="admin-btn">Dashboard</a>
    <% } else { %>
        <a href="login.jsp" class="admin-btn">Admin</a>
    <% } %>
</div>
</nav>

<div style="height: 80px;"></div>


    <div style="max-width: 600px; margin: 50px auto; background: white; padding: 30px; border-top: 10px solid #FF5F15; border-radius: 8px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
        <h2 style="color: #FF5F15;">Get In Touch</h2>
        
        <% if(request.getAttribute("status") != null) { %>
            <p style="color: green; font-weight: bold;">Message sent successfully! We will contact you soon.</p>
        <% } %>

        <form action="submitContact" method="post">
            <div style="margin-bottom: 15px;">
                <label>Full Name</label><br>
                <input type="text" name="name" required style="width: 100%; padding: 10px; border: 1px solid #FFA500;">
            </div>
            <div style="margin-bottom: 15px;">
                <label>Email Address</label><br>
                <input type="email" name="email" required style="width: 100%; padding: 10px; border: 1px solid #FFA500;">
            </div>
            <div style="margin-bottom: 15px;">
                <label>Message</label><br>
                <textarea name="message" rows="5" required style="width: 100%; padding: 10px; border: 1px solid #FFA500;"></textarea>
            </div>
            <button type="submit" class="btn-main" style="width: 100%; cursor: pointer;">Send Message</button>
        </form>
    </div>
</body>
</html>