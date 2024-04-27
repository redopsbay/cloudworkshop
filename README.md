# Cloud Workshop

[https://cloudworkshop.redopsbay.dev](https://cloudworkshop.redopsbay.dev)

Curated list of demo for cloud-native solutions. 👌

Aiming developers or who wants to start their journey into cloud. 😎

**_Knowledge is free!!! You just have to work for it!_**

# Hugo Development 🚧

### Creating the site

```bash
docker run --rm -it \
    -v "$(pwd)":/src \
    klakegg/hugo:0.111.3-ext-ubuntu new site hugo
```

### Downloading the theme

```bash
git submodule add https://github.com/matcornic/hugo-theme-learn themes/hugo-theme-learn
echo "theme = 'hugo-theme-learn'" >> config.toml
```

### Starting hugo server for development

```bash
make start-dev
```

### Compiling the hugo site

```bash
make build
```

### Running the static site w/ nginx

```bash
make start-nginx
```

## Contributors 🚧

[![contributors](https://contrib.rocks/image?repo=redopsbay/cloudworkshop)](https://github.com/redopsbay/cloudworkshop/graphs/contributors)
