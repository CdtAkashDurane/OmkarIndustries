<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.OmkarIndustry.db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Omkar Industry | Premium Tyre & Tube Repairs</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .product-card { 
            background: white; 
            border-radius: 12px; 
            overflow: hidden; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
            transition: transform 0.3s ease; 
            display: flex; 
            flex-direction: column; 
            border: 1px solid #eee;
        }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .product-badge {
            position: absolute; top: 10px; right: 10px; 
            background: rgba(255,95,21,0.9); color: white; 
            padding: 4px 12px; border-radius: 20px; 
            font-size: 0.7rem; font-weight: bold; text-transform: uppercase;
        }
        .line-clamp {
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
            color: #777; font-size: 0.9rem; line-height: 1.5; margin-bottom: 20px;
        }
    </style>
</head>
<body>

<nav style="overflow: visible;"> 
    <div class="logo-container">
        <a href="index.jsp">
            <img src="assets/images/logo.png" class="logo-img" alt="Omkar Industry Logo">
        </a>
    </div>
    
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="#products">Products</a>
        <a href="#about">About</a>
        <a href="contact.jsp">Contact</a>
        <% if(session.getAttribute("adminUser") != null) { %>
            <a href="admin.jsp" class="admin-btn">Dashboard</a>
        <% } else { %>
            <a href="login.jsp" class="admin-btn">Admin</a>
        <% } %>
    </div>
</nav>

<div style="height: 5px;"></div>
    <header class="hero">
        <div class="hero-content">
            <h1 style="text-transform: uppercase; font-size: 3.5rem; margin-bottom: 10px;">Keep the World <br><span style="color: #FF7F00;">Moving</span></h1>
            <p style="font-size: 1.2rem; margin-bottom: 30px; opacity: 0.9;">High-performance repair solutions for every tyre type.</p>
            <a href="#products" class="btn-main" style="text-decoration: none;">View Our Catalog</a>
        </div>
    </header>
    <section id="about" class="about-section" style="display: flex; flex-wrap: wrap; padding: 80px 10%; align-items: center; background: #fff;">
        <div style="flex: 1; min-width: 300px; padding-right: 40px;">
        <div style="height: 100px; display: block;" aria-hidden="true"></div>
            <h4 style="color: #FF5F15; letter-spacing: 2px;">SINCE 1994</h4>
            <h2 style="font-size: 2.5rem; margin: 10px 0;">Pioneering Excellence in <span style="color: #FF7F00;">Tyre Repair</span></h2>
            <p style="line-height: 1.8; color: #555;">
                Omkar Industry is a global leader in providing comprehensive solutions for tyre and tube repairs. 
                Our products are engineered with a unique single-direction ply and locking wedge construction.
            </p>
            <div style="display: flex; gap: 20px; margin-top: 30px;">
                <div style="text-align: center;">
                    <h3 style="color: #FF5F15; margin: 0;">25+</h3>
                    <small>Countries</small>
                </div>
                <div style="text-align: center; border-left: 1px solid #ddd; padding-left: 20px;">
                    <h3 style="color: #FF5F15; margin: 0;">500+</h3>
                    <small>Products</small>
                </div>
            </div>
        </div>
        <div style="flex: 1; min-width: 300px;">
            <img src="assets/images/factory-view.jpg" alt="Industry" style="width: 100%; border-radius: 10px; box-shadow: 20px 20px 0px #FFA500;">
        </div>
    </section>

    <section id="products" style="padding: 80px 10%; background: #f4f4f4;">
        <h2 style="text-align: center; margin-bottom: 50px; font-size: 2.5rem;">Our <span style="color: #FF5F15;">Products</span></h2>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 30px;">
            <%
                Connection con = null;
                try {
                    con = DBConnection.getConnection();
                    
                    if (con != null) {
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM products ORDER BY id DESC");
                        
                        while(rs.next()) {
                            // Logic to extract the first image from the PostgreSQL text[] array
                            Array imgArray = rs.getArray("images");
                            String displayImg = "assets/images/placeholder.png"; 
                            
                            if (imgArray != null) {
                                String[] imgs = (String[]) imgArray.getArray();
                                if (imgs != null && imgs.length > 0 && imgs[0] != null) {
                                    displayImg = imgs[0]; 
                                }
                            }
            %>
                            <div class="product-card">
                                <div style="height: 220px; overflow: hidden; position: relative; background: #eee;">
                                    <img src="<%= displayImg %>" alt="<%= rs.getString("name") %>" 
                                         style="width: 100%; height: 100%; object-fit: cover;"
                                         onerror="this.src='assets/images/placeholder.png';">
                                    <span class="product-badge"><%= rs.getString("category") %></span>
                                </div>
                                
                                <div style="padding: 20px; flex-grow: 1; display: flex; flex-direction: column;">
                                    <h3 style="margin: 0 0 10px 0; font-size: 1.1rem; color: #333;"><%= rs.getString("name") %></h3>
                                    <p class="line-clamp"><%= rs.getString("description") %></p>
                                    
                                    <a href="product-details.jsp?id=<%= rs.getInt("id") %>" 
                                       style="margin-top: auto; text-align: center; background: #333; color: white; text-decoration: none; padding: 12px; border-radius: 5px; font-weight: bold; transition: background 0.3s;"
                                       onmouseover="this.style.background='#FF5F15'"
                                       onmouseout="this.style.background='#333'">
                                       View Specifications
                                    </a>
                                </div>
                            </div>
            <%          } 
                    } else {
            %>
                        <div style="grid-column: 1/-1; text-align: center; padding: 40px; background: white; border-radius: 10px;">
                            <i class="fas fa-exclamation-triangle" style="font-size: 2rem; color: #ddd; margin-bottom: 15px;"></i>
                            <p style="color: #888;">Database connection failed. Please check your DB settings.</p>
                        </div>
            <%
                    }
                } catch(Exception e) { 
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (con != null) try { con.close(); } catch (SQLException ignore) {}
                }
            %>
        </div>
    </section>

    <footer style="background: #111; color: white; padding: 60px 10% 20px 10%;">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 40px;">
           <div>
           		<h3 style="color: #FF5F15;">📍 Omkar Industries</h3>
                <a id="link-maps-address" 
       href="https://www.google.com/maps/search/?api=1&query=Omkar+Industries+Kanbargi+Industrial+Area+Belagavi+590016" 
       target="_blank" 
       style="text-decoration: none; display: block;"> 
                <p style="color: #888;">PLOT NO. S-1, Sy. N0. 638, <br>Kanbargi Industrial Area, <br>Belagavi-590016, India</p>
            </div>
            <div>
                <h4 style="margin-bottom: 20px; color: #FF7F00;">Contact</h4>
                <a id="link-phone" href="tel:+917619447817" style="color: #888; text-decoration: none;">
            📞 +91 7619447817
        </a>
        <br>
                <a href="mailto:info@omkarindustry.com" style="color: #888; text-decoration: none;">
            📧 duraneakash@gmail.com
        </a>
            </div>
            <div>
                <h4 style="margin-bottom: 20px; color: #FF7F00;">Follow Us</h4>
                <div style="display: flex; gap: 15px;">
                    <a href="#" style="color: #888;"><i class="fab fa-facebook"></i></a>
                    <a href="#" style="color: #888;"><i class="fab fa-linkedin"></i></a>
                    <a href="#" style="color: #888;"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
        <div style="text-align: center; margin-top: 50px; border-top: 1px solid #333; padding-top: 20px; font-size: 0.8rem; color: #555;">
            &copy; 2026 Omkar Industry. All Rights Reserved.
        </div>
    </footer>

</body>
</html>