FROM gradle:5.4.1-jdk8
LABEL maintainer='ya.olgapshenichnikova@yandex.ru'

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=29 \
    ANDROID_BUILD_TOOLS_VERSION=29.0.2

RUN mkdir "$ANDROID_HOME" \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && echo "84831b9409646a918e30573bab4c9c91346d8" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

ENV ANDROID_SDK_ROOT="/usr/local/android-sdk"
ENV GRADLE_USER_HOME /root/gradle

ARG ARG_KEYSTORE
ARG ARG_PASSWORD
ENV KEYSTORE $ARG_KEYSTORE
ENV PASSWORD $ARG_PASSWORD

RUN apt update
RUN apt install -y zip rsync
RUN apt install -y python3 python3-pip
RUN apt autoremove -y
RUN apt clean

COPY deps/requirements.txt /var/deps/
RUN pip3 install --no-cache-dir -r /var/deps/requirements.txt

ENV PATH "$PATH:/var/scripts"

COPY deps/subscribe.sh /var/scripts/
COPY deps/upload.sh /var/scripts/
COPY deps/title.sh /var/scripts/
COPY deps/clean.py /var/scripts/
