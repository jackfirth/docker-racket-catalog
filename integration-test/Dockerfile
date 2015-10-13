FROM jackfirth/racket:6.2
WORKDIR /src
ADD ./src/info.rkt ./info.rkt
RUN raco pkg install --link --deps search-auto
ADD ./src .
CMD ["raco", "test", "main.rkt"]
EXPOSE 8000
