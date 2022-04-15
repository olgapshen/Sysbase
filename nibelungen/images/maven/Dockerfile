FROM maven:3.8.1-jdk-8
LABEL maintainer='ya.olgapshenichnikova@yandex.ru'
COPY deps/core.jar /app/deps/
COPY deps/ojdbc8.jar /app/deps/
WORKDIR /app
RUN mvn install:install-file \
	-Dfile=deps/core.jar \
	-DgroupId=ru.belowess \
	-DartifactId=core \
	-Dversion=1.0 \
	-Dpackaging=jar
RUN mvn install:install-file \
	-Dfile=deps/ojdbc8.jar \
	-DgroupId=com.oracle \
	-DartifactId=ojdbc8 \
	-Dversion=1.0.0 \
	-Dpackaging=jar

RUN apt update
RUN apt install -y libxml2-utils
RUN apt install -y python3 python3-pip
RUN apt autoremove -y
RUN apt clean

COPY deps/requirements.txt /var/deps/
RUN pip3 install --no-cache-dir -r /var/deps/requirements.txt

ENV PATH "$PATH:/var/scripts"

COPY deps/upload.sh /var/scripts/
COPY deps/title.sh /var/scripts/
COPY deps/clean.py /var/scripts/
