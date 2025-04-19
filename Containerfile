FROM stagex/pallet-gcc-gnu-busybox AS build-inotify
COPY --from=stagex/core-sqlite3 . /
COPY --from=stagex/user-doxygen . /
ADD \
  --checksum=sha256:1dfa33f80b6797ce2f6c01f454fd486d30be4dca1b0c5c2ea9ba3c30a5c39855 \
  https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.23.9.0.tar.gz \
  /tmp/inotify-tools-4.23.9.0.tar.gz
RUN \
  mkdir -p /rootfs/usr && \
  cd /tmp/ && \
  tar -xzf inotify-tools-4.23.9.0.tar.gz && \
  rm inotify-tools-4.23.9.0.tar.gz && \
  cd inotify-tools-4.23.9.0 && \
  ./autogen.sh && \
  ./configure --prefix=/usr --enable-fanotify && \
  make && \
  make DESTDIR=/rootfs/ install

FROM stagex/pallet-rust AS build-wkd-exporter
ADD \ 
  --checksum=sha256:378df2effa432d326ad31a81ad8c750de13cc03da379e56c710377651da985f9 \
  https://github.com/wiktor-k/wkd-exporter/archive/refs/tags/v0.2.2.tar.gz \
  /tmp/wkd-exporter-0.2.2.tar.gz
RUN \
  mkdir -p /rootfs/usr && \
  cd /tmp/ && \
  tar -xzf wkd-exporter-0.2.2.tar.gz && \
  rm wkd-exporter-0.2.2.tar.gz && \
  cd wkd-exporter-0.2.2 && \
  cargo fetch --locked && \
  CARGO_TARGET_DIR="target" cargo build --frozen --release --all-features && \
  install -vDm 755 target/release/wkd-exporter -t "/rootfs/usr/bin/" && \
  install -vDm 644 README.md -t "/rootfs/usr/share/doc/wkd-exporter/" && \
  install -vDm 644 LICENSE* -t "/rootfs/usr/share/licenses/wkd-exporter/"

FROM stagex/core-filesystem AS package
COPY --from=stagex/core-bash  . /
COPY --from=stagex/core-busybox . /
COPY --from=stagex/core-gcc . /
COPY --from=stagex/core-gmp . /
COPY --from=stagex/core-libunwind . /
COPY --from=stagex/core-musl . /
COPY --from=stagex/core-openssl . /
COPY --from=stagex/core-sqlite3 . /
COPY --from=stagex/core-zlib  . /
COPY --from=stagex/user-gpg  . /
COPY --from=stagex/user-libassuan  . /
COPY --from=stagex/user-libgcrypt  . /
COPY --from=stagex/user-libgpg-error  . /
COPY --from=stagex/user-nettle  . /
COPY --from=stagex/user-npth  . /
COPY --from=stagex/user-sequoia-sq  . /
COPY --from=stagex/user-sequoia-sq-wot  . /
COPY --from=build-inotify /rootfs/ .
COPY --from=build-wkd-exporter /rootfs/ .
ADD generate-wkd /usr/local/bin/
ADD wkd-sync /usr/local/bin/

COPY --from=build-inotify /rootfs/ .
ADD generate-wkd /usr/local/bin/
ADD wkd-sync /usr/local/bin/

WORKDIR /home/user/
ENTRYPOINT [ "/usr/local/bin/generate-wkd" ]
