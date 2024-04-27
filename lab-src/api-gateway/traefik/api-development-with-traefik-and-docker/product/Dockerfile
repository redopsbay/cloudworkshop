FROM golang:1.20.9-alpine3.18

WORKDIR /opt/product

COPY . /opt/product

EXPOSE 8000

RUN go build main.go && \
    chmod +x main

CMD [ "./main" ]
