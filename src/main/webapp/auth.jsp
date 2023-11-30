<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.json.JSONObject" %>

<%
    // extract autho code from the request parameters
    String authorizationCode = request.getParameter("code");
    String sessionState = request.getParameter("session_state");
    session.setAttribute("sessionState", sessionState);

    if (authorizationCode == null || authorizationCode.isEmpty()) {
        // case where there is no authorization code
        out.println("Authorization code is missing.");
    } else {
        // token endpoint and client credentials
        Properties props = new Properties();
        InputStream input = getServletContext().getResourceAsStream("/properties/application.properties");
        props.load(input);

        String clientId = props.getProperty("client_id");
        String clientSecret = props.getProperty("client_secret");
        String tokenEndpoint = props.getProperty("token_endpoint");
        String redirectUri = props.getProperty("redirect_uri");
        try {
            // request data for token exchange
            String requestData = "code=" + authorizationCode +
                    "&grant_type=authorization_code" +
                    "&client_id=" + clientId +
                    "&client_secret=" + clientSecret +
                    "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8");

            // URL object for the token endpoint
            URL tokenUrl = new URL(tokenEndpoint);

            // connection to the token endpoint
            HttpURLConnection tokenConnection = (HttpURLConnection) tokenUrl.openConnection();

            // set the request method to POST
            tokenConnection.setRequestMethod("POST");

            // input/output streams
            tokenConnection.setDoOutput(true);

            // write the request data to the output stream
            try (DataOutputStream tokenOutputStream = new DataOutputStream(tokenConnection.getOutputStream())) {
                tokenOutputStream.writeBytes(requestData);
                tokenOutputStream.flush();
            }

            // get the response code token endpoint
            int tokenResponseCode = tokenConnection.getResponseCode();

            // read the response data 
            try (BufferedReader tokenReader = new BufferedReader(new InputStreamReader(tokenConnection.getInputStream()))) {
                String tokenInputLine;
                StringBuilder tokenResponse = new StringBuilder();

                while ((tokenInputLine = tokenReader.readLine()) != null) {
                    tokenResponse.append(tokenInputLine);
                }

                // handle response data
                String responseDataStr = tokenResponse.toString();

                // parse response as JSON
                JSONObject jsonResponse = new JSONObject(responseDataStr);

                // extract access_token and id_token
                String access_token = jsonResponse.getString("access_token");
                String id_token = jsonResponse.getString("id_token");

                // store tokens in session attributes
                request.getSession().setAttribute("access_token", access_token);
                request.getSession().setAttribute("id_token", id_token);

                response.sendRedirect("profile.jsp");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>