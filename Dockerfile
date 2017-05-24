FROM ubuntu

ARG shared=OFF

RUN apt-get update -y
RUN apt-get -y install build-essential curl git cmake unzip autoconf autogen libtool \
                       python python3-numpy python3-dev python3-pip python3-wheel

# install bazel for the shared library version
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN apt-get -y update && apt-get -y install bazel

# clone the repository
RUN git clone https://github.com/FloopCZ/tensorflow_cc.git

# install tensorflow
RUN mkdir /tensorflow_cc/tensorflow_cc/build
WORKDIR /tensorflow_cc/tensorflow_cc/build
RUN cmake -DTENSORFLOW_SHARED=${shared} ..
RUN make && make install

# build and run example
RUN mkdir /tensorflow_cc/example/build
WORKDIR /tensorflow_cc/example/build
RUN cmake .. && make && ./example
