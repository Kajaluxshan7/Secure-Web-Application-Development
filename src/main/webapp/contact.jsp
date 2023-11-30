<%@include file="header.jsp" %>
<%@ page import="com.services.*" %>
<%
if (!AuthUtil.isAuthenticated(request)) {
    response.sendRedirect("index.jsp");
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/contact.css">
    <title>Contact Us</title>
</head>

<body>

    <div class="container">
        <h2>Contact Us</h2>
        <%
        String status = request.getParameter("status");

        if ("success".equalsIgnoreCase(status)) {
        %>
        <div style="color: green; text-align: center;">
            Your message has been sent successfully!
        </div>
        <%
        } else if ("error".equalsIgnoreCase(status)) {
        %>
        <div style="color: red; text-align: center;">
            There was an error sending your message. Please try again.
        </div>
        <%
        }
        %>
        <form action="processingContactForm.jsp" method="post">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="message">Message:</label>
            <textarea id="message" name="message" rows="4" required></textarea>

            <button type="submit">Submit</button>
        </form>
    </div>

</body>

</html>