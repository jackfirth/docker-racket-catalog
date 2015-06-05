FROM slogsdon/racket
RUN raco pkg install git://github.com/dmac/spin
RUN raco pkg install fancy-app
ADD main.rkt /src/main.rkt
WORKDIR /src
EXPOSE 8000
