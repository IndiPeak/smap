FROM openjdk:17

# Установка необходимых утилит
RUN apt-get update && apt-get install -y wget unzip git curl

# Android SDK
ENV ANDROID_SDK_ROOT /sdk
RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT} && \
    rm /tmp/cmdline-tools.zip

ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/bin:${ANDROID_SDK_ROOT}/platform-tools

# SDK лицензии и компоненты
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Копируем gradle wrapper
COPY gradle /gradle
COPY gradlew .
COPY build.gradle .
COPY settings.gradle .
RUN chmod +x ./gradlew

# Копируем весь проект
COPY . /app
WORKDIR /app

# Сборка проекта
CMD ["./gradlew", "assembleDebug"]
