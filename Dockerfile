FROM debian:buster-slim
ARG GIT_BRANCH=v1.1.0

WORKDIR /root/

RUN apt update && apt install -y gnupg2 git python3 python3-gnupg
RUN git clone --depth 1 --branch ${GIT_BRANCH}\
  https://gitlab.com/drGrove/generate-openpgpkey-hu-3
RUN mv generate-openpgpkey-hu-3/generate-openpgpkey-hu-3 $HOME/generate-hu

ADD generate-keyring .

ENTRYPOINT ["./generate-keyring"]
CMD [""]
