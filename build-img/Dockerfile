FROM centos:7

MAINTAINER Hubert Asamer

#build env for mesos including rpm packaging capabalities

RUN yum install -y which && \
  yum groupinstall -y 'Development Tools' && \
  yum install -y epel-release clang git maven cmake java-1.8.0-openjdk-devel \
    python-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 \
    apr-devel subversion-devel apr-utils-devel libevent-devel libev-devel ruby ruby-devel rubygems && gem install fpm

COPY mesos-rpm-packaging /mesos-rpm-packaging
COPY mesos /mesos