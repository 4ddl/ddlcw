FROM ubuntu:20.04

LABEL maintainer="xudian.cn@gmail.com"

ENV TZ=UTC
ENV SDKMAN_DIR="/usr/local/sdkman"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DDLCW_ENV production
ENV DDLCW_SYNC_ENABLE False
ADD . /app
WORKDIR /app
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install curl zip unzip python3 python3-dev python3-pip gcc g++ libseccomp-dev cmake git software-properties-common python-is-python3 \
	golang-go
RUN curl -s "https://get.sdkman.io" | bash
RUN chmod a+x "$SDKMAN_DIR/bin/sdkman-init.sh"
RUN bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh && sdk ls java && sdk install java 14.0.2.fx-librca && sdk ls kotlin && sdk install kotlin"
# "OpenJDK 64-Bit Server VM warning: Options -Xverify:none and -noverify
# were deprecated in JDK 13 and will likely be removed in a future release."
# so only add -noverify for older versions
RUN sed -i "/noverify/d" /usr/local/sdkman/candidates/kotlin/current/bin/kotlinc
ENV JAVA_HONE=/usr/local/sdkman/candidates/java/current
ENV PATH=${PATH}:/usr/local/sdkman/candidates/kotlin/current/bin:/usr/local/sdkman/candidates/java/current/bin
RUN echo $PATH
RUN mkdir /config
RUN java -version 2> /config/java.info
RUN kotlin -version > /config/kotlin.info
RUN gcc -v 2> /config/gcc.info
RUN g++ -v 2> /config/g++.info
RUN go version > /config/go.info
RUN python -V > /config/python.info
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN cd /tmp && git clone --depth=1 https://github.com/4ddl/ddlc && cd ddlc \
	&& mkdir build && cd build && cmake .. && make && make install && apt-get clean && rm -rf /var/lib/apt/lists/* \
	&& mkdir /runner && useradd -u 12001 code
RUN pip3 install --no-cache-dir -r requirements.txt

