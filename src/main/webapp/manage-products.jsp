<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.OmkarIndustry.db.DBConnection" %>
<%
    // Security Check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="assets/css/styles.css">
    <title>Manage Catalog | Omkar Industry</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary: #FF5F15; --dark: #111; }
        table { width: 90%; margin: 30px auto; border-collapse: collapse; background: white; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; }
        th, td { padding: 15px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #1a2a44; color: white; text-transform: uppercase; font-size: 0.85rem; }
        
        .btn-delete { color: #ff4444; cursor: pointer; text-decoration: none; font-weight: bold; font-size: 0.9rem; transition: 0.2s; }
        .btn-delete:hover { color: red; transform: scale(1.1); }
        
        .img-preview { width: 60px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #ddd; background: #fafafa; }
        .nav-admin { background: var(--dark); padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; }

        tbody tr { transition: 0.2s; } 
        tbody tr:hover { background-color: #fff5f0; }

        .btn-add-new {
            display: inline-block;
            background: var(--primary);
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-add-new:hover { background: #e05512; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
    </style>
</head>
<body style="background: #f4f4f4; font-family: 'Segoe UI', sans-serif; margin: 0;">

    <nav class="nav-admin">
        <span style="color: #FF5F15; font-weight: bold; font-size: 1.2rem;">
            <i class="fas fa-tools"></i> OMKAR ADMIN
        </span>
        <div>
            <a href="admin.jsp" style="color: white; margin-right: 20px; text-decoration: none;"><i class="fas fa-plus"></i> Add New</a>
            <a href="index.jsp" style="color: white; text-decoration: none; margin-right: 20px;"><i class="fas fa-globe"></i> Live Site</a>
            <a href="LogoutServlet" style="color: #ff4444; text-decoration: none; font-weight: bold;"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </nav>

    <div style="text-align: center; margin-top: 40px;">
        <h2 style="color: #333;">Current Product Catalog</h2>
        <p style="color: #666;">View or remove items currently displayed on your website.</p>
    </div>

    <table>
        <thead>
            <tr>
                <th style="text-align: center;">Preview</th>
                <th>Product Name</th>
                <th>Category</th>
                <th style="text-align: center;">Actions</th>
            </tr>
        </thead>
        <tbody>
          <%
            try (Connection con = DBConnection.getConnection()) {
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM products ORDER BY id DESC");
                
                while(rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String category = rs.getString("category");
                    
                    // 1. Handle PostgreSQL text[] Array for the Image
                    Array imgArray = rs.getArray("images");
                    String displayImg = "assets/images/placeholder.png"; // Default fallback
                    
                    if (imgArray != null) {
                        String[] imgs = (String[]) imgArray.getArray();
                        if (imgs != null && imgs.length > 0 && imgs[0] != null && !imgs[0].isEmpty()) {
                            displayImg = imgs[0]; // Take the first image path from the array
                        }
                    }
          %>
            <tr>
                <td style="text-align: center;">
                    <img src="<%= displayImg %>" 
                         class="img-preview" 
                         alt="product" 
                         onerror="this.src='assets/images/placeholder.png';">
                </td>
                <td style="font-weight: bold; color: #333;"><%= name %></td>
                <td>
                    <span style="background: #eee; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem;">
                        <%= category %>
                    </span>
                </td>
                <td style="text-align: center;">
                    <a href="DeleteProductServlet?id=<%= id %>" 
                       class="btn-delete" 
                       onclick="return confirm('Are you sure you want to delete this product?')">
                       <i class="fas fa-trash-alt"></i> Delete
                    </a>
                </td>
            </tr>
          <% 
                }
            } catch(Exception e) { 
                out.println("<tr><td colspan='4' style='color:red; padding: 20px; text-align:center;'>Error loading products: " + e.getMessage() + "</td></tr>"); 
            }
          %>
        </tbody>
    </table>

    <div style="text-align: center; margin-bottom: 50px; margin-top: 20px;">
        <a href="admin.jsp" class="btn-add-new">
            <i class="fas fa-plus-circle"></i> Add Another Product
        </a>
    </div>

</body>
</html>