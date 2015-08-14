FROM debian

RUN apt-get update && \
    apt-get install -y curl sqlite && \
    curl http://mirror.racket-lang.org/installers/6.2/racket-6.2-x86_64-linux-debian-squeeze.sh > racket.sh && \
    echo "yes\n1\n" | /bin/bash racket.sh && \
    rm racket.sh

ADD info.rkt /src/info.rkt
RUN raco pkg install --deps search-auto /src
ADD . /src
WORKDIR /src
EXPOSE 8000
