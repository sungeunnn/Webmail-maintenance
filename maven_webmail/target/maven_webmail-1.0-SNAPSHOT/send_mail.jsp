<%-- 
    Document   : send_mail
    Created on : 2021. 5. 23, 오후 5:10:42
    Author     : ldh22
    기능 : 보낸 메일함
--%>

<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="cse.maven_webmail.control.CommandType" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />

    </head>
    <body>

        <jsp:include page="header.jsp" />

        <div id="sidebar">
            <jsp:include page="sidebar_menu.jsp" />
        </div>

        <div id="main">
            <table border="1">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>받은 사람</th>
                        <th>참조</th>
                        <th>제목</th>
                        <th>보낸 날짜</th>
                        <th>삭제</th>
                    </tr>

                </thead>
                <tbody>
                    <%
                        Connection conn;
                        PreparedStatement psmt;
                        //DB연결
                        String userid = (String) session.getAttribute("userid");
                        String dbURL = "jdbc:mysql://192.168.35.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
                        String dbID = "jspmail";
                        String dbPassword = "jspteamproject!!!";
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                        String sql = "SELECT* FROM SENT_MAILBOX WHERE username=?";
                        psmt = conn.prepareStatement(sql);
                        psmt.setString(1, userid);
                        ResultSet rs = psmt.executeQuery();
                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs.getString("idx") + "</td>");
                            out.println("<td>" + rs.getString("receiver") + "</td>");
                            out.println("<td>" + rs.getString("cc") + "</td>");
                            out.println("<td>" + "<a href=show_send_mail.jsp?title=" + URLEncoder.encode(rs.getString("subject"),"UTF-8") + "&date="
                            + URLEncoder.encode(rs.getString("date"),"UTF-8") + ">" + rs.getString("subject") + "</a>" + "</td>");
                            out.println("<td>" + rs.getString("date") + "</td>");
                            out.println("<td>" + "<a href=delete_send_mail.jsp?receiver=" + URLEncoder.encode(rs.getString("receiver"),"UTF-8") + "&title="
                            + URLEncoder.encode(rs.getString("subject"),"UTF-8") + "&date=" + URLEncoder.encode(rs.getString("date"),"UTF-8") + ">" + "삭제" + "</a>" + "</td>");
                            out.println("</tr>");
                        }
                        psmt.close();
                        rs.close();
                        conn.close();
                    %>

                </tbody>
            </table>
        </div>


        <jsp:include page="footer.jsp" />

    </body>
</html>
