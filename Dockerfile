FROM registry.cn-beijing.aliyuncs.com/mfimg/private:centos7.9

RUN yum install -y epel-release \
	&& rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro \
	&& rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm \
	&& yum install -y ffmpeg

COPY ./openresty-1.19.3.2.tar.gz /usr/local/src/

RUN yum -y install pcre-devel openssl openssl-devel gd-devel
RUN tar -zxf /usr/local/src/openresty-1.19.3.2.tar.gz -C /usr/local/src/ \
	&& cd /usr/local/src/openresty-1.19.3.2 \
	&& ./configure --prefix=/opt/openresty --with-http_image_filter_module \
	&& make \
	&& make install \
	&& rm -fr /usr/local/src/*
	
EXPOSE 8082

WORKDIR /opt/openresty/nginx

CMD ["/opt/openresty/bin/openresty", "-g", "daemon off;"]


#docker run --name=123pan-thumbnail --restart=always -v /opt/openresty/nginx/conf/nginx.conf:/opt/openresty/nginx/conf/nginx.conf -v /mnt/cephfs/123pan-thumbnail:/opt/openresty/nginx/html --env-file /opt/openresty/nginx/env/.env --net=host -d registry.cn-beijing.aliyuncs.com/123pan/private:thumbnail1.0 

