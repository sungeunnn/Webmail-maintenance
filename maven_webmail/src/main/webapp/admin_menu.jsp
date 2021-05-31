<%-- 
    Document   : admin_menu.jsp
    Author     : jongmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@page import="cse.maven_webmail.model.UserAdminAgent"%>
<%@page import="cse.maven_webmail.model.UserlistAgent"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>사용자 관리 메뉴</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div id="sidebar">
            <jsp:include page="sidebar_admin_menu.jsp" />
        </div>

        <div id="main">
            <h2> 메일 사용자 목록 </h2>
            <%
                        String cwd =  this.getServletContext().getRealPath(".");
            %>
            
            <jsp:useBean id="userlistAgent" scope="page" class="cse.maven_webmail.model.UserlistAgent"/>
            <c:set target="${userlistAgent}" property="cwd" value="${cwd}" />
            <jsp:setProperty name="userlistAgent" property="cwd" value="<%= cwd %>"/>
 
            <ul>
                 <c:forEach items="${userlistAgent.getUserList()}" var="item">
                         <li>${item}</li>
                 </c:forEach>
                
            </ul>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
