<%-- 
    Document   : main_menu.jsp
    Author     : jongmin
    기능 : 메인메뉴(받은 메일함)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="cse.maven_webmail.control.CommandType" %>


<!DOCTYPE html>

<jsp:useBean id="pop3" scope="page" class="cse.maven_webmail.model.Pop3Agent" />
<%
    pop3.setHost((String) session.getAttribute("host"));
    pop3.setUserid((String) session.getAttribute("userid"));
    pop3.setPassword((String) session.getAttribute("password"));
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>주메뉴 화면</title>
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
                        Connection conn = null;
                        PreparedStatement psmt = null;
                        int idx = 1;
                        //DB 연결 - 사용자에 맞게 URL ID PW 변경하세요
                        String userid = (String) session.getAttribute("userid");
                        String dbURL = "jdbc:mysql://192.168.35.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
                        String dbID = "jspmail";
                        String dbPassword = "jspteamproject!!!";
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                        //DB 쿼리문
                        String sql = "SELECT * FROM SENT_MAILBOX WHERE receiver=?";
                        psmt = conn.prepareStatement(sql);
                        psmt.setString(1, userid);
                        ResultSet rs = psmt.executeQuery();


                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + idx + "</td>");
                            out.println("<td>" + rs.getString("receiver") + "</td>");
                            out.println("<td>" + rs.getString("cc") + "</td>");
                            out.println("<td>" + "<a href=show_mail.jsp?title=" + URLEncoder.encode(rs.getString("subject"),"UTF-8")
                                    + "&date=" + URLEncoder.encode(rs.getString("date"),"UTF-8") + ">" + rs.getString("subject") + "</a>" + "</td>");
                            out.println("<td>" + rs.getString("date") + "</td>");
//                            out.println("<td>" + "<a href=delete_mail.do?&title="+ URLEncoder.encode(rs.getString("subject"),"UTF-8") + "&date=" + URLEncoder.encode(rs.getString("date"),"UTF-8") + ">" + "삭제" + "</a>" + "</td>");
                            out.println("<td>" + "<a href=delete_mail.do?receiver=" + URLEncoder.encode(rs.getString("receiver"),"UTF-8") + "&title="
                            + URLEncoder.encode(rs.getString("subject"),"UTF-8") + "&date=" + URLEncoder.encode(rs.getString("date"),"UTF-8") + ">" + "삭제" + "</a>" + "</td>");
                            out.println("</tr>");
                            idx++;
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
