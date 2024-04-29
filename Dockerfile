FROM ubuntu:latest
LABEL authors="ruiti"

RUN apt-get update
RUN apt-get install git wget build-essential cmake clang libssl-dev libudns-dev libfmt-dev libc++-dev -y
RUN wget https://github.com/boostorg/boost/releases/download/boost-1.82.0/boost-1.82.0.tar.gz  \
    && tar -xf boost-1.82.0.tar.gz \
    && cd boost-1.82.0/ \
    && ./bootstrap.sh --with-toolset=clang  \
    && ./b2 clean \
    && ./b2 toolset=clang cxxflags=-std=c++20 -stdlib=libc++ linkflags=-stdlib=libc++ link=static \
RUN mkdir app/
COPY . /app/
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make -j $(nproc)
ENTRYPOINT ["top", "-b"]