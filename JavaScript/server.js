const express = require('express');
const path = require('path'); 

const app = express();
const server = require('http').createServer(app);
const io = require('socket.io')(server);

// what is static ? static is a folder that we are serving , dirname = current directory & public  = folder name 
app.use(express.static(path.join(__dirname +'/public')));

io.on('connection',  function(socket) {
    socket.on("new User" , function(username) {
        socket.broadcast.emit("update", username + "has joined the chat.");
    });
    socket.on("Exit User" , function(username) {
        socket.broadcast.emit("update", username + "has left the chat.");
    });
    socket.on("chat message", function(message) {
        io.emit("chat message", message);
    });
});



server.listen(3000, () => {
    console.log('Server listening on port 3000');
});