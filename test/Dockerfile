# Packages install.Linux.sh would install are already here, so its apt-get install
# is an "already installed" no-op. apt-get update in that script still contacts the network.
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    ncurses-base \
    passwd \
    sudo \
    zsh \
  && useradd --create-home --shell /bin/bash tester \
  && printf 'tester ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/tester \
  && chmod 440 /etc/sudoers.d/tester \
  && visudo -cf /etc/sudoers.d/tester

USER tester
WORKDIR /home/tester
