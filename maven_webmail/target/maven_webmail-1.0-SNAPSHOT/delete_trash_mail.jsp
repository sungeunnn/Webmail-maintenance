<%-- 
    Document   : delete_mail
    Created on : 2021. 5. 23., 오후 5:10:42
    Author     : ldh22
    기능 : 휴지통 삭제
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Connection conn = null;
            PreparedStatement psmt = null;
            int check = 0;
            String dbURL = "jdbc:mysql://172.28.16.1:3306/james2?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
            String dbID = "james2users";
            String dbPassword = "1234";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            String sql = "DELETE FROM TRASH WHERE receiver=? and subject=? and date =?";
            psmt = conn.prepareStatement(sql);
            
            psmt.setString(1, request.getParameter("receiver"));
            psmt.setString(2, request.getParameter("title"));
            psmt.setString(3, request.getParameter("date"));

            check = psmt.executeUpdate(); // 업데이트가 성공적으로 되면

            if (check >= 1) {%>
        <script>
            alert('삭제되었습니다!');
            location.href = "trash.jsp";
        </script>
        <%
            } else {%>
        <script>
            alert('에러 발생');
            window.history.back();
        </script>
        <%}
            psmt.close();
            conn.close();
        %>

    </body>
</html>
