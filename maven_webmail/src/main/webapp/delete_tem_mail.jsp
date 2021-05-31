<%-- 
    Document   : delete_temmail
    Created on : 2021. 5. 28., 오전 4:10:58
    Author     : yoon
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
            String dbURL = "jdbc:mysql://34.64.170.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
            String dbID = "yoonjsp";
            String dbPassword = "jspteamproject!!!";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            String sql = "DELETE FROM tem_mail WHERE receiver=? and subject=? and date =?";
            psmt = conn.prepareStatement(sql);

            psmt.setString(1, request.getParameter("receiver"));
            psmt.setString(2, request.getParameter("title"));
            psmt.setString(3, request.getParameter("date"));

            check = psmt.executeUpdate(); // 업데이트가 성공적으로 되면

            if (check >= 1) {%>
        <script>
            alert('삭제되었습니다!');
            location.href = "save_mail.jsp";
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
