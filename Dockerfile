# syntax=docker/dockerfile:1

FROM ubuntu:22.04 as base

WORKDIR /dockerbuild

# Disable installation of optional dependencies
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# Australian repository servers
COPY sources.list /etc/apt/sources.list

# Copy over build instructions for packages
COPY buildScript.sh /dockerbuild/buildScript.sh

# Allow execution of script
RUN chmod +x /dockerbuild/buildScript.sh

# Run build script to install required packages
RUN /dockerbuild/buildScript.sh

# NVIDIA Container toolkit
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN apt update && apt install -y nvidia-container-toolkit

# Librealsense installation
RUN mkdir -p /etc/apt/keyrings && \
    curl -sSf https://librealsense.intel.com/Debian/librealsense.pgp | tee /etc/apt/keyrings/librealsense.pgp > /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/librealsense.pgp] https://librealsense.intel.com/Debian/apt-repo `lsb_release -cs` main" | \
    tee /etc/apt/sources.list.d/librealsense.list && \
    apt-get update && apt-get install -y \
    librealsense2-dkms \
    librealsense2-utils && \
    rm -rf /var/lib/apt/lists/* 

# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     urt_user
# RUN usermod -aG sudo urt_user
# USER urt_user


CMD [ "bash" ]