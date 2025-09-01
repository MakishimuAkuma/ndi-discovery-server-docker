FROM --platform=$BUILDPLATFORM docker.io/debian:stable-slim AS get

WORKDIR /ndi-sdk

ADD "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v6_Linux.tar.gz" sdk.tar.gz

RUN tar -xf sdk.tar.gz

RUN chmod +x Install_NDI_SDK_v6_Linux.sh

RUN yes | PAGER=cat ./Install_NDI_SDK_v6_Linux.sh

FROM docker.io/debian:stable-slim AS sort

ARG TARGETPLATFORM

WORKDIR /ndi

COPY --from=get /ndi-sdk /ndi-sdk

RUN case "$TARGETPLATFORM" in \
        "linux/amd64") cp /ndi-sdk/"NDI SDK for Linux"/bin/x86_64-linux-gnu/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/arm64") cp /ndi-sdk/"NDI SDK for Linux"/bin/aarch64-rpi4-linux-gnueabi/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/arm/v8") cp /ndi-sdk/"NDI SDK for Linux"/bin/arm-rpi4-linux-gnueabihf/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/arm/v7") cp /ndi-sdk/"NDI SDK for Linux"/bin/arm-rpi3-linux-gnueabihf/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/386") cp /ndi-sdk/"NDI SDK for Linux"/bin/i686-linux-gnu/ndi-discovery-server /ndi/ndi-discovery-server ;; \
    esac

FROM docker.io/debian:stable-slim

WORKDIR /ndi

COPY --from=sort /ndi/ndi-discovery-server /ndi/ndi-discovery-server

RUN chmod +x ./ndi-discovery-server

EXPOSE 5959

CMD [ "./ndi-discovery-server" ]
