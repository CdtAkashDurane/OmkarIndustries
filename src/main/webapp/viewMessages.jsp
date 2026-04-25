<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin | Customer Inquiries</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    
    <style>
        :root { --primary: #FF5F15; --dark: #1a1a1a; }
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; }

        /* Fixed Navigation */
        .nav-admin { 
            background: var(--dark); 
            padding: 1rem 5%; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        .nav-admin a { 
            text-decoration: none; 
            margin-left: 20px; 
            transition: 0.3s; 
            font-size: 0.95rem;
        }
        .nav-admin a:hover { opacity: 0.8; }

        /* Container & Table */
        .container { padding: 40px 5%; }
        h2 { color: #333; display: flex; align-items: center; gap: 10px; margin-bottom: 20px; }
        
        table { 
            width: 100%; 
            border-collapse: separate; 
            border-spacing: 0 8px; /* Adds space between rows */
            margin-top: 20px; 
        }
        th { 
            background-color: var(--primary); 
            color: white; 
            padding: 15px; 
            text-align: left; 
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }
        td { 
            padding: 15px; 
            background: white; 
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }
        /* Rounded corners for rows */
        td:first-child { border-left: 1px solid #eee; border-radius: 8px 0 0 8px; }
        td:last-child { border-right: 1px solid #eee; border-radius: 0 8px 8px 0; }

        .timestamp { font-size: 0.8rem; color: #888; font-style: italic; }
        .action-cell { display: flex; gap: 8px; align-items: center; }
        
        .btn { border: none; padding: 6px 12px; cursor: pointer; border-radius: 4px; font-weight: bold; transition: 0.2s; }
        .btn-read { background-color: #28a745; color: white; }
        .btn-delete { background-color: #dc3545; color: white; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 3px 8px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
<nav class="nav-admin">
    <span style="color: var(--primary); font-weight: bold; font-size: 1.4rem;">
        <i class="fas fa-user-shield"></i> OMKAR ADMIN
    </span>
    <div>
    	 <a href="${pageContext.request.contextPath}/admin.jsp" style="color: white; margin-right: 20px; text-decoration: none;"><i class="fas fa-plus"></i> Add New</a>
        <a href="${pageContext.request.contextPath}/manage-products.jsp" style="color: #FF7F00; text-decoration: none; margin-right: 20px;">
            <i class="fas fa-edit"></i> Manage Products
        </a>
        
        <a href="${pageContext.request.contextPath}/index.jsp" style="color: white; text-decoration: none; margin-right: 20px;">
            <i class="fas fa-globe"></i> Live Site
        </a>
        
        <a href="${pageContext.request.contextPath}/LogoutServlet" style="color: #ff4444; text-decoration: none; font-weight: bold;">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</nav>s

<div class="container">
    <h2><i class="fas fa-envelope-open-text" style="color: var(--primary);"></i> Customer Inquiries</h2>
    <p style="color: #666;">Review and manage messages sent from the contact form.</p>
    <hr style="border: 0; border-top: 1px solid #ddd;">
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Sender</th>
                <th>Email</th>
                <th>Message</th>
                <th>Received</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="msg" items="${messageList}">
                <tr style="${msg.read ? 'opacity: 0.7;' : 'font-weight: 600;'}">
                    <td>#${msg.id}</td>
                    <td>${msg.name}</td>
                    <td><a href="mailto:${msg.email}" style="color: #007bff; text-decoration: none;">${msg.email}</a></td>
                    <td style="max-width: 300px; line-height: 1.4;">${msg.message}</td>
                    <td class="timestamp">${msg.submittedAt}</td>
                    
                    <td class="action-cell">
                        <c:if test="${!msg.read}">
                            <form action="${pageContext.request.contextPath}/admin/markRead" method="post" style="display:inline;">
                                <input type="hidden" name="messageId" value="${msg.id}">
                                <button type="submit" class="btn btn-read" title="Mark as Read">
                                    <i class="fas fa-check"></i>
                                </button>
                            </form>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/admin/deleteMessage" method="post" style="display:inline;" onsubmit="return confirm('Delete this inquiry permanently?');">
                            <input type="hidden" name="messageId" value="${msg.id}">
                            <button type="submit" class="btn btn-delete" title="Delete">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>