package com.OmkarIndustry.web;

import java.io.File;
import java.io.IOException;
import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.OmkarIndustry.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    String productId = request.getParameter("id");

	    if (productId != null && !productId.isEmpty()) {
	        try (Connection con = DBConnection.getConnection()) {
	            // CORRECT SYNTAX: No * after DELETE
	            String sql = "DELETE FROM products WHERE id = ?";
	            PreparedStatement ps = con.prepareStatement(sql);
	            ps.setInt(1, Integer.parseInt(productId));
	            
	            ps.executeUpdate();
	            response.sendRedirect("manage-products.jsp?msg=deleted");
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            // This will print the exact SQL error to your browser for debugging
	            response.getWriter().println("SQL Error: " + e.getMessage());
	        }
	    } else {
	        response.sendRedirect("manage-products.jsp?error=noid");
	    }
	}
}