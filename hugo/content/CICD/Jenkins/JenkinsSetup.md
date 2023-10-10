---
title: "Jenkins Setup"
chapter: false
weight: 2
---

![DevOps](https://www.jenkins.io/images/logos/actor/256.png)


## Jenkins Up & Running on Docker 🚀

For local development, we can use jenkins thru `docker-compose` to simplify things.

```yaml
version: '3.8'
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
   nginx:
     image: nginx:alpine
      ports:
volumes:
  jenkins:
```