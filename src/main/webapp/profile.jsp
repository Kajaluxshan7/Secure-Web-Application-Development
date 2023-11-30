<%@include file="header.jsp" %>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page import="org.json.JSONObject" %>

<%
// extract access_token & id_token from session attribute
String accessToken = (String) request.getSession().getAttribute("access_token");
String idToken = (String) request.getSession().getAttribute("id_token");

// check the access token
if (accessToken != null && !accessToken.isEmpty()) {
    // read properties
    Properties props = new Properties();
    InputStream input = getServletContext().getResourceAsStream("/properties/application.properties");
    props.load(input);

    String userinfoEndpoint = props.getProperty("userinfo_endpoint");
    String introspectionEndpoint = props.getProperty("introspection_endpoint");

    try {
        // URL object for the userinfo endpoint
        URL userinfoUrl = new URL(userinfoEndpoint);

        // open a connection to the userinfo endpoint
        HttpURLConnection userinfoConnection = (HttpURLConnection) userinfoUrl.openConnection();

        // request method to GET
        userinfoConnection.setRequestMethod("GET");

        // authorization header with the access token
        userinfoConnection.setRequestProperty("Authorization", "Bearer " + accessToken);

        // get response code from the userinfo endpoint
        int userinfoResponseCode = userinfoConnection.getResponseCode();

        // read response data from the userinfo endpoint
        try (BufferedReader userinfoReader = new BufferedReader(new InputStreamReader(userinfoConnection.getInputStream()))) {
            String userinfoInputLine;
            StringBuilder userinfoResponse = new StringBuilder();

            while ((userinfoInputLine = userinfoReader.readLine()) != null) {
                userinfoResponse.append(userinfoInputLine);
            }

            // parse the userinfo response data as JSON
            JSONObject userinfoJson = new JSONObject(userinfoResponse.toString());

            // extract user information
            String username = userinfoJson.optString("username");
            String name = userinfoJson.optString("given_name");
            String email = userinfoJson.optString("email");

            String contactNumber = userinfoJson.optString("phone_number");
            String lastname = userinfoJson.optString("family_name");
            JSONObject addressObject = userinfoJson.optJSONObject("address");

            // extract the "country" property from the "address" object
            String country = (addressObject != null) ? addressObject.optString("country") : "";

            session.setAttribute("username", username);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/profile.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">Profile</div>

        <div class="section">
            <div class="section-header">Basic Information</div>
            <div class="info">
                <span class="info-name">User Name:</span>
                <span class="info-value"><%= username %></span>
            </div>
            <div class="info">
                <span class="info-name">Name:</span>
                <span class="info-value"><%= name %></span>
            </div>
            <div class="info">
                <span class="info-name">Email:</span>
                <span class="info-value"><%= email %></span>
            </div>
        </div>

        <div class="section">
            <div class="section-header">Contact Information</div>
            <div class="info">
                <span class="info-name">Contact No:</span>
                <span class="info-value"><%= contactNumber %></span>
            </div>
            <div class="info">
                <span class="info-name">Country:</span>
                <span class="info-value"><%= country %></span>
            </div>
        </div>
    </div>
</body>
</html>

<%
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
} else {
    // case where the access token is not present
    response.sendRedirect("index.jsp");
}%>