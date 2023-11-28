package com.services;

import javax.servlet.http.HttpServletRequest;
public class AuthUtil {
	  public static boolean isAuthenticated(HttpServletRequest request) {
	        // user is logged in or not
	        return request.getSession().getAttribute("username") != null;
	    }

}