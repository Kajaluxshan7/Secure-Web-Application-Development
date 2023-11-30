<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%    
    String sessionState = (String) session.getAttribute("sessionState");
    String client_id = "iw6X8MFpvFlhTV7gsyOS6B5fGj0a";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/header.css">
    <script type="text/javascript" src="Javascript/logout.js"></script>
</head>
<body>

    <div class="navbar">
        <img src="<%= request.getContextPath() %>/Images/DriveMate.png" alt="Logo" class="logo">
        <ul class="nav-links">
            <li><a class="nav-link" href="profile.jsp">Profile</a></li>
            <li><a class="nav-link" href="register.jsp">Register</a></li>
            <li><a class="nav-link" href="reservations.jsp">Reservations</a></li>
            <li><a class="nav-link" href="contact.jsp">Contact Us</a></li>
        </ul>

        <h1>DriveMate</h1>
        <form id="logout-form" action="<%= request.getContextPath() %>/logoutServlet" method="POST">
            <input type="hidden" id="client-id" name="client_id" value="<%= client_id %>">
            <input type="hidden" id="post-logout-redirect-uri" name="post_logout_redirect_uri"
                value="<%= request.getContextPath() %>/index.jsp">
            <input type="hidden" id="state" name="state" value="<%= sessionState %>">
            <button id="logout-btn" type="button" onclick="handleLogout(); return false;">Logout</button>
        </form>
    </div>
</body>
</html>