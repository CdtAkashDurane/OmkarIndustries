<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Contact Messages</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #FF5F15; color: white; }
        /* Removed nth-child(even) to allow the dynamic row colors to show clearly */
        .timestamp { font-size: 0.8rem; color: #666; }
        .action-cell { display: flex; gap: 5px; }
    </style>
</head>
<body>
    <h2>📍 Customer Inquiries</h2>
    <hr>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Sender Name</th>
                <th>Email</th>
                <th>Message</th>
                <th>Date Received</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="msg" items="${messageList}">
                <tr style="${msg.read ? 'background-color: #ffffff; opacity: 0.7;' : 'background-color: #fff4e5; font-weight: bold;'}">
                    <td>${msg.id}</td>
                    <td><strong>${msg.name}</strong></td>
                    <td><a href="mailto:${msg.email}">${msg.email}</a></td>
                    <td>${msg.message}</td>
                    <td class="timestamp">${msg.submittedAt}</td>
                    
                    <td class="action-cell">
                        <c:if test="${!msg.read}">
                            <form action="${pageContext.request.contextPath}/admin/markRead" method="post" style="display:inline;">
                                <input type="hidden" name="messageId" value="${msg.id}">
                                <button type="submit" title="Mark as Read" style="background-color: #28a745; color: white; border: none; padding: 5px 8px; cursor: pointer; border-radius: 4px;">
                                    ✓ Read
                                </button>
                            </form>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/admin/deleteMessage" method="post" style="display:inline;" onsubmit="return confirm('Delete permanently?');">
                            <input type="hidden" name="messageId" value="${msg.id}">
                            <button type="submit" title="Delete" style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;">
                                🗑️
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>