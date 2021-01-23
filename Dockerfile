# ==============================================================================
# Compile V8
# ==============================================================================

FROM ubuntu:16.04

ARG V8_VERSION=master

RUN apt-get update && apt-get upgrade -yqq

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get install bison \
	                cdbs \
	                curl \
	                flex \
	                g++ \
	                git \
	                python \
	                vim \
	                pkg-config -yqq \
	                lsb-core \
	                gcc-multilib

WORKDIR /
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

ENV PATH="/depot_tools:${PATH}"

WORKDIR /depot_tools
RUN fetch v8
WORKDIR /depot_tools/v8
ARG CACHEBUST=1

RUN  git checkout ${V8_VERSION}
RUN gclient sync -D

RUN ./tools/dev/v8gen.py x64.release -vv
RUN rm out.gn/x64.release/args.gn
COPY ./args_x86_64.gn out.gn/x64.release/args.gn
RUN ninja -C out.gn/x64.release
