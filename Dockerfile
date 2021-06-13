# bullseye-slim 12-10-2020 20:02
FROM debian@sha256:2cc2cda22c14cf9a40dad00509be66aaeab4756c3f6452dadcf27ac01e16ad68 as builder

WORKDIR /root/

RUN apt update
RUN apt install -y --fix-missing \
  capnproto \
  cargo \
  clang \
  git \
  libclang1-9 \
  libsqlite3-dev \
  libssl-dev \
  make \
  nettle-dev \
  pkg-config \
  python3-cffi \
  python3-dev \
  python3-pytest \
  python3-setuptools \
  rustc

RUN git clone --depth 1 --branch sq/v0.25.0 https://gitlab.com/sequoia-pgp/sequoia
WORKDIR /root/sequoia/
RUN CARGO_TARGET_DIR=target cargo build -p sequoia-sq --release && \
  install --strip -D --target-directory /opt/usr/local/bin \
    target/release/sq

FROM debian@sha256:2cc2cda22c14cf9a40dad00509be66aaeab4756c3f6452dadcf27ac01e16ad68 as main

RUN apt update && apt install -y gnupg inotify-tools

COPY --from=builder /opt/usr/local/bin/sq /usr/local/bin/sq
ADD generate-wkd /usr/local/bin/generate-wkd
ADD wkd-sync /usr/local/bin/wkd-sync

RUN adduser --disabled-password --uid 1000 user

USER user
WORKDIR /home/user/

ENTRYPOINT ["/usr/local/bin/generate-wkd"]
CMD [""]
