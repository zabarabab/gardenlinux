FROM debian:testing-slim

RUN mkdir --parent /tmp/apt/lists /tmp/apt/archive && \
    echo "Dir::State::lists    /tmp/apt/lists;" >> /etc/apt/apt.conf.d/temp.conf && \
    echo "Dir::Cache::archives  /tmp/apt/archive;" >> /etc/apt/apt.conf.d/temp.conf && \
    cat /etc/apt/apt.conf.d/temp.conf   

RUN apt-get update && \
    apt-get install less

