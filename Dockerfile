FROM  lonly/docker-zeppelin-base:0.7.2

ARG	 BUILD_DATE
ARG	 VERSION=0.7.2

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
	## install base package for interpreter
    && apk add --no-cache --upgrade build-base gfortran python2 python2-dev py2-pip freetype-dev libpng-dev python2-tkinter lapack-dev libxml2-dev libxslt-dev jpeg-dev \
	## update pip
	&& pip install --upgrade --no-cache-dir pip \
	## pip install pakcate
	&& pip install --upgrade --no-cache-dir py4j numpy scipy pandas matplotlib \
	## enter work dir
	&& cd ${ZEPPELIN_HOME} \
	## unzip war	
	&& mkdir -p webapp \
	&& unzip -oq zeppelin-web-${VERSION}.war -d webapp \
	## remove old war
	&& rm -rf zeppelin-web-${VERSION}.war \
	## enter webapp dir
	&& cd ./webapp/ \
	## download update tar
	&& wget https://github.com/lonly197/zeppelin-web/archive/${VERSION}-cn.tar.gz -O ${VERSION}-cn.tar.gz \
	&& tar xvf ${VERSION}-cn.tar.gz --strip 1 \
	&& rm -rf ${VERSION}-cn.tar.gz \
	## zip war
	&& jar -cvfM0 zeppelin-web-${VERSION}.war ./* \
	&& mv zeppelin-web-${VERSION}.war ${ZEPPELIN_HOME}/ \
	## exit work dir
	&& cd / \
	## clean
	&& rm -rf ${ZEPPELIN_HOME}/webapp \
	&& rm -rf /tmp/*

EXPOSE	8080 8443

VOLUME  ${ZEPPELIN_HOME}/conf \
	${ZEPPELIN_HOME}/logs \
	${ZEPPELIN_HOME}/notebook \
	${ZEPPELIN_HOME}/local-repo \
	${ZEPPELIN_HOME}/helium

WORKDIR	 ${ZEPPELIN_HOME}

CMD	 ./bin/zeppelin.sh run