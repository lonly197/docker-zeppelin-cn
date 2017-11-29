FROM  lonly/docker-zeppelin-base:0.7.3

ARG	 BUILD_DATE
ARG	 VERSION=0.7.3
ARG  VCS_REF

LABEL \
	maintainer="lonly197@qq.com" \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.docker.dockerfile="/Dockerfile" \
	org.label-schema.license="Apache License 2.0" \
	org.label-schema.name="lonly/docker-zeppelin-cn" \
	org.label-schema.url="https://github.com/lonly197" \
	org.label-schema.version=$VERSION \
	org.label-schema.vendor="lonly197@qq.com" \
	org.label-schema.description="Basic and clean Docker image for the chinesization of Apache Zeppelin, based on Alpine and OpenJDK." \
	org.label-schema.vcs-type="Git" \
	org.label-schema.vcs-url="https://github.com/lonly197/docker-zeppelin-cn" \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.schema-version="1.0"

ENV	ZEPPELIN_HOME=/opt/zeppelin

RUN	set -x \
	## install base package
    && apk add --no-cache --upgrade autoclean build-base libglib2.0-0 libxext6 libsm6 libxrender1 \
	## install python
	&& apk add --no-cache --upgrade python2 python2-dev py2-pip \
	## update pip
	&& pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade --no-cache-dir pip \
	## install python related package
	&& apk add --no-cache --upgrade gfortran \
	## for numerical/algebra packages
	&& apk add --no-cache --upgrade libblas-dev libatlas-dev liblapack-dev \
	## for font, image for matplotlib
	&& apk add --no-cache --upgrade libpng-dev libfreetype6-dev libxft-dev \
	## for tkinter
	&& apk add --no-cache --upgrade  python-tk libxml2-dev libxslt-dev zlib1g-dev \
	## install numpy and matplotlib
	&& pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade --no-cache-dir py4j numpy scipy pandas matplotlib \
	## install R
	&& apk add --no-cache --upgrade r-base r-base-dev libcurl4-gnutls-dev libssl-dev \
	&& R -e "install.packages('knitr', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('ggplot2', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('googleVis', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('data.table', repos='http://cran.us.r-project.org')" \
	# install R for devtools, Rcpp
    && R -e "install.packages('devtools', repos='http://cran.us.r-project.org')" \
    && R -e "install.packages('Rcpp', repos='http://cran.us.r-project.org')" \
    && Rscript -e "library('devtools'); library('Rcpp'); install_github('ramnathv/rCharts')" \
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
	&& rm -rf /tmp/* \
	&& apk autoclean \
	&& apk clean

CMD	 ${ZEPPELIN_HOME}/bin/zeppelin.sh run