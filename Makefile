start-grpc-server:
	@echo "Starting gRPC server..." && \
	cd server && \
	go run ./...

dockerize-server:
	@echo "Dockerizing gRPC server..." && \
	cd server && \
	docker build -t sample-grpc-server .

run-server-on-docker:
	@echo "Running gRPC server on Docker..." && \
	docker run -p 8888:8888 sample-grpc-server

generate-proto-for-server:
	@echo "Generating proto for server..." && \
	mkdir -p server/gen && \
	protoc -I ./protos ./protos/*.proto --go_out=./server/gen --go-grpc_out=./server/gen --go_opt=paths=source_relative --go-grpc_opt=paths=source_relative

generate-proto-for-ts-webapp:
	@echo "Generating proto for ts-webapp..." && \
	mkdir -p webapp/src/gen && \
	protoc -I ./protos ./protos/*.proto --js_out=import_style=commonjs:./webapp/src/gen --grpc-web_out=import_style=typescript,mode=grpcweb:./webapp/src/gen

.PHONY: start-grpc-client dockerize-client run-client-on-docker generate-proto-for-client
