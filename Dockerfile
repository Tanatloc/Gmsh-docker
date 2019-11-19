FROM ubuntu AS builder

LABEL maintainer="https://github.com/orgs/tanatloc/people"

# Install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  cmake \
  g++ \
  gfortran \
  git \
  libopenblas-dev \
  liblapack-dev \
  libgl1-mesa-dev \
  libxi-dev \
  libxmu-dev \
  mesa-common-dev \
  tcl-dev \
  tk-dev \
  wget \
  && rm -rf /var/lib/apt/lists/*

ENV OCCPATH /root/occ
ENV GMSHPATH /root/gmsh

WORKDIR $OCCPATH

# Copy OCC repository
RUN wget https://github.com/tanatloc/Gmsh-docker/releases/download/0/opencascade-7.4.0.tgz
RUN tar xf opencascade-7.4.0.tgz

# Configure and build OCC
RUN cd opencascade-7.4.0\
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j "$(nproc)" \
  && make install

WORKDIR $GMSHPATH

# Copy gmsh directory
RUN git clone https://gitlab.onelab.info/gmsh/gmsh.git gmsh

# Configure and build Gmsh
RUN cd gmsh \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j "$(nproc)" \
  && make install

FROM ubuntu

LABEL maintainer="https://github.com/orgs/tanatloc/people"

# Install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  liblapack-dev \
  tcl-dev \
  tk-dev

# Copy local repository
RUN mkdir -p /usr/local
COPY --from=builder /usr/local /usr/local

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

ENV GLOB *.geo
CMD ["bash", "-c", "ls /data/$GLOB | xargs -I {} gmsh -3 {}"]
