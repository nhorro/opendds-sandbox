FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    build-essential cmake git wget curl nano \
    python3 python3-pip python3-setuptools \
    libssl-dev libxerces-c-dev \
    && rm -rf /var/lib/apt/lists/*

# Clonar e instalar OpenDDS
WORKDIR /opt

RUN git clone https://github.com/OpenDDS/OpenDDS.git && \
    cd OpenDDS && \
    git checkout DDS-3.13.2  # o la última versión compatible con Ubuntu 20.04

# Configurar e instalar OpenDDS
RUN cd /opt/OpenDDS && \
    ./configure --no-tests && \
    make -j$(nproc)

# Definición de variables de entorno para OpenDDS + ACE/TAO
ENV DDS_ROOT=/opt/OpenDDS
ENV ACE_ROOT=$DDS_ROOT/ACE_wrappers
ENV TAO_ROOT=$ACE_ROOT/TAO

# Añadir herramientas de OpenDDS al PATH
ENV PATH=$DDS_ROOT/bin:$PATH

# Incluir todas las rutas necesarias de bibliotecas compartidas
ENV LD_LIBRARY_PATH=$DDS_ROOT/lib:$ACE_ROOT/lib:$TAO_ROOT/TAO_IDL:$LD_LIBRARY_PATH

ENV PATH=$DDS_ROOT/bin:$DDS_ROOT/ACE_wrappers/TAO/TAO_IDL:$PATH

# Crear usuario no-root con UID/GID del host (esto se setea en tiempo de build con ARGs)
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID --create-home $USERNAME && \
    chown -R $USERNAME:$USERNAME /opt/OpenDDS

USER $USERNAME
ENV HOME=/home/$USERNAME
WORKDIR /workspace