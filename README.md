# demo


[https://demo.redopsbay.dev](https://demo.redopsbay.dev)

Curated list of demo for cloud-native solutions. 👌

# Hugo Development 🚧 ##


### Creating the site 
```bash
docker run --rm -it \
    -v "$(pwd)":/src \
    klakegg/hugo:0.107.0-ext-ubuntu new site hugo
```
### Downloading the theme
```bash
pushd hugo
git submodule add https://github.com/matcornic/hugo-theme-learn themes/hugo-theme-learn
echo "theme = 'hugo-theme-learn'" >> config.toml
popd
```


### Starting hugo server
```bash
pushd hugo
docker run --rm -it \
    -v "$(pwd)":/src \
    -p 1313:1313 \
    klakegg/hugo:0.107.0-ext-ubuntu \
  server --disableFastRender --navigateToChanged

popd
```


### Compiling the hugo site
```bash
docker run --rm -it \
    -v $(pwd):/src \
    klakegg/hugo:0.107.0-ext-ubuntu \
    --gc \
    --minify \
    --baseURL "https://demo.redopsbay.dev"
```

### Running the static site
```bash
pushd public/
docker run --rm \
    -it \
    -p 8080:80 \
    --name nginx-server \
    -v $(pwd):/usr/share/nginx/html nginx:1.23.4
popd
```
