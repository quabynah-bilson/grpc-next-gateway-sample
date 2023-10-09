package main

import (
	"context"
	"fmt"
	pb "github.com/dennis-bilson/grpc-server/gen"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"
	"log"
	"net"
	"time"
)

func main() {
	// Start the server
	startServer()
}

// startServer starts the grpc server
func startServer() {
	srv := grpc.NewServer()

	// register the service
	pb.RegisterGreeterServiceServer(srv, &GreeterServiceImpl{})

	// setup reflection
	reflection.Register(srv)

	// create a listener on TCP port 8888
	lis, err := net.Listen("tcp", ":8888")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	// Start the server
	log.Printf("Starting gRPC listener on port %v", lis.Addr())
	if err = srv.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

type GreeterServiceImpl struct {
	pb.UnimplementedGreeterServiceServer
}

func (*GreeterServiceImpl) SayHello(_ context.Context, req *pb.HelloRequest) (*pb.HelloResponse, error) {
	// get the name from the request and create a response
	response := &pb.HelloResponse{
		Greeting: fmt.Sprintf("Hello %s", req.Name),
	}

	// return the formatted response
	return response, nil
}

func (*GreeterServiceImpl) SayHelloAgain(req *pb.HelloRequest, srv pb.GreeterService_SayHelloAgainServer) error {

	// create a counter to exit the loop after 10 tries
	counter := 1
	for {
		if counter > 10 {
			// complete the stream gracefully
			return nil
		}

		// create response
		response := &pb.HelloResponse{
			Greeting: fmt.Sprintf("Hello %s", req.Name),
		}

		// wait for every second
		time.Sleep(1 * time.Second)

		// send a response back
		if err := srv.Send(response); err != nil {
			return status.Errorf(codes.Internal, fmt.Sprintf("Error while sending message: %v", err))
		}
		counter++
	}
}
