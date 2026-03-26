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
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/deleteMessage")
public class DeleteMessageServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Security Check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String id = request.getParameter("messageId");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM contact_messages WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to the messages list
        response.sendRedirect(request.getContextPath() + "/admin/messages");
    }
}