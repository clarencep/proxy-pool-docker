FROM centos:7


RUN yum install -y python wget make gcc gcc-c++ autoconf automake which

RUN wget -O /tmp/ssdb.tar.gz --no-check-certificate https://github.com/ideawu/ssdb/archive/master.tar.gz 
RUN mkdir -p /usr/src/ssdb && tar -xzf /tmp/ssdb.tar.gz -C /usr/src/ssdb --strip-components=1 
RUN yum install -y libtool
RUN cd /usr/src/ssdb && make && make install

RUN wget -O /tmp/proxy_pool.tar.gz --no-check-certificate https://github.com/jhao104/proxy_pool/archive/master.tar.gz
RUN mkdir -p /usr/src/proxy_pool && tar -xzf /tmp/proxy_pool.tar.gz -C /usr/src/proxy_pool --strip-components=1 
RUN wget -q -O - https://bootstrap.pypa.io/get-pip.py | python
RUN cd /usr/src/proxy_pool && pip install -r requirements.txt 
RUN cd /usr/src/proxy_pool && sed 's/port = 8889/port = 8888/' -i.bak Config.ini

RUN yum erase -y wget make gcc gcc-c++ autoconf automake  \
    && find /var/log -type f -print0 | xargs -0 rm -rf /tmp/* \
    && yum clean all

CMD cd /usr/local/ssdb && ./ssdb-server -d ssdb.conf && cd /usr/src/proxy_pool/Run && python main.py


EXPOSE 5000 8888