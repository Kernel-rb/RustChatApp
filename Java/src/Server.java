import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class Server implements Runnable { 
    private ArrayList<ConnectionHandler> connections ;
    private ServerSocket server;
    private boolean done ;
    private ExecutorService pool;

    public Server() {
        connections = new ArrayList<>();
        done = false;
    }


    @Override
    public void run() {
        try {
            server = new ServerSocket(9999);
            pool = Executors.newCachedThreadPool();
            while (!done) 
            {
            Socket client = server.accept();
            ConnectionHandler handler = new ConnectionHandler(client);
            connections.add(handler);
            pool.execute(handler);
            }
        } catch (Exception e) { 
            shutdown();
            
        }
    }


    public  void broadcast(String message) {
        for (ConnectionHandler ch : connections) {
            if (ch != null) {
                ch.sendMessage(message);
            } 
            
        }
    }

    public void shutdown(){
        done = true;
        if (!server.isClosed()){
            try {
                server.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        for (ConnectionHandler ch : connections) {
            ch.shutdown();
            
        }

    }





    class ConnectionHandler implements Runnable {
        private Socket client;
        private BufferedReader in;
        private PrintWriter out;
        private String username;

        
        public ConnectionHandler(Socket client) {
            this.client = client;
        }

        @Override
        public void run() {
            try {
                out = new PrintWriter(client.getOutputStream(), true);
                in = new BufferedReader(new InputStreamReader(client.getInputStream()));
                out.println("Hello, enter your username: ");
                username = in.readLine();
                if (!username.matches("[a-zA-Z]+\\d{0,2}") || username.length() > 15){
                    out.println("Invalid username. Only letters, at most two numbers, and not too long are allowed."); 
                } else {
                    out.println("Welcome " + username + " to our chat room.");
                }
                broadcast(username + " has joined the chat room.");
                String message;
                while ((message = in.readLine()) != null) {
                    if (message.startsWith("/usr")){
                        String[] messageSplit = message.split(" ", 2);
                        if (messageSplit.length == 2){
                            broadcast(username + " has changed their username to " + messageSplit[1]);
                            System.out.println( username + " has changed their username to " + messageSplit[1]);
                            username = messageSplit[1];
                            out.println("Username Changed Successfully to " + username);
                            
                        }else {
                            out.println("Invalid command. Usage: /usr <new username>");
                        }
                    }
                    else if (message.startsWith("/quit")){
                        out.println("Are you sure you want to quit? (Y/N)");
                        String response = in.readLine().trim().toLowerCase();
                        if (response.equals("y"))
                        {
                            out.println("Goodbye!");
                            broadcast(username + " has left the chat room.");
                            shutdown();
                            break;
                        }
                        else if (response.equals("n"))
                        {
                            out.println("You have chosen not to quit.");
                        }
                        else 
                        {
                            out.println("Invalid response. Please try again.");
                        
                        }
                    }
                        
                        
                    else 
                    {
                        broadcast(">" +username + ": " + message);
                    }
                }

            }catch (IOException e) {
                shutdown();
            }

        }

        public void sendMessage(String message) {
            out.println(message);
        }

        public void shutdown(){
            try 
            {
            in.close();
            out.close();
            if (!client.isClosed())
            {
                client.close();
            }
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

    }
    public static void main(String[] args) {
        Server server = new Server();
        server.run();
    }
    
}

