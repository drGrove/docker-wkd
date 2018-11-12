FROM vladgh/gpg:latest

RUN apk add python3-dev gpgme git py3-setuptools gcc linux-headers musl-dev

RUN pip3 install python-gnupg

RUN wget https://gitlab.com/Martin_/generate-openpgpkey-hu-3/raw/master/generate-openpgpkey-hu-3 && \
  chmod +x generate-openpgpkey-hu-3
-3
ENTRYPOINT ["./generate-openpgpkey-hu"]
CMD ["--help"]
