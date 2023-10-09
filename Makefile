dockerize-server:
	@echo "Dockerizing gRPC server..." && \
	docker build -f ./server/Dockerfile -t sample-grpc-server . && \
	docker build -f ./proxy/Dockerfile -t sample-grpc-proxy .

run-server-on-docker:
	@echo "Running gRPC server on Docker..." && \
	docker-compose up

generate-proto-for-server:
	@echo "Generating proto for server..." && \
	mkdir -p server/gen && \
	protoc -I ./protos ./protos/*.proto --go_out=./server/gen --go-grpc_out=./server/gen --go_opt=paths=source_relative --go-grpc_opt=paths=source_relative

generate-proto-for-ts-webapp:
	@echo "Generating proto for ts-webapp..." && \
	mkdir -p webapp/app/gen && \
	protoc -I ./protos ./protos/*.proto --js_out=import_style=commonjs:./webapp/app/gen --grpc-web_out=import_style=typescript,mode=grpcweb:./webapp/app/gen

.PHONY: dockerize-server run-server-on-docker generate-proto-for-server generate-proto-for-ts-webapp
