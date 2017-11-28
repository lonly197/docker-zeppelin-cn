FROM  lonly/docker-zeppelin-base:0.7.3

ARG	 BUILD_DATE
ARG	 VERSION=0.7.3

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

ENV	ZEPPELIN_HOME=/opt/zeppelin

RUN	set -x \
	## enter work dir
	&& cd ${ZEPPELIN_HOME} \
	## unzip war	
	&& mkdir -p webapp \
	&& unzip -oq zeppelin-web-${VERSION}.war -d webapp \
	## remove old war
	&& rm -rf zeppelin-web-${VERSION}.war \
	## download update tar
	&& cd ./webapp/ \
	&& wget https://github.com/lonly197/zeppelin-web/archive/chinesization.tar.gz -O chinesization.tar.gz \
	&& tar xvf chinesization.tar.gz --strip 1 \
	&& rm -rf chinesization.tar.gz \
	## zip war
	&& jar -cvfM0 zeppelin-web-${VERSION}.war ${ZEPPELIN_HOME}/webapp \
	&& mv zeppelin-web-${VERSION}.war ${ZEPPELIN_HOME}/ \
	## exit work dir
	&& cd / \
	## clean
	&& rm -rf ${ZEPPELIN_HOME}/webapp \
	&& rm -rf /tmp/*

EXPOSE	8080 8443

VOLUME  ${ZEPPELIN_HOME}/logs \
	${ZEPPELIN_HOME}/notebook \
	${ZEPPELIN_HOME}/local-repo \
	${ZEPPELIN_HOME}/helium

WORKDIR	 ${ZEPPELIN_HOME}

CMD	 ./bin/zeppelin.sh run