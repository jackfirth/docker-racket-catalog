FROM slogsdon/racket
ADD info.rkt /src/info.rkt
RUN raco pkg install --deps search-auto /src
ADD . /src
WORKDIR /src
RUN raco test .
RUN raco exe main.rkt
EXPOSE 8000
