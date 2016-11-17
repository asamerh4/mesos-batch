FROM centos:7

RUN yum install -y which && \
  yum groupinstall -y 'Development Tools' && \
  yum install -y epel-release clang git maven cmake java-1.8.0-openjdk-devel \
    python-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 \
    apr-devel subversion-devel apr-utils-devel libevent-devel libev-devel

ENV CC gcc
ENV CXX g++
ENV ENVIRONMENT 'GLOG_v=1 MESOS_VERBOSE=1'

COPY mesos /mesos/

RUN cd /mesos && ./bootstrap && mkdir build && cd build && ../configure && make -j 72 && make install && cd / && rm -rf /mesos