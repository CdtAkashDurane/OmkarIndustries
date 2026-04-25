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
    
    
    
    
    <head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* This CSS ensures the bot floats in the corner instead of sitting in a line */
        .ai-fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background: #FF5F15;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            cursor: pointer;
            z-index: 1000;
        }

        .ai-chat-window {
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 350px;
            background: white;
            display: none; /* Keeps it hidden until clicked */
            flex-direction: column;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            z-index: 1001;
            border: 1px solid #ddd;
        }
    </style>
</head>
    
    
    
    
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

  <footer style="background: #111; color: white; padding: 60px 10% 40px 10%; font-family: sans-serif;">
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 40px; align-items: start;">
        
        <div>
            <h3 style="color: #FF5F15; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
                <span style="font-size: 1.2rem;">📍</span> Omkar Industries
            </h3>
            <a id="link-maps-address" 
               href="https://www.google.com/maps/search/?api=1&query=Omkar+Industries+Kanbargi+Industrial+Area+Belagavi" 
               target="_blank" 
               style="text-decoration: none; color: #888; line-height: 1.6; display: block;"> 
                PLOT NO. S-1, Sy. N0. 638, <br>
                Kanbargi Industrial Area, <br>
                Belagavi-590016, India
            </a>
        </div>

        <div>
            <h4 style="margin-bottom: 25px; color: #FF7F00; font-weight: 600;">Contact</h4>
            <div style="display: flex; flex-direction: column; gap: 15px;">
                <a id="link-phone" href="tel:+917619447817" style="color: #888; text-decoration: none; display: flex; align-items: center; gap: 10px;">
                    <span style="color: #FF5F15;">📞</span> +91 7619447817
                </a>
                <a href="mailto:duraneakashkalidas@gmail.com" style="color: #888; text-decoration: none; display: flex; align-items: center; gap: 10px;">
                    <span style="color: #FF5F15;">📧</span> duraneakashkalidas@gmail.com
                </a>
            </div>
        </div>

        <div>
            <h4 style="margin-bottom: 25px; color: #FF7F00; font-weight: 600;">Follow Us</h4>
            <div style="display: flex; gap: 20px; font-size: 1.2rem;">
                <a href="#" style="color: #888; text-decoration: none;"><i class="fab fa-facebook"></i></a>
                <a href="#" style="color: #888; text-decoration: none;"><i class="fab fa-linkedin"></i></a>
                <a href="https://www.instagram.com/omkarindustry.in?igsh=eHpxeGI5Z3J4eXdm" target="_blank" style="color: #888; text-decoration: none;">
                    <i class="fab fa-instagram"></i>
                </a>
            </div>
        </div>
    </div>

    <div style="text-align: center; margin-top: 60px; border-top: 1px solid #333; padding-top: 25px; font-size: 0.85rem; color: #555; letter-spacing: 0.5px;">
        © 2026 **Omkar Industry**. All Rights Reserved.
    </div>
</footer>



<div class="ai-fab" onclick="toggleChat()" style="position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px; background: #FF5F15; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; cursor: pointer; z-index: 1000; box-shadow: 0 4px 15px rgba(0,0,0,0.3);">
    <i class="fas fa-robot"></i>
</div>

<div class="ai-chat-window" id="aiChatWindow" style="position: fixed; bottom: 100px; right: 30px; width: 350px; background: white; display: none; flex-direction: column; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); z-index: 1001; border: 1px solid #ddd; overflow: hidden;">
    <div class="chat-header" style="background:#2c3e50; color:white; padding:15px; display:flex; justify-content:space-between; align-items: center;">
        <span><i class="fas fa-robot"></i> Omkar AI Assistant</span>
        <span onclick="toggleChat()" style="cursor:pointer; font-size: 24px; line-height: 20px;">&times;</span>
    </div>
    <div class="chat-body" style="padding:20px; display: flex; flex-direction: column; gap: 10px;">
        
        <label style="font-size: 0.8rem; color: #666; margin-bottom: -5px;">Select Damage Type:</label>
        <select id="repairType" style="padding: 10px; border-radius: 5px; border: 1px solid #ddd; background: white;">
            <option value="Puncture">Puncture (requires Plug)</option>
            <option value="Sidewall Cut">Sidewall/Shoulder Cut (Radial)</option>
            <option value="Tube Leak">Tube Leak (Round/Oval Patch)</option>
        </select>

        <div style="display: flex; gap: 10px;">
            <input type="number" id="width" style="flex: 1; padding: 10px; border-radius: 5px; border: 1px solid #ddd;" placeholder="Width (mm)">
            <input type="number" id="length" style="flex: 1; padding: 10px; border-radius: 5px; border: 1px solid #ddd;" placeholder="Length (mm)">
        </div>
        
        <button onclick="getRecommendation()" style="width:100%; border:none; border-radius: 5px; padding: 12px; cursor: pointer; background: #FF5F15; color: white; font-weight: bold;">
            Get Recommendation
        </button>
        
        <div id="ai-result" style="margin-top:15px; font-size: 0.9rem; max-height: 200px; overflow-y: auto; border-top: 1px solid #eee; padding-top: 10px; color: #333;">
            <p style="color: #999; text-align: center;">Enter details to start.</p>
        </div>
    </div>
</div>
    
    <script>
    function toggleChat() {
        const chat = document.getElementById('aiChatWindow');
        // Check current display and toggle
        if (chat.style.display === "none" || chat.style.display === "") {
            chat.style.display = "flex";
        } else {
            chat.style.display = "none";
        }
    }

    function getRecommendation() {
        const type = document.getElementById('repairType').value;
        const w = document.getElementById('width').value;
        const l = document.getElementById('length').value;
        const resultDiv = document.getElementById('ai-result');

        if(!w || !l) {
            resultDiv.innerHTML = "<span style='color:red;'>Please enter dimensions!</span>";
            return;
        }

        resultDiv.innerHTML = "<i class='fas fa-spinner fa-spin'></i> Identifying best patch...";

        // Ensure the URL 'AIChatServlet' matches your @WebServlet mapping
        fetch('./AIChatServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: "width=" + encodeURIComponent(w) + "&length=" + encodeURIComponent(l) + "&tyreType=" + encodeURIComponent(type)
        })
        .then(res => {
            if (!res.ok) throw new Error("Server error");
            return res.json();
        })
      .then(data => {
    if (data.error) {
        resultDiv.style.display = "block";
        resultDiv.innerHTML = "<span style='color:red;'>⚠️ Error: " + data.error + "</span>";
    } 
    else if (data.candidates && data.candidates[0].content) {
        const recommendation = data.candidates[0].content.parts[0].text;
        
        // Highlight safety warnings
        resultDiv.style.display = "block";
        if (recommendation.toLowerCase().includes("scrap") || recommendation.toLowerCase().includes("replace")) {
            resultDiv.style.background = "#fff5f5";
            resultDiv.style.borderLeft = "5px solid #e74c3c";
            resultDiv.innerHTML = "<strong style='color:#c0392b;'>Safety Warning:</strong><br>" + recommendation;
        } else {
            resultDiv.style.background = "#e8f4fd";
            resultDiv.style.borderLeft = "5px solid #3498db";
            resultDiv.innerHTML = "<strong>Recommended Patch:</strong><br>" + recommendation;
        }
    }
})
        .catch(err => {
            resultDiv.innerHTML = "<span style='color:red;'>Connection failed. Check if Servlet is running.</span>";
            console.error(err);
        });
    }
</script>
</body>
</html>