FROM centos:centos7

MAINTAINER "Razvan Chitu" <razvan.chitu@eaudeweb.ro>

ENV ZEO_HOME=/opt/zeoserver

RUN yum updateinfo -y && \
    yum install -y epel-release && \
    yum install -y make && \
    yum install -y gcc && \
    yum install -y gcc-c++ && \
    yum install -y python && \
    yum install -y python-devel && \
    yum install -y python-pip && \
    mkdir -p $ZEO_HOME

COPY base.cfg           $ZEO_HOME/base.cfg
COPY bootstrap.py       $ZEO_HOME/
COPY start.sh           /usr/bin/start
COPY configure.py       /configure.py

WORKDIR $ZEO_HOME

RUN python bootstrap.py -v 2.2.1 --setuptools-version=7.0 -c base.cfg && \
    ./bin/buildout -c base.cfg && \
    useradd -u 1000 -m -s /bin/bash zope-www && \
    chown -R 1000:1000 $ZEO_HOME

VOLUME $ZEO_HOME/var/

USER zope-www

CMD ["start"]
