package jgroupchat;

import java.awt.*;
import java.awt.event.*;
import java.net.*;
import java.io.*;
import java.util.*;
import javax.swing.*;
import javax.swing.text.*;
/**
 * @author James
 */
public class JGroupChat extends JFrame implements Runnable, ActionListener {
    static final int PORT = 5001;
 
    private ObjectInputStream in;        // for messages from client
    private ObjectOutputStream out;          // for messages to client
    private Socket socket;
    private String myName, serverName;
    private JTextArea displayMsg;
    private JPanel txtSection;
    private JButton quitchat;
    private JTextField inputField;

    public JGroupChat() {
        try 
        {
            JOptionPane.showMessageDialog(null, "Welcome to JGroupChat - Own by James Sun");
            myName = JOptionPane.showInputDialog(this, "Enter your name:");
            if (myName == null)
            {
                System.exit(0);
            }
            serverName = JOptionPane.showInputDialog(this, "Enter server IP(192.168.1.13):");
            if (serverName == null)
            {
                System.exit(0);
            }
    	    InetAddress addr = InetAddress.getByName(serverName);
     	    socket = new Socket(addr, PORT);
            
            System.out.println("success pass ip address");
            
            this.setTitle("JGroupChat");
            displayMsg = new JTextArea(24, 30);
            
            DefaultCaret caret = (DefaultCaret)displayMsg.getCaret();
            caret.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);
            displayMsg.setEditable(false);
            JScrollPane scroller = new JScrollPane(displayMsg);
            scroller.scrollRectToVisible(caret);
            displayMsg.setLineWrap(true);
            displayMsg.setWrapStyleWord(true);
 
            inputField = new JTextField("");  
            inputField.addActionListener(this);
            
            txtSection = new JPanel();
            txtSection.setLayout(new FlowLayout());
            quitchat = new JButton("Exit");
            txtSection.add(quitchat);
            
            add(scroller, BorderLayout.NORTH);
            add(inputField, BorderLayout.CENTER);
            add(txtSection, BorderLayout.SOUTH);
            
            out = new ObjectOutputStream(socket.getOutputStream());
            out.flush();
            out.writeObject(myName);   
            out.flush();
            in = new ObjectInputStream(socket.getInputStream());
            
            displayMsg.append("Welcome to family chat room, " + myName + "\n");
            
            Thread outputThread = new Thread(this);  
            outputThread.start();  
            
            ButtonExit bhandler5 = new ButtonExit();
            quitchat.addActionListener(bhandler5);
            
            setSize(500, 500);
            setVisible(true);
        }      
        catch( Exception e) {
            JOptionPane.showMessageDialog(null, "Error starting client...log out!");
            System.exit(0);
        }       
   }

   public void run() {
        while (true) {
            try {
               String currMsg = (String) in.readObject();
               displayMsg.append(currMsg+"\n");
            }
            catch (ClassNotFoundException e)  {
                JOptionPane.showMessageDialog(null, "Receiving message error....shutting down!");
            }
            catch (IOException e)
            {
               JOptionPane.showMessageDialog(null, "Reading error!");
            }
        }
    }
   
   public void actionPerformed(ActionEvent e) {
        String currMsg = e.getActionCommand();      
            inputField.setText("");  
            try {
                String myNewMsg = new String();
                myNewMsg = "                              You: "+currMsg+"\n";
                displayMsg.append(myNewMsg);
                out.writeObject(myName+": "+currMsg); 
        	out.flush();
            }
            catch (IOException ioException)  {
           	JOptionPane.showMessageDialog(null, "Problem sending message");
            }
    }
   
   private class ButtonExit implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }
   
   public static void main(String [] args) {
        JGroupChat Client = new JGroupChat();
            Client.addWindowListener(
            new WindowAdapter() {
                public void windowClosing(WindowEvent e)
                    { System.exit(0); }
                }
            ); 
    }        
}
