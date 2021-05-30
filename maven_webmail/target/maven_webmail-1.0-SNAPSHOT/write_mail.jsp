
<%@page import="cse.maven_webmail.control.WriteMailHandler"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%-- 
    Document   : write_mail.jsp
    Author     : jongmin
    기능 : 메일 쓰기
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="cse.maven_webmail.control.CommandType" %>

<!DOCTYPE html>

<%-- @taglib  prefix="c" uri="http://java.sun.com/jsp/jstl/core" --%>


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
            <form enctype="multipart/form-data" method="POST"  name="send_form"
                  action="WriteMail.do?menu=<%= CommandType.SEND_MAIL_COMMAND%>" >
                <table>
                    <tr>
                        <td> 수신 </td>
                        <td> 
<!--                            <input type="text"  name="to" size="80" id="to"
                                   value=<%=request.getParameter("reciver") == null ? "" : request.getParameter("reciver")%>>  -->
                            <% if(CommandType.grp_state == false) {%>
                            <input type="text" name="to" size="80" id="to"
                                    value=<%=
                                        request.getParameter("reciver") == null ? "" : request.getParameter("reciver")%>>  
                            <% } else if(CommandType.grp_state == true){ CommandType.grp_state = false; %>
                            <input type="text" name="to" size="80" id="to"
                                    value=<%=CommandType.rcv_emails%>>  <% } %>
                        </td>
                    </tr>
                    <tr>
                        <td>참조</td>
                        <td> <input type="text" name="cc" id="cc" size="80">  </td>
                    </tr>
                    <tr>
                        <td> 메일 제목 </td>
                        <td> <input type="text"  name="subj" id="subj" size="80"  >  </td>
                    </tr>
                    <tr>
                        <td colspan="2">본  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 문</td>
                    </tr>
                    <tr>  <%-- TextArea    --%>
                        <td colspan="2">  <textarea rows="15"  name="body" id="body" cols="80"></textarea> </td>
                    </tr>
                    <tr>
                        <td>첨부 파일</td>
                        <td> <input type="file" name="file1"  size="80">  </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="메일 보내기" onclick="tem_flagChange()">
                            <input type="reset" value="다시 입력">
                        </td>
                    </tr>
                </table>
            </form>
                    <%-- TemMailHandler사용준비--%>
                       <%-- https://killsia.tistory.com/entry/JSP%EC%99%80-%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8%EA%B0%84%EC%9D%98-%EC%A0%95%EB%B3%B4-%EC%A0%84%EC%86%A1%EB%B0%A9%EB%B2%95 --%>
                       
                         <iframe name='ifrm' width='0' height='0' frameborder='0'></iframe>  
                         
             <script type="text/javascript">
                 
                 var tem_flag=true;
                 
                     function tem_mail(){
                          console.log('beunload'); 
                          const to = document.getElementById('to').value;
                          const cc = document.getElementById('cc').value;
                          const subj = document.getElementById('subj').value;
                          const body = document.getElementById('body').value;
                          console.log(to);
                          console.log(cc);
                          console.log(subj);
                          console.log(body);
                          
                          document.send_form.target = 'ifrm';
                          document.send_form.action = 'TemMail.do?menu=<%= CommandType.TEM_MAIL_COMMAND%>';
                          document.send_form.submit();
                          
                          console.log(tem_flag);
                     }
                     
                     
                     function tem_flagChange(){
                         tem_flag=false;
                          console.log(tem_flag);
                     }
                     
                     window.onbeforeunload = function(){
                        if(tem_flag===true){
                             tem_mail();
                              return 0;
                   }
                  window.onload = function(){
                      console.log(tem_flag);
                  }
               }

	</script>
        </div>

        <jsp:include page="footer.jsp" />
    </body>
</html>
