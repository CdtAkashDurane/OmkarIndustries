<%@ page import="java.sql.*, com.OmkarIndustry.db.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="assets/css/styles.css">
    <title>Our Product Range | Bestpatch</title>
    <style>
        .product-card { background: white; border: 1px solid #eee; border-radius: 8px; overflow: hidden; transition: 0.3s; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        
        /* Table Styles */
        .spec-container { margin: 15px 0; overflow-x: auto; border: 1px solid #f0f0f0; border-radius: 4px; }
        .spec-table { width: 100%; border-collapse: collapse; font-size: 0.75rem; text-align: left; }
        .spec-table th { background: #f9f9f9; color: #333; padding: 6px 8px; border-bottom: 2px solid #FF5F15; }
        .spec-table td { padding: 6px 8px; border-bottom: 1px solid #eee; color: #666; }
        
        .btn-main { background: #FF5F15; color: white; border: none; padding: 10px 20px; font-weight: bold; cursor: pointer; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body style="background: #fdfdfd; font-family: sans-serif;">
 <nav style="overflow: visible;"> <div class="logo-container">
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

<div style="height: 80px;"></div>

    <div style="background: #1a1a1a; padding: 60px 10%; color: white; border-bottom: 5px solid #FF5F15;">
        <h1 style="margin: 0; font-size: 2.5rem;">Industry Grade <span style="color: #FF7F00;">Repair Solutions</span></h1>
        <p style="opacity: 0.8; margin-top: 10px;">Browse our complete catalog of tyre and tube repair units.</p>
    </div>

    <div style="padding: 20px 10%; background: #f4f4f4; border-bottom: 1px solid #ddd;">
        <form action="products.jsp" method="get" style="display: flex; gap: 10px; flex-wrap: wrap;">
            <select name="category" style="padding: 10px; border: 1px solid #ccc; flex: 1; min-width: 150px;">
                <option value="">All Categories</option>
                <option value="Radial Tyre Repairs">Radial Repairs</option>
                <option value="Bias Ply Tyre Repairs">Bias Ply Repairs</option>
                <option value="Chemicals">Chemicals</option>
            </select>
            <input type="text" name="search" placeholder="Search product name..." style="padding: 10px; border: 1px solid #ccc; flex: 2; min-width: 200px;">
            <button type="submit" class="btn-main">Filter Results</button>
        </form>
    </div>

    <div style="padding: 50px 10%; display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px;">
        <%
            String cat = request.getParameter("category");
            String search = request.getParameter("search");
            
            try (Connection con = DBConnection.getConnection()) {
                StringBuilder query = new StringBuilder("SELECT * FROM products WHERE 1=1");
                if(cat != null && !cat.isEmpty()) query.append(" AND category = ?");
                if(search != null && !search.isEmpty()) query.append(" AND (name ILIKE ? OR description ILIKE ?)");
                
                PreparedStatement ps = con.prepareStatement(query.toString());
                int paramIdx = 1;
                if(cat != null && !cat.isEmpty()) ps.setString(paramIdx++, cat);
                if(search != null && !search.isEmpty()) {
                    ps.setString(paramIdx++, "%" + search + "%");
                    ps.setString(paramIdx++, "%" + search + "%");
                }

                ResultSet rs = ps.executeQuery();
                boolean found = false;
                
                while(rs.next()) {
                    found = true;
                    String productId = rs.getString("id");
                    String hStr = rs.getString("dynamic_headers");
                    String jData = rs.getString("dynamic_data");
        %>
            <div class="product-card">
                <div style="height: 200px; background: #eee; overflow: hidden;">
                    <img src="<%= rs.getString("image_url") %>" style="width: 100%; height: 100%; object-fit: cover;">
                </div>
                <div style="padding: 20px;">
                    <small style="color: #FF5F15; font-weight: bold; text-transform: uppercase;"><%= rs.getString("category") %></small>
                    <h3 style="margin: 5px 0;"><%= rs.getString("name") %></h3>
                    <p style="font-size: 0.85rem; color: #666; margin-bottom: 15px;"><%= rs.getString("description") %></p>
                    
                    <% if(hStr != null && !hStr.isEmpty()) { 
                        String[] headers = hStr.split(","); 
                    %>
                    <div class="spec-container">
                        <table class="spec-table">
                            <thead>
                                <tr>
                                    <% for(String h : headers) { %> <th><%= h %></th> <% } %>
                                </tr>
                            </thead>
                            <tbody id="tbody-<%= productId %>"></tbody>
                        </table>
                    </div>

                    <script>
                        (function() {
                            try {
                                const data = <%= (jData == null || jData.isEmpty()) ? "[]" : jData %>;
                                const headers = "<%= hStr %>".split(",");
                                const body = document.getElementById("tbody-<%= productId %>");
                                
                                data.forEach(row => {
                                    const tr = document.createElement("tr");
                                    headers.forEach(h => {
                                        const td = document.createElement("td");
                                        td.textContent = row[h] || "-";
                                        tr.appendChild(td);
                                    });
                                    body.appendChild(tr);
                                });
                            } catch(e) { console.error("Error loading specs", e); }
                        })();
                    </script>
                    <% } %>
                    <a href="contact.jsp?product=<%= rs.getString("name") %>" class="btn-main" style="display: block; text-align: center; margin-top: 10px;">Request Quote</a>
                </div>
            </div>
        <%      } 
                if(!found) {
                    out.println("<h3 style='grid-column: 1/-1; text-align: center; color: #999; padding: 50px;'>No products found matching your criteria.</h3>");
                }
            } catch(Exception e) { 
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); 
            }
        %>
    </div>

    <footer style="background: #111; color: white; padding: 40px 10%; text-align: center; margin-top: 50px;">
        <p>&copy; 2026 Bestpatch Tyre & Tube Repairs. All Rights Reserved.</p>
    </footer>

</body>
</html>