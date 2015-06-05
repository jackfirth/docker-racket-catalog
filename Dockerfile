FROM slogsdon/racket
RUN raco pkg install git://github.com/dmac/spin
ADD main.rkt /src/main.rkt
WORKDIR /src
EXPOSE 8000
