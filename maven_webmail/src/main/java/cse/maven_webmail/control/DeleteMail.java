/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cse.maven_webmail.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ldh22
 */
public class DeleteMail extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement psmt = null;

        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            // 데이터베이스 연결
                        String dbURL = "jdbc:mysql://192.168.35.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
                        String dbID = "jspmail";
                        String dbPassword = "jspteamproject!!!";
            // 파라미터 불러오기
            String receiver = request.getParameter("receiver");
            String title = request.getParameter("title");
            String date = request.getParameter("date");
            int check = 0;// DB Success or Fail Check
            // 데이터 베이스 연결 및 쿼리문
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            Class.forName("com.mysql.cj.jdbc.Driver");
            String sql = "INSERT INTO TRASH SELECT * FROM SENT_MAILBOX where receiver=? and subject=? and date =?";
            psmt = conn.prepareStatement(sql);

            psmt.setString(1, receiver);
            psmt.setString(2, title);
            psmt.setString(3, date);

            check = psmt.executeUpdate();

            if (check == 1) {//Sucess
                String sql2 = "DELETE FROM SENT_MAILBOX where receiver=? and subject=? and date =?";
                psmt = conn.prepareStatement(sql2);
                psmt.setString(1, receiver);
                psmt.setString(2, title);
                psmt.setString(3, date);
                psmt.executeUpdate();
                check = psmt.executeUpdate();

                if (check == 0) {//Sucess
                    StringBuilder SuccessPopup = new StringBuilder();
                    SuccessPopup.append("<script>alert('삭제 되었습니다!'); location.href='trash.jsp';</script>");
                    out.println(SuccessPopup.toString());

                } else {//Fail
                    StringBuilder FailPopup = new StringBuilder();
                    FailPopup.append("<script>alert('실패 했습니다!'); location.href='trash.jsp';</script>");
                    out.println(FailPopup.toString());
                }

            } else {//Fail
                StringBuilder FailPopup = new StringBuilder();
                FailPopup.append("<script>alert('실패 했습니다!'); location.href='trash.jsp';</script>");
                out.println(FailPopup.toString());
            }

            psmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (psmt != null) {
                    psmt.close();
                }
            } catch (SQLException e) {
                e.toString();
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.toString();
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException ifs an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
