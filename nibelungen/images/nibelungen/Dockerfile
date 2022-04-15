FROM alpine:latest
LABEL maintainer='ya.olgapshenichnikova@yandex.ru'
RUN apk update \
    && apk upgrade \
    && apk add curl

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3
RUN python3 -m ensurepip

COPY deps/requirements.txt /var/deps/
RUN pip3 install --no-cache-dir -r /var/deps/requirements.txt

ENV PATH "$PATH:/var/scripts"

COPY deps/upload.sh /var/scripts/
COPY deps/title.sh /var/scripts/
COPY deps/clean.py /var/scripts/
