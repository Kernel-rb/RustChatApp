import threading 
import socket

host = "127.0.0.1"
port = 7777

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((host, port))
server.listen()

clients = []  # List of clients
usernames = []  # List of usernames

def broadcast(message):
    for client in clients:
        client.send(message)

def handle(client):
    while True:
        try:
            message = client.recv(1024)
            broadcast(message)
        except:
            index = clients.index(client)
            clients.remove(client)
            username = usernames[index]
            broadcast(f"{username} left the chat".encode("ascii"))
            usernames.remove(username)
            break

def receive():
    while True:
        client, address = server.accept()
        print(f"Connected with {str(address)}")

        # Receive and handle banner message
        banner_message = client.recv(1024).decode("ascii")
        if banner_message.startswith("BANNER:"):
            received_username = banner_message[len("BANNER:"):]
            usernames.append(received_username)
            clients.append(client)

            # Display the banner message
            print(f"Welcome, {received_username}!")
            broadcast(f"{received_username} joined the chat".encode("ascii"))
            client.send("Connected to the server".encode("ascii"))

            # Start handling thread for the client
            thread = threading.Thread(target=handle, args=(client,))
            thread.start()

# Start the server
receive()
