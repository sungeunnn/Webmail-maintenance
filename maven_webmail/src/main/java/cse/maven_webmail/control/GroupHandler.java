/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cse.maven_webmail.control;

import com.mysql.cj.protocol.Resultset;
import static cse.maven_webmail.control.CommandType.rcv_emails;
import static cse.maven_webmail.control.CommandType.grp_state;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.JOptionPane;
import static javax.swing.JOptionPane.showMessageDialog;

/**
 *
 * @author Owner
 */
public class GroupHandler extends HttpServlet {

    private String group_name;
    private String userid;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, NamingException, SQLException {

        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int selected_menu = Integer.parseInt((String) request.getParameter("menu"));
        PrintWriter out = null;

        userid = request.getParameter("userid");
        group_name = request.getParameter("group_name");

        switch (selected_menu) {
            case CommandType.ADD_GRP_MENU:  //그룹 추가
                out = response.getWriter();
                addGroup(request, response, out);
                break;
            case CommandType.DEL_GRP_MENU:  //그룹 삭제
                out = response.getWriter();
                delGroup(request, response, out);
                break;
            case CommandType.SEND_GRP_MAIL_MENU:  //그룹 메일 보내기
                out = response.getWriter();
                sendGroupMail(request, response, out);
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

    //그룹 추가
    private void addGroup(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws ServletException, IOException, NamingException, SQLException {
        try {
            String sql = "INSERT INTO grp(group_name) VALUES(?)";
            PreparedStatement pstmt = Connect().prepareStatement(sql);  //3.PreparedStatement 객체 생성
            group_name = request.getParameter("group_name");
            if (group_name == "" || group_name == null) {
                out.println("<script>alert('그룹명을 입력해주세요.'); location.href='make_group.jsp';</script>");
                out.close();
            } else {
                //4.sql문 완성
                pstmt.setString(1, group_name);
                //5.실행(갱신되는 행 개수)
                pstmt.executeUpdate();  //여기서 오류

                out.println("<script>alert('추가되었습니다.'); location.href='make_group.jsp';</script>");
                out.close();
            }
            pstmt.close();
            
            //out.println("됨" + new_group);
        } catch (Exception ex) {
            out.println("접속 실패 - catch" + group_name);
        }
    }

    //그룹 삭제
    private void delGroup(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws ServletException, IOException, NamingException, SQLException {
        try {
            String sql_ = "SELECT email FROM addrbook WHERE group_name=?";
            PreparedStatement pstmt_ = Connect().prepareStatement(sql_);
            pstmt_.setString(1, group_name);
            ResultSet rs = pstmt_.executeQuery();
            String strRs = null;
            while (rs.next()) {
                strRs = rs.getString(1);
            }

            if (strRs == null) {
                String sql = "DELETE FROM grp WHERE group_name=?";
                PreparedStatement pstmt = Connect().prepareStatement(sql);
                pstmt.setString(1, group_name);
                pstmt.executeUpdate();  //오류
                pstmt.close();
                response.sendRedirect("show_addrbook.jsp");
            } else {
                //pstmt_.close();
                //Connect().close();
                out.println("<script>alert('구성원이 존재합니다.'); location.href='show_addrbook.jsp';</script>"); 
                out.close();
                pstmt_.close();
                response.sendRedirect("show_addrbook.jsp");
            }
        } catch (Exception ex) {
            out.println("접속 실패 - catch" + group_name);
        }
    }

    //그룹 메일 보내기
    private void sendGroupMail(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws ServletException, IOException, NamingException, SQLException {
        try {
            String sql = "SELECT email FROM addrbook WHERE userId=? and group_name=?"; // SELECT email FROM addrbook WHERE userId=? and group_name=?
            PreparedStatement pstmt = Connect().prepareStatement(sql);  //3.PreparedStatement 객체 생성    
            //4.sql문 완성
            pstmt.setString(1, userid);
            pstmt.setString(2, group_name);
            //5.실행
            ResultSet rs = pstmt.executeQuery(); //여기서 오류

            String email_ = null;
            int state = 0;
            grp_state = true;
            rcv_emails = "";
            while (rs.next()) {
                email_ = rs.getString(1);
                if (state == 0) {
                    rcv_emails = email_;
                } else {
                    rcv_emails = rcv_emails + "," + email_;
                }
                state++;
            }
            if (rcv_emails == "") {
                out.println("<script>alert('그룹 구성원이 없습니다.'); location.href='show_addrbook.jsp';</script>");
                out.close();
            }
            pstmt.close();
            response.sendRedirect("write_mail.jsp");
        } catch (Exception ex) {
            out.println("접속 실패 - catch " + group_name + userid);
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
