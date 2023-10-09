# get the base image
FROM golang:1.21-alpine3.18 AS builder

# set the working directory
WORKDIR /app

# copy the dependencies file
COPY . .

# build the binary
RUN go build -o server .


# get the base image for deployment
FROM alpine:3.14

# set the working directory
WORKDIR /app

# copy the binary from builder
COPY --from=builder /app/server .

# expose port 8080
EXPOSE 8888

# command to run the binary
CMD ["./server"]
