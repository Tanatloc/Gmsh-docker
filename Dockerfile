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
  && cmake .. -DINSTALL_DIR=/usr/occ/ \
  && make -j "$(nproc)" \
  && make install

WORKDIR $GMSHPATH

# Copy gmsh directory
RUN git clone https://gitlab.onelab.info/gmsh/gmsh.git gmsh

# Configure and build Gmsh
RUN cd gmsh \
  && mkdir build \
  && cd build \
  && export PATH=/usr/occ:$PATH \
  && cmake -DCMAKE_INSTALL_PREFIX=/usr/gmsh -DENABLE_OCC=ON -DOCC_INC=/usr/occ/include/opencascade .. \
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
CMD ["bash", "-c", "ls /data/$GLOB | xargs -I {} /usr/gmsh/bin/gmsh -3 {}"]
