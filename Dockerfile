FROM centos:7

RUN yum install -y which && \
  yum groupinstall -y 'Development Tools' && \
  yum install -y epel-release clang git maven cmake java-1.8.0-openjdk-devel \
    python-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 \ 
	apr-devel subversion-devel apr-utils-devel libevent-devel libev-devel && \
  adduser mesos

ENV CC gcc
ENV CXX g++
ENV ENVIRONMENT 'GLOG_v=1 MESOS_VERBOSE=1'

COPY mesos /mesos/
WORKDIR /mesos

RUN chown -R mesos /mesos
USER mesos

RUN ./bootstrap && mkdir build && cd build && ../configure && make

USER root
RUN cd /mesos/build && make install