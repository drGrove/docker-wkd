FROM alpine:3.8

WORKDIR /root/

RUN apk add python3-dev gpgme git py3-setuptools gcc linux-headers musl-dev bash
RUN pip3 install --upgrade pip
RUN pip3 install python-gnupg
RUN git clone --depth 1 --branch v1.0\
  https://gitlab.com/drGrove/generate-openpgpkey-hu-3 &&\
  cd generate-openpgpkey-hu-3 &&\
  pip3 install -r requirements.txt
RUN mv generate-openpgpkey-hu-3/generate-openpgpkey-hu-3 $HOME/generate-hu

ADD generate-keyring .

ENTRYPOINT ["./generate-keyring"]
CMD [""]
