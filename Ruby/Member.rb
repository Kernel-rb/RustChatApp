require './Members.rb'

class Member
  attr_reader :name, :socket

  def initialize(name, socket)
    @name = name
    @socket = socket
  end

  def welcome_from(members)
    if members.count > 1
      socket.puts "Welcome #{name}, you and #{members.count - 1} other(s) are connected to the server."
    elsif members.count == 1
      socket.puts "Welcome #{name}, you are the first member of the server <3."
    else
      socket.puts "Welcome #{name}, you are the only member of the server. Invite others to join!"
    end
  end
end
