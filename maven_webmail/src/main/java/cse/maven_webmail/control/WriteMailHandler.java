/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package cse.maven_webmail.control;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import cse.maven_webmail.model.FormParser;
import cse.maven_webmail.model.SmtpAgent;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author jongmin
 * 메일 쓰기 기능
 */
public class WriteMailHandler extends HttpServlet {

    int count = 0;
    FormParser parser;
    PrintWriter out = null;
    Connection conn = null;
    private ResultSet rs;

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
        response.setContentType("text/html;charset=UTF-8");

        try ( PrintWriter out = response.getWriter()) {
            request.setCharacterEncoding(StandardCharsets.UTF_8.name());
            int select = Integer.parseInt(request.getParameter("menu"));

            if (select == CommandType.SEND_MAIL_COMMAND) { // 실제 메일 전송하기
                boolean status = sendMessage(request);
                // 2.  request 객체에서 HttpSession 객체 얻기
                HttpSession session = (HttpSession) request.getSession();

                // 3. HttpSession 객체에서 메일 서버, 메일 사용자 ID 정보 얻기
                String userid = (String) session.getAttribute("userid");
                String receiver = parser.getToAddress();

                String cc;
                if (parser.getCcAddress().equals("")) {
                    cc = parser.getCcAddress().replace("", "&nbsp");
                } else {
                    cc = parser.getCcAddress();
                }
                String subject;
                if (parser.getSubject().equals("")) {
                    subject = parser.getSubject().replace("", "제목 없음");
                } else {
                    subject = parser.getSubject();
                }
                String date = new java.util.Date().toString();
                String body = parser.getBody().replace("<", "&lt;").replace(">", "&gt;");

                if (receiver.contains(",")) {
                    String[] receivers = receiver.split(",");
                    write(userid, receivers, cc, subject, body);
                } else {
                    write(userid, receiver, cc, subject, body);
                }
                out.print(getMailTransportPopUp(status));
            } else {
                out.println("없는 메뉴를 선택하셨습니다. 어떻게 이 곳에 들어오셨나요?");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getNext() { // 인덱스 늘리기 기능
        String SQL = "SELECT idx FROM `jspmail`.`SENT_MAILBOX` ORDER BY idx DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1; //첫 번째 게시물인 경우
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;//데이터베이스 오류   
    }

    public void write(String userID, String receiver, String cc, String subject, String body) {
        try {
                        String dbURL = "jdbc:mysql://34.64.170.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
                        String dbID = "yoonjsp";
                        String dbPassword = "jspteamproject!!!";
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            Class.forName("com.mysql.cj.jdbc.Driver");
            String SQL = "INSERT INTO `jspmail`.`SENT_MAILBOX` (`idx`, `username`, `receiver`, `cc`, `subject`, `body`) VALUES (?,?,?,?,?,?);";
            PreparedStatement pstmt = conn.prepareStatement(SQL);

            pstmt.setInt(1, getNext());
            pstmt.setString(2, userID);
            pstmt.setString(3, receiver);
            pstmt.setString(4, cc);
            pstmt.setString(5, subject);
            pstmt.setString(6, body);

            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        //return -1;//데이터베이스 오류  
    }

    public void write(String userID, String[] receivers, String cc, String subject, String body) {
        try {
                        String dbURL = "jdbc:mysql://34.64.170.168:3306/jspmail?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
                        String dbID = "yoonjsp";
                        String dbPassword = "jspteamproject!!!";
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            Class.forName("com.mysql.cj.jdbc.Driver");
            String SQL = "INSERT INTO `jspmail`.`SENT_MAILBOX` (`idx`, `username`, `receiver`, `cc` ,`subject`, `body`) VALUES (?,?,?,?,?,?);";
            PreparedStatement pstmt = conn.prepareStatement(SQL);

            for (int i = 0; i < receivers.length; i++) {
                pstmt.setInt(1, getNext());
                pstmt.setString(2, userID);
                pstmt.setString(3, receivers[i]);
                pstmt.setString(4, cc);
                pstmt.setString(5, subject);
                pstmt.setString(6, body);
                
                pstmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //return -1;//데이터베이스 오류  
    }

  
    
    private boolean sendMessage(HttpServletRequest request) {
        boolean status = false;

        // 1. toAddress, ccAddress, subject, body, file1 정보를 파싱하여 추출
        parser = new FormParser(request);
        parser.parse();

        // 2.  request 객체에서 HttpSession 객체 얻기
        HttpSession session = (HttpSession) request.getSession();

        // 3. HttpSession 객체에서 메일 서버, 메일 사용자 ID 정보 얻기
        String host = (String) session.getAttribute("host");
        String userid = (String) session.getAttribute("userid");

        // 4. SmtpAgent 객체에 메일 관련 정보 설정
        SmtpAgent agent = new SmtpAgent(host, userid);

        agent.setTo(parser.getToAddress());
        agent.setCc(parser.getCcAddress());
        agent.setSubj(parser.getSubject());
        agent.setBody(parser.getBody());
        String fileName = parser.getFileName();
        System.out.println("WriteMailHandler.sendMessage() : fileName = " + fileName);
        if (fileName != null) {
            agent.setFile1(fileName);
        }

        // 5. 메일 전송 권한 위임
        if (agent.sendMessage()) {
            status = true;
        }

        return status;
    }

    private String getMailTransportPopUp(boolean success) {
        String alertMessage = null;
        if (success) {
            alertMessage = "메일 전송이 성공했습니다.";
        } else {
            alertMessage = "메일 전송이 실패했습니다.";
        }

        StringBuilder successPopUp = new StringBuilder();
        successPopUp.append("<html>");
        successPopUp.append("<head>");

        successPopUp.append("<title>메일 전송 결과</title>");
        successPopUp.append("<link type=\"text/css\" rel=\"stylesheet\" href=\"css/main_style.css\" />");
        successPopUp.append("</head>");
        successPopUp.append("<body onload=\"goMainMenu()\">");
        successPopUp.append("<script type=\"text/javascript\">");
        successPopUp.append("function goMainMenu() {");
        successPopUp.append("alert(\"");
        successPopUp.append(alertMessage);
        successPopUp.append("\"); ");
        successPopUp.append("window.location = \"main_menu.jsp\"; ");
        successPopUp.append("}  </script>");
        successPopUp.append("</body></html>");
        return successPopUp.toString();
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
     * @throws IOException if an I/O error occurs
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
