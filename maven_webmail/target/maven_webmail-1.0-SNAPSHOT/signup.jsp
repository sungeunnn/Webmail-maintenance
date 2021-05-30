<%-- 
    Document   : sign_up
    Created on : 2021. 5. 8., 오후 11:20:51
    Author     : sungeun
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="cse.maven_webmail.control.CommandType"%>
<!DOCTYPE html>
<html>
     <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>회원가입</title>
        <link type="text/css" rel="stylesheet" href="css/main_style.css" /> 
        
        <script>
            fuction goindex(){
                location.replace="index.jsp";
            }
         </script>
    </head>
    <body>
       <%@include file="header.jspf"%>
       
       <section>
           <h1 align="center">회원가입<br></h1>
       </section>
       
       <div id="signup_form" align ="center">
            <form  name="AddUser" action="UserAdmin.do?menu=<%= CommandType.ADD_USER_COMMAND%>"
                   method="POST">
                아이디<br>
                <input size="35" type="text" name="id" pattern="[a-zA-Z0-9+]{4,12}"
                       placeholder="4~12자의 영문 및 숫자로만 입력해주세요"><br>
                
                비밀번호<br>
                <input size="35" type="password" name="password" pattern="[a-zA-Z0-9+]{2,10}"
                       placeholder="2~10자의 영문 및 숫자로만 입력해주세요"><br>
                
                비밀번호 확인<br>
                <input size="35" type="password" name="password_check" pattern="[a-zA-Z0-9+]{2,10}"
                       placeholder="비밀번호를 한번 더 입력해주세요"><br>
                
                <p align ="center">
                     <input type="submit" value="확인" name="register">&nbsp;&nbsp;&nbsp;
                     <input type="reset" value="다시 입력">&nbsp;&nbsp;&nbsp;
                </p>
            </form>
       </div>
                   <%@include file="footer.jspf"%>
    </body>
</html>
