<%-- 
    Document   : show_addrbook.jsp
    Author     : 강수나
--%>

<%@page import="cse.maven_webmail.control.CommandType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib tagdir="/WEB-INF/tags" prefix="mytags"%>

<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> 주소록 </title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div id="sidebar">
            <jsp:include page="sidebar_previous_menu.jsp" />
        </div>
        <div id="main">
            
            <h2>주소록</h2>
            <c:catch var="errorReason">  
                <mytags:addrbook userid= "${userid}"
                addAddrMenu="<%= CommandType.ADD_ADDR_MENU%>" 
                delAddrMenu="<%= CommandType.DEL_ADDR_MENU%>"
                delGrpMenu="<%= CommandType.DEL_GRP_MENU%>"
                sendGrpMailMenu="<%= CommandType.SEND_GRP_MAIL_MENU%>"
                updateAddrMenu="<%= CommandType.UPDATE_ADDR_MENU%>"
                updateGrpMenu="<%= CommandType.UPDATE_GRP_MENU%>"/>
            </c:catch>
            ${empty errorReason? "<noerror/>":errorReason}
            
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>
