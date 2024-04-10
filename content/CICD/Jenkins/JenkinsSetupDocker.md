---
title: "Jenkins Setup Docker Compose"
chapter: false
weight: 3
---

![DevOps](https://www.jenkins.io/images/logos/actor/256.png)

## Firing up Jenkins thru Docker Compose 🚀

For local development, we can use jenkins thru `docker-compose` to quickly fire up our Jenkins Server.

Will use the latest `nginx:alpine` and `jenkins/jenkins:lts` lts image as it's latest version.

In real world, it is not recommended to run jenkins without a reverse proxy due to the limitations of it's web server configuration, but it doesn't mean that it would not work. But it will leave your jenkins server **VULNERABLE** and prone to error.

### Pre-requisites

- [x] Docker Installed
- [x] Docker Compose Binary


1. Let's create a `docker-compose.yaml` file:

```yaml
---
version: "3"
services:
  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    container_name: jenkins
    volumes:
      - jenkins:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins
  nginx:
    image: nginx:alpine
    container_name: nginx-proxy
    ports:
      - 80:80
    volumes:
      - ${PWD}/nginx.conf:/etc/nginx/conf.d/default.conf
    networks:
      - jenkins
volumes:
  jenkins:
  nginx:

networks:
  jenkins:
```

2. Then, we will create `nginx.conf` file to proxy our jenkins server.

**_Note on the `server jenkins:8080;` inside the `upstream jenkins-server` block. Since we specify our docker-compose network named as `jenkins`_**

```
upstream jenkins-server {
  keepalive 32; # keepalive connections
  server jenkins:8080; # jenkins ip and port
}

# Required for Jenkins websocket agents
map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
  listen          80;       # Listen on port 80 for IPv4 requests


  # this is the jenkins web root directory
  # (mentioned in the output of "systemctl cat jenkins")
  root            /var/run/jenkins/war/;

  access_log      /var/log/nginx/jenkins.access.log;
  error_log       /var/log/nginx/jenkins.error.log;

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location ~ "^/static/[0-9a-fA-F]{8}\/(.*)$" {
    # rewrite all static files into requests to the root
    # E.g /static/12345678/css/something.css will become /css/something.css
    rewrite "^/static/[0-9a-fA-F]{8}\/(.*)" /$1 last;
  }

  location /userContent {
    # have nginx handle all the static requests to userContent folder
    # note : This is the $JENKINS_HOME dir
    root /var/lib/jenkins/;
    if (!-f $request_filename){
      # this file does not exist, might be a directory or a /**view** url
      rewrite (.*) /$1 last;
      break;
    }
    sendfile on;
  }

  location / {
      sendfile off;
      proxy_pass         http://jenkins:8080;
      proxy_redirect     default;
      proxy_http_version 1.1;

      # Required for Jenkins websocket agents
      proxy_set_header   Connection        $connection_upgrade;
      proxy_set_header   Upgrade           $http_upgrade;

      proxy_set_header   Host              $host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_buffering            off;
      proxy_request_buffering    off; # Required for HTTP CLI commands
      proxy_set_header Connection ""; # Clear for keepalive
  }

}
```

3. Next, run the `docker-compose` command.

```bash
docker-compose up
```

![Jenkins password](/images/jenkins-generated-password.png?width=250pc)

4. Next, we can now visit our jenkins server on [http://localhost](http://localhost).

![Jenkins Server](/images/jenkins-server-up-and-running-on-docker-compose.png?width=150pc)

***Nicely done 😉 !***

### Source Code

- [https://github.com/redopsbay/devops/tree/master/content/labs-src/jenkins-setup-docker](https://github.com/redopsbay/devops/tree/master/content/labs-src/jenkins-setup-docker)
