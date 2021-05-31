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
        
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <script type="text/javascript">
            $(function(){ 
                $("#alert-success").hide(); 
                $("#alert-danger").hide(); 
                $("input").keyup(function(){ 
                    var pwd1=$("#password").val(); 
                    var pwd2=$("#password_check").val(); 
                    if(pwd1 !== "" || pwd2 !== ""){ 
                        if(pwd1 === pwd2){ 
                            $("#alert-success").show(); 
                            $("#alert-danger").hide(); 
                            $("#register").removeAttr("disabled"); 
                        }else{ 
                            $("#alert-success").hide(); 
                            $("#alert-danger").show(); 
                            $("#register").attr("disabled", "disabled");
                        } 
                    } 
                }); 
            }); 
        </script>


    </head>
    <body>
        <%@include file="header.jspf"%>
   
        <div id="signup_form" align ="center">
            <form  name="AddUser" action="UserAdmin.do?menu=<%= CommandType.ADD_USER_COMMAND%>"
                  method="POST">
                <br />
                <br />
                <table border="1px" bordercolor="grey" display="inline-block">
                    <tbody>
                        <tr>
                            <td colspan="2" bgcolor="lightgrey" glign="center">회원가입</td>
                        </tr>
                        <tr>
                            <td bgcolor="lightgrey" align="center"> ID </td>
                            <td> 
                                <input size="35" type="text" name="id" pattern="[a-zA-Z0-9+]{4,12}"
                                       placeholder="4~12자의 영문 및 숫자로만 입력">
                           </td>
                        </tr>
                        <tr>
                            <td bgcolor="lightgrey" align="center"> 비밀번호 </td>
                            <td >
                                <input size="35" type="password" name="password" id="password" pattern="[a-zA-Z0-9+]{2,10}"
                                       placeholder="2~10자의 영문 및 숫자로만 입력"> 
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="lightgrey" align="center"> 비밀번호 확인 </td>
                            <td><input size="35" type="password" name="password_check" id="password_check" pattern="[a-zA-Z0-9+]{2,10}"
                                        placeholder="비밀번호를 한번 더 입력해주세요">
                            </td>
                        </tr>  
                      </tbody>
                 </table>
                  <br />
                  <div style="font-size: 5%; font-weight: 600;">"ID 형식을 지키지 않을 시 회원가입이 되지 않습니다."<br>
                      "비밀번호 값과 비밀번호 확인 값이 일치하면 확인버튼이 활성화됩니다"</div>
                  <div class="alert alert-success" id="alert-success" align="center" style="color: blue; font-size: 7%;" > 비밀번호가 일치합니다.</div>
                  <div class="alert alert-danger" id="alert-danger"  align="center" style="color: red; font-size: 7%;"> 비밀번호가 일치하지 않습니다.</div>
                  <p align ="center">
                      &nbsp;&nbsp;&nbsp;<input type="submit" value="확인" name="register" id="register" disabled="">
                     &nbsp;&nbsp;&nbsp;<input type="reset" value="다시 입력">
                  </p>
                  
            </form>
         </div>
           <%@include file="footer.jspf"%>
    </body>
   
</html>
