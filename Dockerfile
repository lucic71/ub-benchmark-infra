FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LLVM_SRC_DIR=/llvm-project
ENV BUILD_DIR=/llvm-build
ENV INSTALL_DIR=/usr/local/llvm-16
ENV PATH="$INSTALL_DIR/bin:$PATH"

RUN apt update && apt install -y \
    build-essential \
    cmake \
    ninja-build \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    unzip \
    libtinfo-dev \
    zlib1g-dev \
    libncurses5-dev \
    libxml2-dev \
    binutils \
    binutils-dev \
    vim \
    emacs \
    git \
    php \
    sudo \
    pkg-config \
    libnl-genl-3-dev \
    php-xml \
    php-dom \
    libtool \
    && rm -rf /var/lib/apt/lists/*

# Use modified Clang that contains the UB flags
RUN git clone --depth 1 --branch release/16.x-ub https://github.com/lucic71/llvm-project.git $LLVM_SRC_DIR
RUN cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_ENABLE_PROJECTS="llvm;clang;lld" \
    -DLLVM_BINUTILS_INCDIR=/usr/include \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    -S $LLVM_SRC_DIR/llvm \
    -B $BUILD_DIR \
  && cmake --build $BUILD_DIR --target install \
  && rm -rf $BUILD_DIR $LLVM_SRC_DIR

# Modify ar and ranlib to use the LLVMgold plugin by default. Useful for LTO.
RUN mv /usr/bin/ar /usr/bin/_ar && \
  echo '#!/bin/bash' > /usr/bin/ar && \
  echo '/usr/bin/_ar --plugin=/usr/local/llvm-16/lib/LLVMgold.so "$@"' >> /usr/bin/ar && \
  chmod +x /usr/bin/ar

RUN mv /usr/bin/ranlib /usr/bin/_ranlib && \
  echo '#!/bin/bash' > /usr/bin/ranlib && \
  echo '/usr/bin/_ranlib --plugin=/usr/local/llvm-16/lib/LLVMgold.so "$@"' >> /usr/bin/ranlib && \
  chmod +x /usr/bin/ranlib

WORKDIR /benchmarks

# Fetch Phoronix test suite and the benchmarks used for our tests.
RUN git clone --branch artefact https://github.com/lucic71/ub-benchmark-infra.git /benchmarks \
    && rm -rf /benchmarks/.git
RUN git clone https://github.com/lucic71/phoronix-test-suite $HOME/git/phoronix-test-suite \
    && rm -rf $HOME/git/phoronix-test-suite/.git
RUN echo 'alias pts="$HOME/git/phoronix-test-suite/phoronix-test-suite"' >> ~/.bashrc

CMD ["/bin/bash"]
