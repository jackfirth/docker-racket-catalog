FROM slogsdon/racket
ADD info.rkt /src/info.rkt
RUN raco pkg install --deps search-auto /src
ADD main.rkt /src/main.rkt
WORKDIR /src
RUN raco test .
EXPOSE 8000
