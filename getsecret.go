package main
import (
	"io"
	"net"
	"os"
)

func main() {
	if len(os.Args) != 3 {
		println("Expected: getsecret <server:port> <secretkey>")
		os.Exit(1)
	}
	addr := os.Args[1]
	key := os.Args[2]

	conn, err := net.Dial("tcp", addr)
	if err != nil {
		println("Dial failed:", err.Error())
		os.Exit(1)
	}
	defer conn.Close()

	_, err = conn.Write([]byte(key + "\n"))
	if err != nil {
		println("Write to server failed:", err.Error())
		os.Exit(1)
	}

	_, err = io.Copy(os.Stdout, conn)
	if err != nil {
		println("Read from server failed:", err.Error())
		os.Exit(1)
	}
}
