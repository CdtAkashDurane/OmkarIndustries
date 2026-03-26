package com.OmkarIndustry.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.OmkarIndustry.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/markRead")
public class MarkReadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("messageId");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE contact_messages SET is_read = TRUE WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/messages");
    }
}