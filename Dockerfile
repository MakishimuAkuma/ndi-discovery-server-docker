FROM docker.io/alpine:latest AS builder

ARG TARGETPLATFORM

WORKDIR /ndi-sdk

ADD "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v6_Linux.tar.gz" sdk.tar.gz

RUN tar -xf sdk.tar.gz

RUN chmod +x Install_NDI_SDK_v6_Linux.sh

RUN yes | PAGER=cat ./Install_NDI_SDK_v6_Linux.sh

RUN mkdir /ndi

RUN case "$TARGETPLATFORM" in \
        "linux/amd64") cp ./"NDI SDK for Linux"/bin/x86_64-linux-gnu/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/arm64") cp ./"NDI SDK for Linux"/bin/aarch64-rpi4-linux-gnueabi/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/arm/v8") cp ./"NDI SDK for Linux"/bin/arm-rpi4-linux-gnueabihf/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/arm/v7") cp ./"NDI SDK for Linux"/bin/arm-rpi3-linux-gnueabihf/ndi-discovery-server /ndi/ndi-discovery-server ;; \
        "linux/386") cp ./"NDI SDK for Linux"/bin/i686-linux-gnu/ndi-discovery-server /ndi/ndi-discovery-server ;; \
    esac

FROM docker.io/alpine:latest

WORKDIR /ndi

COPY --from=builder /ndi/ndi-discovery-server ./ndi-discovery-server

RUN chmod +x ./ndi-discovery-server

EXPOSE 5959

CMD [ "./ndi-discovery-server" ]
