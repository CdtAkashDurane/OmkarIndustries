package com.OmkarIndustry.web;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.OmkarIndustry.db.DBConnection;

@WebServlet("/addProduct")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class AddProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            String productContent = request.getParameter("product_content");

            // Handle Image
            Part part = request.getPart("images");
            String dbImagePath = "assets/images/placeholder.png"; // Default

            if (part != null && part.getSize() > 0) {
                String fileName = part.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/") + "assets/images/";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                part.write(uploadPath + fileName);
                dbImagePath = "assets/images/" + fileName;
            }

            try (Connection con = DBConnection.getConnection()) {
                String sql = "INSERT INTO products (name, category, description, images, product_content) VALUES (?, ?, ?, ?, ?::jsonb)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, category);
                ps.setString(3, description);
                
                // PostgreSQL Array
                Array sqlArray = con.createArrayOf("text", new String[]{dbImagePath});
                ps.setArray(4, sqlArray);
                ps.setString(5, productContent);

                ps.executeUpdate();
            }
            response.sendRedirect("manage-products.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}