package assign6client;

import java.util.*;
import java.io.*;
import java.net.*;
import javax.swing.*;
import java.awt.event.*;
import java.awt.*;
import javax.swing.text.*;

public class Assign6Client extends JFrame implements Runnable, ActionListener {

    public static final int PORT = 5001;

    private ObjectInputStream myInputStream;
    private ObjectOutputStream myOutputStream;
    private JTextArea outputArea;
    private JPanel buttongroup;
    private JButton additem, viewitem, buyitem, viewsold, exitbutton;
    private JTextField inputField;
    private String myName, serverName;
    private int ch, randomID;
    private Vector <String> listitem;  

    public Assign6Client() {
        try {
            myName = JOptionPane.showInputDialog(this, "Enter your user name: ");
            serverName = JOptionPane.showInputDialog(this, "Enter the server name(localhost): ");
            InetAddress addr = InetAddress.getByName(serverName);
            Socket socket = new Socket(addr, PORT);   
            
            this.setTitle("Welcome to MyShop.com:) "+myName);      
            outputArea = new JTextArea(25, 30);  
            DefaultCaret caret = (DefaultCaret)outputArea.getCaret();
            caret.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);
            outputArea.setEditable(false);
            JScrollPane scroller = new JScrollPane(outputArea);

            buttongroup = new JPanel();
            buttongroup.setLayout(new GridLayout (1, 4));
            additem = new JButton("AddItem");
            viewitem = new JButton("ViewMyItem");
            buyitem = new JButton("BuyItem");
            viewsold = new JButton("ViewSoldItem");
            exitbutton = new JButton("Exit");
            buttongroup.add(additem);
            buttongroup.add(viewitem);
            buttongroup.add(buyitem);
            buttongroup.add(viewsold);
            buttongroup.add(exitbutton);
            
            inputField = new JTextField("");  
            inputField.addActionListener(this);
      
            add(scroller, BorderLayout.NORTH);
            add(buttongroup, BorderLayout.CENTER);
            add(inputField, BorderLayout.SOUTH);

            myOutputStream = new ObjectOutputStream(socket.getOutputStream());
            myOutputStream.flush();
            myOutputStream.writeObject(myName);   
            myOutputStream.flush();
            myInputStream = new ObjectInputStream(socket.getInputStream());         
        
            outputArea.append("Welcome to the shopping center, " + myName + "\n");
            
            listitem = new Vector<String>();
            
            Thread outputThread = new Thread(this);  
            outputThread.start();                    
            
            inputField.setEditable(false);
            viewitem.setEnabled(false);
            buyitem.setEnabled(false);
            viewsold.setEnabled(false);
            
            ButtonHandler1 bhandler1 = new ButtonHandler1();
            additem.addActionListener(bhandler1);
            
            ButtonHandler2 bhandler2 = new ButtonHandler2();
            viewitem.addActionListener(bhandler2);
            
            ButtonHandler3 bhandler3 = new ButtonHandler3();
            buyitem.addActionListener(bhandler3);
            
            ButtonHandler4 bhandler4 = new ButtonHandler4();
            viewsold.addActionListener(bhandler4);
            
            ButtonHandler5 bhandler5 = new ButtonHandler5();
            exitbutton.addActionListener(bhandler5);
            
            setSize(500, 500);
            setVisible(true);
        }
        catch(Exception e) {
            JOptionPane.showMessageDialog(null, "Error starting client...log out!");
        }
    }

    public void run() {
        while (true) {
            try {
               String currMsg = (String) myInputStream.readObject();
               outputArea.append(currMsg+"\n"+"\n");
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

    private class ButtonHandler1 implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            inputField.setEditable(true);
            ch = 1;
            outputArea.append("Enter the item name and price to list item, seperate by space, thank you!"+"\n"+"Example: item $price" + "\n");
        }
    }
    
    private class ButtonHandler2 implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            inputField.setEditable(false);
            ch = 2; 
            String arraymsg = "No one sale anything, Sorry!";
            try {
        	myOutputStream.writeObject(ch+arraymsg); 
        	myOutputStream.flush();
            }
            catch (IOException ioException)  {
           	System.out.println("Problem sending message");
            }
        }
    }
    
    private class ButtonHandler3 implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            inputField.setEditable(true);
            ch = 3;
            outputArea.append("Enter the item ID to buy item, thank you!"+"\n"+"\n");
        }
    }
    
    private class ButtonHandler4 implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            inputField.setEditable(false);
            ch = 4;
            try {
        	myOutputStream.writeObject(String.valueOf(ch)); 
        	myOutputStream.flush();
            }
            catch (IOException ioException)  {
           	System.out.println("Problem sending message");
            }
        }
    }
    
    private class ButtonHandler5 implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            System.exit(0);
        }
    }
    
    public void actionPerformed(ActionEvent e)
    {
        if(ch == 1) {
            String currMsg = e.getActionCommand();      
            inputField.setText("");                      
            try {
                Random rand = new Random();
                randomID = rand.nextInt(1000 - 0 + 1) + 0;
                String myitem = new String();
                myitem = String.format("SellerID: %d; SellerName: %s; Item/price: %s", randomID, myName, currMsg);
        	myOutputStream.writeObject(ch+myitem); 
        	myOutputStream.flush();
                
                listitem.add(myitem);
            }
            catch (IOException ioException)  {
           	System.out.println("Problem sending message");
            }
            viewitem.setEnabled(true);
            inputField.setEditable(false);
            buyitem.setEnabled(true);
        }
        else if(ch == 3) {
            String currMsg = e.getActionCommand();      
            inputField.setText("");  
            try {
                myOutputStream.writeObject(ch+currMsg); 
        	myOutputStream.flush();
            }
            catch (IOException ioException)  {
           	System.out.println("Problem sending message");
            }
            viewsold.setEnabled(true);
        }
    }                                               

   
    public static void main(String [] args) {
        Assign6Client Client = new Assign6Client();
            Client.addWindowListener(
            new WindowAdapter() {
                public void windowClosing(WindowEvent e)
                    { System.exit(0); }
                }
            ); 
    }        
}

 