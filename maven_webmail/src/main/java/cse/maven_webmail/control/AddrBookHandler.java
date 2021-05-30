/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cse.maven_webmail.control;

import cse.maven_webmail.model.Pop3Agent;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 주소록 데이터베이스 연결
 *
 * @author Owner
 */
public class AddrBookHandler extends HttpServlet {

    private String userid;
    private String nickname;
    private String email;
    private String phone;
    private String grpName;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, NamingException, SQLException {

        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int selected_menu = Integer.parseInt((String) request.getParameter("menu"));
        PrintWriter out = null;

        userid = request.getParameter("userid");
        nickname = request.getParameter("nickname");
        email = request.getParameter("email");
        phone = request.getParameter("phone");
        grpName = request.getParameter("grpName");

        switch (selected_menu) {
            case CommandType.ADD_ADDR_MENU:  //주소록에 추가
                out = response.getWriter();
                addAddress(request, response, out);
                break;
            case CommandType.DEL_ADDR_MENU:  //주소록에서 삭제
                out = response.getWriter();
                delAddress(request, response, out);
                break;
            default:
                break;
        }
    }

    private Connection Connect() throws NamingException, SQLException {
        //1.Context & DataSource 검색
        String name = "java:/comp/env/jdbc/AddrBookDB";
        javax.naming.Context ctx = new javax.naming.InitialContext();
        javax.sql.DataSource ds = (javax.sql.DataSource) ctx.lookup(name);
        //2.Connection 객체 생성
        Connection conn = ds.getConnection();
        return conn;
    }

    private void addAddress(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws ServletException, IOException, NamingException, SQLException {
        try {
            String sql = "INSERT INTO addrbook VALUES(?, ?, ?, ?, ?)";
            PreparedStatement pstmt = Connect().prepareStatement(sql);  //3.PreparedStatement 객체 생성
            if ((nickname == null || nickname == "")||(email == null || email == "")) {
                out.println("<script>alert('이름과 ID는 필수항목입니다.'); location.href='show_addrbook.jsp';</script>");
                out.close();
            }
            else{
                nickname = request.getParameter("nickname");
                email = request.getParameter("email");
                phone = request.getParameter("phone");
                grpName = request.getParameter("grpName");
                //4.sql문 완성
                pstmt.setString(1, userid);
                pstmt.setString(2, nickname);
                pstmt.setString(3, email);
                pstmt.setString(4, phone);
                pstmt.setString(5, grpName);
                //5.실행(갱신되는 행 개수)
                pstmt.executeUpdate();  //오류
                pstmt.close();
                response.sendRedirect("show_addrbook.jsp");
            }

        } catch (Exception ex) {
            out.println("접속 실패 - catch" + userid + nickname + email + phone + grpName);
        }
    }

    private void delAddress(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws ServletException, IOException, NamingException, SQLException {
        try {
            String sql = "DELETE FROM addrbook WHERE userId=? and email=?";
            PreparedStatement pstmt = Connect().prepareStatement(sql);  //3.PreparedStatement 객체 생성
            if (!(userid == null) && !(userid == "")) {
                //4.sql문 완성
                pstmt.setString(1, userid);
                pstmt.setString(2, email);
                //5.실행(갱신되는 행 개수)
                pstmt.executeUpdate();  //오류
                pstmt.close();
                response.sendRedirect("show_addrbook.jsp");
            } else {
                out.println("접속 실패 - else" + userid + nickname + email + phone + grpName);
            }

        } catch (Exception ex) {
            out.println("접속 실패 - catch" + userid + nickname + email + phone + grpName);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            processRequest(req, resp); //To change body of generated methods, choose Tools | Templates.
        } catch (NamingException ex) {
            Logger.getLogger(AddrBookHandler.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AddrBookHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            processRequest(req, resp); //To change body of generated methods, choose Tools | Templates.
        } catch (NamingException ex) {
            Logger.getLogger(AddrBookHandler.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(AddrBookHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return super.getServletInfo(); //To change body of generated methods, choose Tools | Templates.
    }
}
