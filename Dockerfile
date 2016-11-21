FROM centos:centos7.2.1511

MAINTAINER Hubert Asamer

COPY build-img/rpm/pkg.rpm /


RUN yum install -y subversion cyrus-sasl-md5 libevent-devel
RUN rpm -Uvh pkg.rpm
RUN rm pkg.rpm