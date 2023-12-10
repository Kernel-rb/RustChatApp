class Members
    include Enumerable
  
    def initialize
      @members = []
    end
  
    def each
      @members.each { |member| yield member }
    end
  
    def add(member)
      @members << member
    end
  
    def remove(member)
      @members.delete(member)
    end
  
    def broadcast(message, sender)
      receivers = @members - [sender]
  
      receivers.each do |receiver|
        begin
          if receiver.socket && !receiver.socket.closed?
            receiver.socket.puts("> #{sender.name}: #{message}")
          end
        rescue IOError => e
          puts "Error broadcasting message to #{receiver.name}: #{e.message}"
        end
      end
    end
  end
  