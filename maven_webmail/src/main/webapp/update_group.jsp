<%-- 
    Document   : make_group
    Created on : 2021. 5. 28, 오전 10:49:28
    Author     : Owner
--%>

<%@page import="cse.maven_webmail.control.CommandType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>그룹 이름 변경</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>
    <body>
        <br><br>
        <form action="Group.do" method="POST">
            <input type="hidden" name="menu" value="<%= CommandType.UPDATE_GRP_MENU%>"/>
            <input type="hidden" name="userid" value="${userid}"/>
            <input type="hidden" name="group_name" id = "group_name_"/>
            <table border="0" align="center" width="300" height="100" style="margin-left: auto; margin-right: auto;">
                <tr>
                    <td>그룹명</td>
                    <td> <input type="text" name="new_group_name" id="group_name_"  size="20" />  </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="변경" name="register"  onclick= "window.opener.location.replace('show_addrbook.jsp')"> 
                        <input type="button" value="창닫기" onclick="top.window.close()">
                    </td>
                </tr>
            </table>    
        </form>
    </body>
</html>
