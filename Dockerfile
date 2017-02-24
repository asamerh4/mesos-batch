FROM centos:centos7.2.1511

MAINTAINER Hubert Asamer

USER root
COPY build-img/rpm/pkg.rpm /

RUN yum install -y subversion cyrus-sasl-md5 libevent-devel wget && curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && python get-pip.py && pip install awscli && wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ./jq-linux64 && mv jq-linux64 /usr/bin/jq && rpm -Uvh pkg.rpm && rm pkg.rpm

COPY tools/sentinel-2/ /root/tools/sentinel-2/

WORKDIR /root