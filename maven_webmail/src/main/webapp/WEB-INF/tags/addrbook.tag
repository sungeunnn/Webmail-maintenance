<%-- 
    Document   : addrbook
    Author     : 강수나
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@attribute required="true" name="userid" %>
<%@attribute required="true" name="addAddrMenu" type="java.lang.Integer" %>
<%@attribute required="true" name="delAddrMenu" type="java.lang.Integer" %>
<%@attribute required="true" name="delGrpMenu" type="java.lang.Integer" %>
<%@attribute required="true" name="sendGrpMailMenu" type="java.lang.Integer" %>
<%@attribute required="true" name="updateAddrMenu" type="java.lang.Integer" %>
<%@attribute required="true" name="updateGrpMenu" type="java.lang.Integer" %>

<sql:query var="addr_rs" dataSource="jdbc/AddrBookDB">
    SELECT * FROM addrbook WHERE userId='${userid}'
</sql:query>

<sql:query var="group_rs" dataSource="jdbc/AddrBookDB">
    SELECT * FROM grp
</sql:query>

주소록에 등록할 사용자의 이름, 이메일, 전화번호를 입력해주세요. <br> <br>
<form action="AddrBook.do" method="POST">
    <input type="hidden" name="menu" value="${addAddrMenu}"/>
    <input type="hidden" name="userid" value="${userid}"/>
    <table border="0" align="left">
        <tr>
            <td>이름 *</td>
            <td> <input type="text" name="nickname" value="" size="20" />  </td>
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
                <input type="submit" value="추가" name="register" />
                <input type="reset" value="취소" name="reset" />
            </td>
        </tr>
    </table>
</form>

<table border="1"style="float:left;">
    <thead>
        <tr>
            <th>이름</th>
            <th>ID</th>
            <th>전화번호</th>
            <th>그룹</th>
            <!--            <th>수정</th>-->
            <th>삭제</th>
            <th>메일전송</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${addr_rs.rows}">
            <tr>
                <td>${row.nickname}</td>
                <td>${row.email}</td>
                <td>${row.phone}</td>
                <td>${row.group_name}</td>
                <td>
                    <form action="AddrBook.do" method="POST">
                        <input type="hidden" name="menu" value="${delAddrMenu}"/>
                        <input type="hidden" name="userid" value="${userid}"/>   
                        <input type="hidden" name="email" value="${row.email}"/>
                        <input type="submit" value="삭제" name="delete" />
                    </form>
                </td>
                <td>
                    <form action="write_mail.jsp" method="POST">
                        <input type="hidden" name="recv" value="${row.email}">
                        <input type="submit" value="메일전송">
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<table border="1" style="float:left;">
    <thead>
        <tr>
            <th>그룹이름</th>
            <th>삭제</th>
            <th>메일전송</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${group_rs.rows}">
            <tr>
        <input type="hidden" name="menu" value="${updateGrpMenu}"/>
        <input type="hidden" name="userid" value="${userid}"/>
        <td>${row.group_name}</td>
        <td>
            <form action="Group.do" method="POST">
                <input type="hidden" name="menu" value="${delGrpMenu}"/>
                <input type="hidden" name="group_name" value="${row.group_name}"/>
                <input type="hidden" name="userid" value="${userid}"/>
                <input type="submit" value="삭제" name="delete" />
            </form>
        </td>
        <td>
            <form action="Group.do" method="POST">
                <input type="hidden" name="menu" value="${sendGrpMailMenu}"/>
                <input type="hidden" name="group_name" value="${row.group_name}"/>
                <input type="hidden" name="userid" value="${userid}"/>
                <input type="submit" value="메일전송" name="send" />
            </form>
        </td>
    </tr>
</c:forEach>
</tbody>
</table>

<input type="button" value="그룹 추가" onclick="window.open('make_group.jsp', '그룹 추가', 'width=500, height=200')" style="float:left;">
