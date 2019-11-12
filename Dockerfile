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
  && rm -rf /var/lib/apt/lists/*

ENV OCCPATH /root/occ
ENV GMSHPATH /root/gmsh

WORKDIR $OCCPATH

# Copy OCC repository
wget https://github.com/tanatloc/Gmsh-docker/releases/download/0/opencascade-7.4.0.tgz
ADD opencascade-7.4.0.tgz $OCCPATH

# Configure and build OCC
RUN cd opencascade-7.4.0\
  && mkdir build \
  && cd build \
  && cmake .. -DINSTALL_DIR=/usr/occ/ \
  && make \
  && make install

WORKDIR $GMSHPATH

# Copy gmsh directory
RUN git clone https://gitlab.onelab.info/gmsh/gmsh.git gmsh

# Configure and build Gmsh
RUN cd gmsh \
  && mkdir build \
  && cd build \
  && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/gmsh \
  && make \
  && make install

FROM ubuntu

LABEL maintainer="https://github.com/orgs/tanatloc/people"

# Install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  liblapack-dev \
  tcl-dev \
  tk-dev

# Copy OCC repository
RUN mkdir /usr/occ
COPY --from=builder /usr/occ /usr/occ

# Copy Gmsh repository
RUN mkdir /usr/gmsh
COPY --from=builder /usr/gmsh /usr/gmsh

# Add Gmsh to .bashrc
RUN touch /root/.bach_aliases \
  && echo "alias gmsh='/usr/gmsh/bin/gmsh'" > /root/.bash_aliases

ENV GLOB *.geo
CMD ["bash", "-c", "ls /data/$GLOB | xargs -I {} gmsh -3 {}"]
