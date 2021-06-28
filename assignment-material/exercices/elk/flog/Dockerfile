#####
FROM golang:1.11 as builder

RUN go get  -d -v github.com/mingrammer/flog
WORKDIR /go/src/github.com/mingrammer/flog/

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o flog .

#####
FROM scratch

LABEL maintainer furgerot.j@sfeir.com

WORKDIR /bin
COPY --from=builder /go/src/github.com/mingrammer/flog/flog .

ENV PATH=/bin

ENTRYPOINT [ "flog" ]
CMD [ "-n", "20", "-t", "stdout" ]
