package jgroupchatserver;

import java.util.*;
import java.io.*;
import java.net.*;
/**
 * @author James
 */
public class JGroupChatServer {

     public static final int PORT = 5001;

    // Each client will get a thread in the server so we need
    // an array of sockets and threads
    private int MaxUsers;    // Max number of clients at a time
    private Socket [] users;         
    private UserThread [] threads;
    private int numUsers;    // Number of clients currently logged on
    private ObjectOutputStream tempStream;

    public JGroupChatServer (int m)
    {
        MaxUsers = m;
        users = new Socket[MaxUsers];
        threads = new UserThread[MaxUsers];   // Set things up and start
        numUsers = 0;                         // Server running

        try
        {
            runServer();
        }
        catch (Exception e)
        {
           System.out.println("Problem with server");
        }
    }

    // Method to send a message to all clients.  This is synchronized
    // to ensure that a message is not interrupted by another message
    public synchronized void SendMsg(String msg)  
    {
        for (int i = 0; i < numUsers; i++)
        {
            ObjectOutputStream out = threads[i].getOutputStream();
            try {
                if (out != tempStream){
                    out.writeObject(msg);
                    out.flush();
                }
            }
            catch (IOException e)  {
            	System.out.println("Problem sending message");
            }
        }
    }

    // Client logs off and is removed from server.  Again, this is
    // synchronized so that the arrays do not become inconsistent
    public synchronized void removeClient(int id, String name)
    {
        try                          
        {                             
            users[id].close();       
        }                            
        catch (IOException e)
        {
            System.out.println("Already closed");
        }
        users[id] = null;
        threads[id] = null;
        // fill up "gap" in arrays
        for (int i = id; i < numUsers-1; i++)           
        {                             
            users[i] = users[i+1];
            threads[i] = threads[i+1];
            threads[i].setId(i);
        }
        numUsers--;
        SendMsg(name + " has logged off");    
    }

    private void runServer() throws IOException
    {
       ServerSocket s = new ServerSocket(PORT);
	   System.out.println("Started: " + s);
          
	   try {
          while(true) {
         
            if (numUsers < MaxUsers)
            {
              try {
                // wait for client
                Socket newSocket = s.accept();
                // set up streams and thread for client    
                synchronized (this)
                {
     	           users[numUsers] = newSocket;
                   ObjectInputStream in = new ObjectInputStream(newSocket.getInputStream());         
	               String newName = (String)in.readObject();
                   SendMsg(newName + " has just joined the chat group");

                   threads[numUsers] = new UserThread(newSocket, numUsers, newName, in);
                   threads[numUsers].start();
                   System.out.println("Connection " + numUsers + users[numUsers]);
                   numUsers++;
                }
             }
             catch (Exception e)
             {
                System.out.println("Problem with connection...terminating");
             }
            }  // end if

          }  // end while
      }   // end try   
      finally 
      {
         System.out.println("Server shutting down");       
      }
    }

    // Server allocates one thread for client and delas with it as follows
    private class UserThread extends Thread
    {
         private Socket mySocket;
         private ObjectInputStream myInputStream;
         private ObjectOutputStream myOutputStream;
         private int myId;
         private String myName;
         
         private UserThread(Socket newSocket, int id, String newName,
                                ObjectInputStream in) throws IOException
         {
              mySocket = newSocket;
              myId = id;
              myName = newName;
              myInputStream = in;
              myOutputStream = new ObjectOutputStream(newSocket.getOutputStream());
         }

         public ObjectInputStream getInputStream()
         {
              return myInputStream;
         }
 
         public ObjectOutputStream getOutputStream()
         {
              return myOutputStream;
         }

         public synchronized void setId(int newId)
         {
              myId = newId;   
         }

         // Each UserThread will gets the next message from its corresponding 
         // client.  Each message is then sent to the other clients by the Server.
         // When there are no more messages myReader.readLine() throws
         // an IOException.  Then the thread will die.

         public void run()
         {
              boolean alive = true;
              while (alive)
              {
                    String newMsg = null;
                    try {
                         newMsg = (String) myInputStream.readObject();
                         synchronized(this)
                         {
                            tempStream = myOutputStream;
                            JGroupChatServer.this.SendMsg(newMsg);
                         }
                    }
        			catch (ClassNotFoundException e)  {
            			System.out.println("Error receiving message....shutting down");
            			alive =false;
				    }
                    catch (IOException e)
                    {
                        System.out.println("Client closing!!");
                        alive = false;
                    }
              }
              removeClient(myId, myName);
         }
    }
  
    public static void main(String [] args) 
    {
        JGroupChatServer Server = new JGroupChatServer(5);
    }        
    
}
