package main 
import "golang.org/x/net/websocket"

type Server struct {   // Server struct that mean a server instance
	conns map[*websocket.Conn]bool
}

func NewServer() *Server {  // NewServer function that return a new server instance
	return &Server{
		conns: make(map[*websocket.Conn]bool),
	}
}

func (s *Server) handleWS(ws *websocket.Conn) {  // handleWS function that handle the websocket connection
	fmt.Println("New connection from Client : " , ws.RemoteAddr().String())

	s.conns[ws] = true // add the connection to the map , each connection has a boolean value that indicate if the connection is active or not
    s.readLoop(ws) // call the readLoop function
}

func (s*Server) readLoo

func main(){

}