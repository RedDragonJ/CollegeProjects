package assign6server;

import java.util.*;
import java.io.*;
import java.net.*;

public class Assign6Server {

    public static final int PORT = 5001;

    private int MaxUsers;    
    private Socket [] users;         
    private UserThread [] threads;
    private int numUsers;   
    private char ch;
    private Vector <String> itemarray;
    private Vector <String> itemsold;
    private ObjectOutputStream currentstream;
    
    public Assign6Server(int m) {
        MaxUsers = m;
        users = new Socket[MaxUsers];
        threads = new UserThread[MaxUsers];   
        numUsers = 0;                         
        itemarray = new Vector<String>();
        itemsold = new Vector<String>();
        
        try {
            runServer();
        }
        catch(Exception e) {
           System.out.println("Error starting server...shutting down!");
        }
    }

    public synchronized void SendSaleMsg(String msg) {
        ch = msg.charAt(0);
        String newitem = new String();
        newitem = msg.substring(1);
        if(ch == '1') {
            String addmsg = "A new item has been added!";
            
            itemarray.add(newitem);
            
            for(int i = 0; i < numUsers; i++) {
                ObjectOutputStream out = threads[i].getOutputStream();
                try {
                    out.writeObject(addmsg);
                    out.flush();
                }
                catch (IOException e) {
                    System.out.println("Sending message error!");
                }
            }
        }
        else if(ch == '2') {
            ObjectOutputStream out = currentstream;
            if(itemarray.isEmpty()) {
                try {
                    out.writeObject(newitem);
                    out.flush();
                }
                catch (IOException e) {
                    System.out.println("Sending message error!");
                }
            }
            else {
                for(int i=0; i<itemarray.size(); i++) {
                    try {
                        out.writeObject(itemarray.elementAt(i));
                        out.flush();
                    }
                    catch (IOException e) {
                        System.out.println("Sending message error!");
                    }
                }
            }
        }
        else if(ch == '3') {
            ObjectOutputStream out = currentstream;
            String buymsg = "You have brought the item successfully!";
            String buymsg2 = "No item for sale right now, sorry!";
            if(itemarray.isEmpty()) {
                try {
                    out.writeObject(buymsg2);
                    out.flush();
                }
                catch (IOException e) {
                    System.out.println("Sending message error!");
                }
            }
            else {
                for(int i=0; i<itemarray.size(); i++) {
                    if(itemarray.elementAt(i).contains(newitem)) {
                        itemsold.add(itemarray.elementAt(i));
                        try {
                            out.writeObject(buymsg);
                            out.flush();
                        }
                        catch (IOException e) {
                            System.out.println("Sending message error!");
                        }
                        itemarray.removeElementAt(i);
                    }
                }
            }
        }
        else if(ch == '4') {
            ObjectOutputStream out = currentstream;
            for(int i=0; i<itemsold.size(); i++) {
                try {
                    out.writeObject("Item Sold online"+" --- "+itemsold.elementAt(i));
                    out.flush();
                }
                catch (IOException e) {
                    System.out.println("Sending message error!");
                }
            }
        }
        else {
            for (int i = 0; i < numUsers; i++)
            {
                ObjectOutputStream out = threads[i].getOutputStream();
                try {
                    out.writeObject(msg);
                    out.flush();
                }
                catch (IOException e)  {
                    System.out.println("Problem sending message");
                }
            }
        }
    }

    public synchronized void removeClient(int id, String name) {
        try {                             
            users[id].close();       
        }                            
        catch (IOException e) {
            System.out.println("Client already closed!");
        }
        users[id] = null;
        threads[id] = null;

        for(int i = id; i < numUsers-1; i++) {                             
            users[i] = users[i+1];
            threads[i] = threads[i+1];
            threads[i].setId(i);
        }
        numUsers--;
        ch = 5;
        SendSaleMsg(name + " has logged off!");    
    }

    private void runServer() throws IOException {
        ServerSocket s = new ServerSocket(PORT);
          
	try {
            while(true) {
                if(numUsers < MaxUsers) {
                    try {
                        Socket newSocket = s.accept();    
                        synchronized(this) {
                            users[numUsers] = newSocket;
                            ObjectInputStream in = new ObjectInputStream(newSocket.getInputStream());         
                            String newName = (String)in.readObject();
                            ch = 5;
                            SendSaleMsg(newName + " has just joined the shopping center");

                            threads[numUsers] = new UserThread(newSocket, numUsers, newName, in);
                            threads[numUsers].start();
                            System.out.println("Connection " + numUsers + users[numUsers]);
                            numUsers++;
                        }
                    }
                    catch(Exception e) {
                        System.out.println("Problem with connection...terminating");
                    }
                }  // end if
            }  // end while
        }   // end try   
        finally {
            System.out.println("Server shutting down");       
        }
    }

    private class UserThread extends Thread {
        private Socket mySocket;
        private ObjectInputStream myInputStream;
        private ObjectOutputStream myOutputStream;
        private int myId;
        private String myName;
         
        private UserThread(Socket newSocket, int id, String newName, ObjectInputStream in) throws IOException {
            mySocket = newSocket;
            myId = id;
            myName = newName;
            myInputStream = in;
            myOutputStream = new ObjectOutputStream(newSocket.getOutputStream());
        }

        public ObjectInputStream getInputStream() {
            return myInputStream;
        }
 
        public ObjectOutputStream getOutputStream() {
            return myOutputStream;
        }

        public synchronized void setId(int newId) {
            myId = newId;   
        }

        public void run() {
            boolean alive = true;
            while (alive) {
                String newMsg = null;
                try {
                    newMsg = (String) myInputStream.readObject();                      
                    synchronized(this) {
                        currentstream = this.getOutputStream();
                        Assign6Server.this.SendSaleMsg(newMsg);
                    }
                }
                catch (ClassNotFoundException e) {
                    System.out.println("Error receiving message....shutting down");
                    alive =false;
                }
                catch(IOException e) {
                    System.out.println("Client closing!!");
                    alive = false;
                }
            }
            removeClient(myId, myName);
        }
    }
  
    public static void main(String [] args) 
    {
         Assign6Server Server = new Assign6Server(10);
    }        
}

 