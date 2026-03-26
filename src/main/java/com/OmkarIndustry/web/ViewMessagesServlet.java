package com.OmkarIndustry.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.OmkarIndustry.db.DBConnection;
// ADD THIS IMPORT (Make sure the package name matches your Message.java)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/messages")
public class ViewMessagesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Security Check: Ensure admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        List<Message> messages = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Updated SQL to match your Neon database
            String sql = "SELECT * FROM contact_messages ORDER BY submitted_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setName(rs.getString("name"));
                msg.setEmail(rs.getString("email"));
                msg.setMessage(rs.getString("message"));
                msg.setSubmittedAt(rs.getTimestamp("submitted_at"));
                // This handles the "Mark as Read" status
                msg.setRead(rs.getBoolean("is_read")); 
                
                messages.add(msg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Send the data to the JSP
        request.setAttribute("messageList", messages);
        request.getRequestDispatcher("/viewMessages.jsp").forward(request, response);
    }
}