# 「ふつうのコンパイラをつくろう」のcbcをUbuntu18.04（64bit）でビルドする
# https://memo88.hatenablog.com/entry/2020/09/11/061801

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    gcc \
    git \
    javacc \
    libc6-dev-i386 \
    make \
    openjdk-8-jdk-headless \
    ruby \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ant \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# --------------------------------

ARG USER
ARG GROUP

RUN groupadd ${USER} \
  && useradd ${USER} -g ${GROUP} -m

USER ${USER}

# --------------------------------

WORKDIR /home/${USER}

RUN git clone https://github.com/sonota88/cbc.git

WORKDIR /home/${USER}/cbc

RUN git checkout ubuntu1804_64bit \
  && make \
  && ./install.sh /home/${USER}

ENV PATH="/home/${USER}/bin:${PATH}"

WORKDIR /home/${USER}/work
