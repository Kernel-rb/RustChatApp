require 'socket'
require './Member.rb'
require './Members.rb'

puts <<-ASCII
  _   __                     _             _     
 | | / /                    | |           | |    
 | |/ /  ___ _ __ _ __   ___| |______ _ __| |__  
 |    \\ / _ \\ '__| '_ \\ / _ \\ |______| '__| '_ \\ 
 | |\\  \\  __/ |  | | | |  __/ |      | |  | |_) |
 \\_| \\_/\\___|_|  |_| |_|\\___|_|      |_|  |_.__/ 
                                                  
ASCII

server = TCPServer.new(2000)
puts "Server is running on port 2000"

members = Members.new

# Handle Ctrl+C to gracefully shutdown the server
trap('INT') do
  puts 'Server is shutting down...'
  server.close if server
  exit
end

while true
  tcp_socket = server.accept
  Thread.new(tcp_socket) do |socket|
    socket.print "Enter your Username: "
    name = socket.gets.chomp
    member = Member.new(name, socket)
    member.welcome_from(members)
    members.add(member)
    members.broadcast("#{name} has joined the chat", member)
    #socket.close
  end
end
