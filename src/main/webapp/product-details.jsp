<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.OmkarIndustry.db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Specifications | Omkar Industry</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .spec-container { max-width: 1100px; margin: 40px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .product-header { border-left: 5px solid #FF5F15; padding-left: 20px; margin-bottom: 30px; }
        .product-header h1 { margin: 0; text-transform: uppercase; color: #333; }
        .category-tag { color: #FF5F15; font-weight: bold; margin: 5px 0; display: block; }
        
        /* Table Styling */
        .table-section-title { color: #FF5F15; border-bottom: 2px solid #eee; padding-bottom: 10px; margin: 40px 0 15px 0; text-transform: uppercase; font-size: 1.2rem; }
        .spec-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; background: white; border: 1px solid #ddd; }
        .spec-table th { background: #333; color: white; padding: 12px; text-align: left; text-transform: uppercase; font-size: 0.85rem; }
        .spec-table td { padding: 12px; border: 1px solid #eee; color: #444; font-size: 0.9rem; }
        .spec-table tr:nth-child(even) { background: #fafafa; }
        
        .main-img { width: 100%; border-radius: 8px; border: 1px solid #eee; box-shadow: 5px 5px 15px rgba(0,0,0,0.05); }
    </style>
</head>
<body style="background: #f8f9fa; font-family: sans-serif;">

    <div class="spec-container">
        <%
            String pid = request.getParameter("id");
            if(pid == null) { response.sendRedirect("index.jsp"); return; }
            
            try (Connection con = DBConnection.getConnection()) {
                PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE id = ?");
                ps.setInt(1, Integer.parseInt(pid));
                ResultSet rs = ps.executeQuery();

                if(rs.next()) {
                    // Extracting Data
                    String name = rs.getString("name");
                    String category = rs.getString("category");
                    String desc = rs.getString("description");
                    String jsonContent = rs.getString("product_content"); // This holds our tables
                    
                    // Handle text[] images array
                    Array imgArray = rs.getArray("images");
                    String mainImg = "assets/images/placeholder.png";
                    if(imgArray != null) {
                        String[] imgs = (String[]) imgArray.getArray();
                        if(imgs.length > 0) mainImg = imgs[0];
                    }
        %>
            <div class="product-header">
                <h1><%= name %></h1>
                <span class="category-tag"><%= category %></span>
            </div>

            <div style="display: flex; gap: 40px; flex-wrap: wrap;">
                <div style="flex: 1; min-width: 300px;">
                    <img src="<%= mainImg %>" class="main-img" alt="<%= name %>">
                </div>

                <div style="flex: 1.5; min-width: 300px;">
                    <h3 style="margin-top: 0; color: #333;">Product Details</h3>
                    <p style="line-height: 1.8; color: #555;"><%= desc %></p>
                    <a href="contact.jsp?product=<%= name %>" class="btn-main" style="display: inline-block; background: #FF5F15; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold; margin-top: 20px;">
                        <i class="fas fa-file-download"></i> Request Technical Data Sheet
                    </a>
                </div>
            </div>

            <div id="dynamic-tables-area" style="margin-top: 40px;"></div>
                </div>

            <input type="hidden" id="rawJsonData" value='<%= jsonContent %>'>

           <script>
    document.addEventListener("DOMContentLoaded", function() {
        // We use a template literal or hidden div to avoid quote escaping issues
        const rawJson = `<%= rs.getString("product_content") %>`;
        const container = document.getElementById('dynamic-tables-area');

        if (!rawJson || rawJson === "null" || rawJson === "[]") {
            container.innerHTML = "<p style='color:#999;'>No technical specifications available.</p>";
            return;
        }

        try {
            const data = JSON.parse(rawJson);

            data.forEach(section => {
                // 1. Create Title
                const h3 = document.createElement('h3');
                h3.className = "table-section-title";
                h3.innerText = section.tableTitle || "Specification Chart";
                container.appendChild(h3);

                // 2. Create Table
                const table = document.createElement('table');
                table.className = "spec-table";
                
                if (section.tableData && section.tableData.length > 0) {
                    // Extract Headers from the first row object
                    const headers = Object.keys(section.tableData[0]);
                    
                    // Build Header Row
                    let thead = "<thead><tr>";
                    headers.forEach(h => {
                        thead += `<th>\${h}</th>`;
                    });
                    thead += "</tr></thead>";
                    table.innerHTML = thead;

                    // Build Body Rows
                    let tbody = "<tbody>";
                    section.tableData.forEach(row => {
                        tbody += "<tr>";
                        headers.forEach(h => {
                            let cellValue = row[h];
                            
                            // FIX: Check if value is "false", null, or empty and show "-"
                            if (cellValue === false || cellValue === "false" || cellValue === null || cellValue === "") {
                                cellValue = "-";
                            }
                            
                            tbody += `<td>\${cellValue}</td>`;
                        });
                        tbody += "</tr>";
                    });
                    tbody += "</tbody>";
                    table.innerHTML += tbody;
                }
                container.appendChild(table);
            });
        } catch (err) {
            console.error("JSON Parsing Error:", err);
            container.innerHTML = "<p style='color:red;'>Technical data format error.</p>";
        }
    });
</script>

        <%
                } else {
                    out.println("<h2>Product Not Found</h2>");
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </div>

</body>
</html>