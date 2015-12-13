FROM centos:centos7
MAINTAINER "Razvan Chitu" <razvan.chitu@eaudeweb.ro>
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

ENV ZEO_HOME=/opt/zeoserver

RUN yum updateinfo && \
    yum install -y \
        make \
        gcc \
        gcc-c++ \
        python \
        python-devel && \
    yum clean all && \
    mkdir -p $ZEO_HOME

COPY src/base.cfg           $ZEO_HOME/base.cfg
COPY src/bootstrap.py       $ZEO_HOME/
COPY src/start.sh           /usr/bin/start
COPY src/configure.py       /configure.py

WORKDIR $ZEO_HOME

RUN python bootstrap.py -v 2.2.1 --setuptools-version=7.0 -c base.cfg && \
    ./bin/buildout -c base.cfg && \
    groupadd -g 500 zope-www && \
    useradd -u 500 -g 500 -m -s /bin/bash zope-www && \
    gpasswd -a zope-www wheel && \
    chown -R 500:500 $ZEO_HOME

VOLUME $ZEO_HOME/var/

USER zope-www

CMD ["start"]
