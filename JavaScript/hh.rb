<div class="message my-message">
<div>
    <div class="name">Me</div>
    <div class="text">Hello</div>
</div>
</div>
<div class="update">
Kernel is Joined The Chat
</div>
<div class="message other-message">
<div>
    <div class="name">kernel</div>
    <div class="text">Hello</div>
</div>
</div>


// 
app.querySelector(".chat-screen #send-message").addEventListener("click", function(){
            let message = app.querySelector(".chat-screen #message-input").value;
            if(message.lenght == 0){
                return ;            
            }
            renderMessage("my",{
                username: uname,
                text: message
            });
            socket.emit("chat message",{
                username: uname,
                text: message
            });
            app.querySelector(".chat-screen #message-input").value = "";
        });
        function renderMessage(type , message){
            let messageContainer = app.querySelector(".chat-screen .messages");
            if(type == "my"){
                let el = document.createElement("div"); 
                el.setAttribute("class", "message.my-message");
                el.innerHTML = `
                <div>
                    <div class="name">You</div>
                    <div class="text">${message.text}</div>
                </div>
                `;
                messageContainer.appendChild(el);
            }else if(type == "other"){
                let el = document.createElement("div"); 
                el.setAttribute("class", "message.other-message");
                el.innerHTML = `
                <div>
                    <div class="name">${message.username}</div>
                    <div class="text">${message.text}</div>
                </div>
                `;
                messageContainer.appendChild(el);
                
            }else if (type == "update"){
                let el = document.createElement("div"); 
                el.setAttribute("class", "update");
                el.innerText = message;
                messageContainer.appendChild(el);
                
            }
            // scroll chat to bottom
            messageContainer.scrollTop = messageContainer.scrollHeight - messageContainer.clientHeight;
        }