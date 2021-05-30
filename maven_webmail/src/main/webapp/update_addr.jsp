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
        <title>주소록 수정</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>
    <body>
        <form action="AddrBook.do" method="POST">
            <input type="hidden" name="menu" value="${addAddrMenu}"/>
            <input type="hidden" name="userid" value="${userid}"/>
            <table border="0" align="left">
                <tr>
                    <td>이름 *</td>
                    <td> <input type="text" name="nickname" value="${row.nickname}" size="20" />  </td>
                </tr>
                <tr>
                    <td>ID *</td>
                    <td> <input type="text" name="email" value="" size="20" />   </td>
                </tr>
                <tr>
                    <td>전화번호 </td>
                    <td> <input type="text" name="phone" value="" size="20" />   </td>
                </tr>
                <tr>
                    <td>그룹 </td>  
                    <td> 
                        <c:if test="${!empty group_rs.rows}" >
                            <select name="grpName" id="grpName" style="width:160px;">
                                <option value="없음" selected="">미지정</option>
                                <c:forEach var="row" items="${group_rs.rows}" varStatus="i">
                                    <option value="${row.group_name}">${row.group_name}</option>
                                </c:forEach>
                            </select>
                        </c:if>
                        <br> 
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="수정" name="register" />
                        <input type="reset" value="취소" name="reset" />
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
