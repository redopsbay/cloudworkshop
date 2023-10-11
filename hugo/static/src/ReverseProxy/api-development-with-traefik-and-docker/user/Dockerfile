FROM golang:1.20.9-alpine3.18

WORKDIR /opt/user

COPY . /opt/user

EXPOSE 8000

RUN go build main.go && \
    chmod +x main

CMD [ "./main" ]