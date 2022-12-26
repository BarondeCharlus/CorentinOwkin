FROM golang:1.19

WORKDIR /usr/src/app

ENV UUID="230984"
ENV NAME="name"
ENV DESCRIPTION="description"
ENV PERFORMANCE=0
ENV DOCKERFILE="dockerfile"

COPY . .
RUN go build -v main.go
RUN mkdir /data

CMD ["/usr/src/app/main"]
