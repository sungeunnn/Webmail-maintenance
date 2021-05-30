/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package cse.maven_webmail.control;

public class CommandType {

    public final static int READ_MENU = 1;
    public final static int WRITE_MENU = 2;

    public final static int ADD_USER_MENU = 3;
    public final static int DELETE_USER_MENU = 4;

    public final static int SEND_MAIL_COMMAND = 21;
    public final static int TEM_MAIL_COMMAND = 31;
    public final static int DELETE_MAIL_COMMAND = 41;
    public final static int DOWNLOAD_COMMAND = 51;
    
    public final static int ADD_USER_COMMAND = 61;
    public final static int DELETE_USER_COMMAND = 62;

    public final static int ADD_ADDR_MENU = 81;
    public final static int DEL_ADDR_MENU = 82;
    public final static int UPDATE_ADDR_MENU = 83;
    public final static int ADD_GRP_MENU = 84;
    public final static int DEL_GRP_MENU = 85;
    public final static int UPDATE_GRP_MENU = 86;
    public final static int SEND_GRP_MAIL_MENU = 87;
    
    public final static int LOGIN = 91;
    public final static int LOGOUT = 92;
    
    public static boolean grp_state = false;
    public static String rcv_emails = "";
}
