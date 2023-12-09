import socket
import threading

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("127.0.0.1", 7777))

username = input("Enter your username: ")  # Get the username from the user

# Send banner message to the server
banner_message = f"BANNER:{username}"
client.send(banner_message.encode("ascii"))

def receive():
    while True:
        try:
            message = client.recv(1024).decode("ascii")
            if message == "USERNAME":
                client.send(username.encode("ascii"))
            else:
                print(message)
        except:
            print("An error occurred!")
            client.close()
            break

def write():
    while True:
        message = f"{username}: {input('')}"
        client.send(message.encode("ascii"))

# Start the receive and write threads
receive_thread = threading.Thread(target=receive)
receive_thread.start()

write_thread = threading.Thread(target=write)
write_thread.start()
