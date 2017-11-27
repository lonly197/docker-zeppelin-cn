FROM  lonly/docker-zeppelin-base:0.7.3

ARG	 BUILD_DATE
ARG	 DIST_MIRROR=http://archive.apache.org/dist/zeppelin
ARG	 VERSION=0.7.3
ARG	 UPDATE_TAR=https://github.com/lonly197/zeppelin-web/archive/chinesization.zip

LABEL \
	maintainer="lonly197@qq.com" \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.docker.dockerfile="/Dockerfile" \
	org.label-schema.license="Apache License 2.0" \
	org.label-schema.name="lonly/docker-zeppelin-cn" \
	org.label-schema.url="https://github.com/lonly197" \
	org.label-schema.vcs-type="Git" \
	org.label-schema.version=$VERSION \
	org.label-schema.vcs-url="https://github.com/lonly197/docker-zeppelin-cn"

ENV	ZEPPELIN_HOME=/opt/zeppelin \
    TEMP=/tmp \
	JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
	PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

RUN	set -x \
	## fix 'ERROR: http://dl-cdn.alpinelinux.org/alpine/v3.6/main: BAD archive'
    && echo http://mirrors.aliyun.com/alpine/v3.6/main/ >> /etc/apk/repositories \
    && echo http://mirrors.aliyun.com/alpine/v3.6/community/>> /etc/apk/repositories \
	&& apk update \
	&& apk add --no-cache --upgrade ca-certificates wget openssl \
	&& update-ca-certificates \
	## download update tar
    && mkdir -p ${TEMP} \
	&& wget -P ${TEMP}/ ${UPDATE_TAR} \
	&& unzip -o ${TEMP}/chinesization.zip -d ${TEMP}/ \
	&& rsync -avhP  ${TEMP}/zeppelin-web-chinesization/* ${ZEPPELIN_HOME}/webapps/webapp/ \
	## cleanup
	&& rm -rf /var/cache/* \
	&& rm -rf ${TEMP}/*

EXPOSE	8080 8443

VOLUME  ${ZEPPELIN_HOME}/logs \
	${ZEPPELIN_HOME}/notebook \
	${ZEPPELIN_HOME}/local-repo \
	${ZEPPELIN_HOME}/webapps/webapp

WORKDIR	 ${ZEPPELIN_HOME}

CMD	 ./bin/zeppelin.sh run