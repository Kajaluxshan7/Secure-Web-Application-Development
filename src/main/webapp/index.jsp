<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*, java.util.*" %>
<%
    Properties props = new Properties();
    InputStream input = getServletContext().getResourceAsStream("/properties/application.properties");
    props.load(input);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/index.css">
    <title>DriveMate</title>
</head>
<body>
    <section>
        <div class="welcome-container">
            <div>
                <div>
                    <h1>Welcome to DriveMate</h1>
                    <h4>Your Car, Our Priority</h4>
                </div>
            </div>
            <div>
                <%
                    String authEndpoint = props.getProperty("authorize_endpoint");
                    String scope = props.getProperty("scope");
                    String responseType = props.getProperty("response_type");
                    String redirectUri = props.getProperty("redirect_uri");
                    String clientId = props.getProperty("client_id");

                    String link = authEndpoint + "?scope=" + scope + "&response_type=" + responseType + "&redirect_uri=" + redirectUri + "&client_id=" + clientId;
                %>
                <button type="button" style="background-color: #3498db; color: #fff; border: none; padding: 10px 20px; text-align: center; text-decoration: none; display: inline-block; font-size: 16px; cursor: pointer; transition: background-color 0.3s, color 0.3s;" 
                        onmouseover="this.style.backgroundColor='#5DADE2'; this.style.color='#333'" 
                        onmouseout="this.style.backgroundColor='#3498db'; this.style.color='#fff'" 
                        class="submit" onclick="window.location.href='<%= link %>';">
                    Continue Using Asgardio
                </button>
            </div>
        </div>
    </section>
</body>
</html>