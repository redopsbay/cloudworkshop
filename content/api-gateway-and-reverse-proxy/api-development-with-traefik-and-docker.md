---
title: "API development with traefik & docker"
chapter: false
weight: 2
---

![DevOps](https://doc.traefik.io/traefik/assets/img/traefik-architecture.png?width=20pc)

## The Problem 🤯

You have multiple docker or container services running on a single machine that uses same port during your development, and how will you run all this containers all at once without changing the port numbers?

Of course you can run it through docker using the parameters `-p 8080:8080` and `-p 9090:8080`.

But it's painful everytime you will run it since you will have to change each port on your `localhost`. This is what `traefik` proxy comes in.

### Scenario 😁

For example, you have multiple docker services in your `docker-compose` file running multiple web applications or **api endpoints** and it's both designed to run on port `8080`.

```yaml
# In my case, I will use my personal domain `redopsbay.dev`. If you don't have one.
# you can always modify your `/etc/hosts` or `C:\Windows\System32\drivers\etc\hosts` file to add entries like:

# /etc/hosts or C:\Windows\System32\drivers\etc\hosts
# 127.0.0.1 api.example.org

version: "3"
services:
  # Traefik proxy will be the frontend or edge router of your container services
  traefik-proxy:
    image: traefik:v3.0
    container_name: traefik-proxy
    command:
      - --api.insecure=true
      - --providers.docker
      - --entrypoints.http.address=:80
    # Expose port `80` on your machine
    ports:
      - "80:80"
    volumes: # give traefik-proxy access into docker.sock
      - /var/run/docker.sock:/var/run/docker.sock
  # `user-api` running port `8080`
  user-api:
    image: user-api:latest
    build:
      context: user
      dockerfile: Dockerfile
    container_name: user-api
    labels:
      - traefik.enable=true
      - traefik.http.services.user-api.loadbalancer.server.port=8000
      - traefik.http.routers.user-api.rule=Host(`api.redopsbay.dev`) && PathPrefix(`/user`)
      - traefik.http.routers.user-api.entrypoints=http
      - traefik.http.middlewares.user-api.stripprefix.prefixes=/user
      - traefik.http.routers.user-api.middlewares=user-api
      # using `http` entrypoint that utilizes port `80`
    ports:
      - 8000
  # `product-api` running port `80`
  product-api:
    image: product-api:latest
    build:
      context: product
      dockerfile: Dockerfile
    container_name: product-api
    labels:
      - traefik.enable=true
      - traefik.http.services.product-api.loadbalancer.server.port=8000
      - traefik.http.routers.product-api.rule=Host(`api.redopsbay.dev`) && PathPrefix(`/product`)
      - traefik.http.routers.product-api.entrypoints=http
      - traefik.http.middlewares.product-api.stripprefix.prefixes=/product
      - traefik.http.routers.product-api.middlewares=product-api
      # using `http` entrypoint also that utilizes port `80`
    ports:
      - 8000
```

If you run and thru `docker-compose up`:

```bash
docker-compose up
```

If you visit the url in my case it's `http://api.redopsbay.dev/user/1` & `http://api.redopsbay.dev/product/3`, the response will be:

```bash
# http://api.redopsbay.dev/user/
{"id":1,"username":"andres"}

# http://api.redopsbay.dev/product/
{"id":1,"name":"testproduct"}
```

**That's it!!! 👌**

***Note:*** Traefik does not tied up only to a api development. It has a lot of feature and use cases like `middleware` and `edge routing` experience and it's pretty fast!!
{{% children showhidden="false" %}}

### References

- [Traefik Offical Documentation](https://doc.traefik.io/traefik/)

## Source Code

- [https://github.com/redopsbay/devops/tree/master/content/lab-src/api-gateway-and-reverse-proxy](https://github.com/redopsbay/devops/tree/master/content/lab-src/api-gateway-and-reverse-proxy)
