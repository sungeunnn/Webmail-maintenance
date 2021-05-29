<%-- 
    Document   : write_tem_mail
    Created on : 2021. 5. 28., 오전 4:35:23
    Author     : yoon
--%>


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
        <title>메일 쓰기 화면</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" />
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div id="sidebar">
            <jsp:include page="sidebar_previous_menu.jsp" />
        </div>
               <div id="main">
            <form enctype="multipart/form-data" method="POST"
                  action="TemMail.do?menu=<%= CommandType.SEND_MAIL_COMMAND%>" >
                <table>
                    
                    <%
                        Connection conn;
                        PreparedStatement psmt;
                        //DB연결
                        String userid = (String) session.getAttribute("userid");
                        String receiver = request.getParameter("receiver");
                        String date = request.getParameter("date");
                        String dbURL = "jdbc:mysql://192.168.35.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
                        String dbID = "jspmail";
                        String dbPassword = "jspteamproject!!!";
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                        String sql = "SELECT* FROM tem_mail WHERE username=? and receiver=? and date=?";
                        
                        psmt = conn.prepareStatement(sql);
                        psmt.setString(1, userid);
                        psmt.setString(2, receiver);
                        psmt.setString(3, date);
                        ResultSet rs = psmt.executeQuery();
                        
                        // 텍스트박스에 임시저장된 내용 삽입.
                        while (rs.next()) {
                            //수신자
                            out.println("<tr>");
                            out.println("<td> 수신 </td>");
                            out.println("<td> "+ "<input type=text class=myInput name=to size=80"+"\t"+"value="+rs.getString("receiver") +">" +"</td>");
                            out.println("</tr>");
                            // 참조
                            out.println("<tr>");
                            out.println("<td> 참조 </td>");
                            out.println("<td> "+ "<input type=text name=cc size=80"+"\t"+"value="+rs.getString("cc") +">" +"</td>");
                            out.println("</tr>");
                            //메일제목
                            out.println("<tr>");
                            out.println("<td> 메일 제목 </td>");
                            out.println("<td> "+ "<input type=text name=subj size=80"+"\t"+"value="+rs.getString("subject") +">" +"</td>");
                            out.println("</tr>");
                            //본문
                            out.println("<tr>");
                            out.println("<td  colspan=2> 본  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 문 </td>");
                            out.println("</tr>");
                            //본문내용
                            out.println("<tr>");
                            out.println("<td  colspan=2> "+ "<textarea rows=15  name=body cols=80"+"\t"+"value="+">"+rs.getString("body") +"</textarea>" +"</td>");
                            out.println("</tr>");
                            //첨부파일
                            out.println("<tr>");
                            out.println("<td>첨부 파일</td>");
                            out.println("<td> "+ "<input type=file name=file1 size=80>" +"</td>");
                            out.println("</tr>");
                            //버튼
                            out.println("<tr>");
                            out.println("<td  colspan=2> <input type=submit value=메일다시보내기>" + "</td>");
                            out.println("</tr>");
                        }

                        psmt.close();
                        rs.close();
                        conn.close();
                    %>
                </table>
            </form>

        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
