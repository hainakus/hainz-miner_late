FROM ubuntu:22.04
LABEL authors="hainzmayonese"

RUN apt-get update
RUN apt-get install git wget build-essential cmake clang libssl-dev libboost-system-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libudns-dev libfmt-dev lld  libc++-dev -y
RUN wget https://github.com/boostorg/boost/releases/download/boost-1.82.0/boost-1.82.0.tar.gz  \
    && tar -xf boost-1.82.0.tar.gz \
    && cd boost-1.82.0/ \
    && ./bootstrap.sh --with-toolset=clang  \
    && ./b2 clean \
    && ./b2 toolset=clang cxxflags=-std=c++20 -stdlib=libc++ linkflags=-stdlib=libc++ link=static \
    && ./b2 install --prefix=/usr/local/
RUN mkdir app/
COPY . /app/
RUN mkdir -p /app/build

WORKDIR /app/build
RUN cmake ..
RUN make -j $(nproc)
ENTRYPOINT bash