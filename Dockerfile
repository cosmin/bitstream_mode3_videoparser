FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

# update, and install basic packages

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get -y install --no-install-recommends \
    python3 \
    python3-numpy \
    python3-pip \
    git \
    scons \
    autoconf \
    automake \
    build-essential \
    libass-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtheora-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    pkg-config \
    texinfo \
    wget \
    zlib1g-dev \
    yasm	


ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN pip3 install --upgrade pip
RUN pip3 install pandas

WORKDIR /opt/bitstream
ADD ffmpeg ffmpeg/
ADD PythonInterface PythonInterface/
ADD VideoParser VideoParser/

WORKDIR /opt/bitstream/ffmpeg
RUN ./configure_ffmpeg.sh
RUN make -j $(nproc)
RUN make install

WORKDIR /opt/bitstream
ADD TestMain TestMain/

WORKDIR /opt/bitstream/VideoParser/
RUN scons

ADD parser.sh /opt/bitstream/

WORKDIR /root
