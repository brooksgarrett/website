FROM ubuntu AS build
ADD https://github.com/gohugoio/hugo/releases/download/v0.75.1/hugo_extended_0.75.1_Linux-64bit.tar.gz /tmp/hugo.tgz
WORKDIR /usr/local/bin
RUN tar xvzf /tmp/hugo.tgz

FROM ubuntu
COPY --from=build /usr/local/bin/hugo /usr/local/bin/hugo
RUN mkdir /site
WORKDIR /site
ENTRYPOINT ["hugo"]