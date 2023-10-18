# DevOps Workshop


[https://devops.redopsbay.dev](https://devops.redopsbay.dev)

Curated list of demo for cloud-native solutions. 👌

Aiming developers or who wants to start their career as a devops engineer or just enthusiast automating things. 😎

***Knowledge is free!!! You just have to work for it!***

# Hugo Development 🚧 ##


### Creating the site 
```bash
docker run --rm -it \
    -v "$(pwd)":/src \
    klakegg/hugo:0.111.3-ext-ubuntu-onbuild new site hugo
```
### Downloading the theme
```bash
pushd hugo
git submodule add https://github.com/matcornic/hugo-theme-learn themes/hugo-theme-learn
echo "theme = 'hugo-theme-learn'" >> config.toml
popd
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

[![contributors](https://contrib.rocks/image?repo=redopsbay/devops)](https://github.com/redopsbay/devops/graphs/contributors)