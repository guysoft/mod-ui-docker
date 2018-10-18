FROM ubuntu:18.04
MAINTAINER Guy Sheffer <guysoft@gmail.com>

# Parts taken from https://github.com/elgalu/docker-selenium/blob/master/Dockerfile

EXPOSE 22
EXPOSE 5900


ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    tzdata \
    rsync \
    apt-utils \
    python3 \
    python3-distutils \
    python3-dev \
    wget \
    jackd2 \
    lsof \
    libjack-jackd2-dev \
    locales \
    git \
    sudo \
    unzip \
    xvfb \
    x11vnc \
    lv2-dev \
    liblilv-dev \
    libasound2-dev \
    libreadline-dev \
    lilv-utils \
    # For timelib
    build-essential \
  && locale-gen ${LANGUAGE} \
  && locale-gen he_IL.UTF-8 \
  && dpkg-reconfigure --frontend noninteractive locales \
  && rm -rf /var/lib/apt/lists/* \
  && apt -qyy clean

#===================
# Timezone settings
#===================
# Full list at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#  e.g. "US/Pacific" for Los Angeles, California, USA
# e.g. ENV TZ "US/Pacific"
ENV TZ="Asia/Jerusalem"
# Apply TimeZone
# Layer size: tiny: 1.339 MB
RUN echo "Setting time zone to '${TZ}'" \
  && echo "${TZ}" > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#========================================
# Add normal user with passwordless sudo
#========================================
# Layer size: tiny: 0.3 MB
RUN useradd moduser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo moduser \
  && gpasswd -a moduser video \
  && echo 'moduser:secret' | chpasswd \
  && useradd extrauser \
         --shell /bin/bash  \
  && usermod -a -G sudo extrauser \
  && gpasswd -a extrauser video \
  && gpasswd -a extrauser moduser \
  && echo 'extrauser:secret' | chpasswd \
&& echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers


RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3


#===================================================
# Run the following commands as non-privileged user
#===================================================
USER moduser
WORKDIR /home/moduser

ARG ZYNTHIAN_SW_DIR=/home/moduser
ARG ZYNTHIAN_PLUGINS_SRC_DIR=/home/moduser/src-mod-plugins/
ARG ZYNTHIAN_PLUGINS_DIR=/home/moduser/mod-plugins/
RUN mkdir -p /home/moduser/mod-plugins/
RUN mkdir -p /home/moduser/src-mod-plugins/

COPY ./install_mod-utilities.sh /home/moduser/install_mod-utilities.sh
RUN /home/moduser/install_mod-utilities.sh


COPY ./install_mod-host.sh /home/moduser/install_mod-host.sh
RUN /home/moduser/install_mod-host.sh

COPY ./install_mod-ui.sh /home/moduser/install_mod-ui.sh
RUN /home/moduser/install_mod-ui.sh
VOLUME /home/moduser/mod-ui/data



COPY ./install_mod-distortion.sh /home/moduser/install_mod-distortion.sh
RUN /home/moduser/install_mod-distortion.sh
COPY ./install_mod-tap.sh /home/moduser/install_mod-tap.sh
RUN /home/moduser/install_mod-tap.sh
COPY ./install_mod-caps.sh /home/moduser/install_mod-caps.sh
RUN /home/moduser/install_mod-caps.sh
COPY ./install_mod-pitchshifter.sh /home/moduser/install_mod-pitchshifter.sh
RUN /home/moduser/install_mod-pitchshifter.sh
COPY ./install_mod-mda.sh /home/moduser/install_mod-mda.sh
RUN /home/moduser/install_mod-mda.sh
COPY ./postinstall_mod-lv2-data.sh /home/moduser/postinstall_mod-lv2-data.sh
RUN /home/moduser/postinstall_mod-lv2-data.sh



RUN echo "/usr/bin/jackd -m -dalsa -r44100 -p4096 -n3 -s -D -Chw:I82801AAICH -Phw:I82801AAICH" > ~/.jackdrc && chmod 755 ~/.jackdrc


COPY ./run.sh /home/moduser/run.sh
ENTRYPOINT /home/moduser/run.sh





