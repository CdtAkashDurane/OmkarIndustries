package com.OmkarIndustry.web;

import java.io.IOException;
import java.sql.*;
import com.OmkarIndustry.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM admins WHERE username=? AND password=?");
            ps.setString(1, user);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login Success: Create Session
                HttpSession session = request.getSession();
                session.setAttribute("adminUser", user);
                response.sendRedirect("admin.jsp");
            } else {
                // Login Fail
                request.setAttribute("error", "true");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } 
         catch (Exception e) {
        e.printStackTrace();
        // FIX: Send them back to login if the DB crashes
        response.sendRedirect("login.jsp?error=database");
    }
    }
}