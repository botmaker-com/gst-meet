FROM docker.io/library/alpine:3.16 AS builder
RUN apk --no-cache --update upgrade --ignore alpine-baselayout \
 && apk --no-cache add curl \
 && apk --no-cache add gstreamer-dev gst-plugins-base-dev \
 && apk --no-cache add build-base libnice-dev openssl-dev cargo
COPY . .
RUN cargo build --release -p gst-meet
##RUN cargo install --path gst-meet --root gst-meet --force gst-meet

FROM docker.io/library/alpine:3.16

ENV GST_DEBUG=3
ENV GST_DEBUG_DUMP_DOT_DIR=/tmp
ENV GST_PLUGIN_SYSTEM_PATH_1_0=/usr/lib/gstreamer-1.0
ENV GST_PLUGIN_PATH_1_0=/usr/lib/gstreamer-1.0

RUN apk --update --no-cache upgrade --ignore alpine-baselayout \
 && apk --no-cache add curl \
 && apk --no-cache add gstreamer gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav libnice-gstreamer gstreamer-tools gst-plugins-base \
 && apk --no-cache add glib \
 && apk --no-cache add libnice openssl \
 && apk --no-cache add youtube-dl
 ##&& apk --no-cache add gcompat libstdc++ \
 ##&& apk --no-cache add intel-media-driver \
 ##&& apk --no-cache add libva-intel-driver

COPY --from=builder target/release/gst-meet /usr/local/bin

WORKDIR /tmp

ENTRYPOINT ["/bin/sleep","9999"]