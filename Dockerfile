# The same image used by mybinder.org
FROM python:3.7-slim

# install qsharp and the notebook packages
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook qsharp

# pre-requisites for .NET SDK
RUN apt-get update && apt-get -y install wget && \
    apt-get update && apt-get -y install pgp && \
    apt-get update && apt-get -y install libgomp1 && \
# add vim for editing local files:
    apt-get update && apt-get -y install vim

# install .NET SDK 2.2
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get -y install apt-transport-https && \
    apt-get -y update && \
    apt-get -y install dotnet-sdk-2.2

# create user with a home directory
# Required for mybinder.org
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER=${NB_USER} \
    HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

# Make sure .net tools is in the path
ENV PATH=$PATH:${HOME}/dotnet:${HOME}/.dotnet/tools \
    DOTNET_ROOT=${HOME}/dotnet

# install IQSharp
RUN dotnet tool install -g Microsoft.Quantum.IQSharp --version 0.6.1905.301
RUN dotnet iqsharp install --user --path-to-tool="$(which dotnet-iqsharp)"

# Make sure the contents of our repo are in ${HOME}
# Required for mybinder.org
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Pre-exec notebooks to improve first-use start time
RUN dotnet build BasicGates
RUN jupyter nbconvert BasicGates/BasicGates.ipynb --execute --stdout --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120

RUN dotnet build CHSHGame
RUN jupyter nbconvert CHSHGame/CHSHGame.ipynb --execute --stdout --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120

RUN dotnet build DeutschJozsaAlgorithm
RUN jupyter nbconvert DeutschJozsaAlgorithm/DeutschJozsaAlgorithm.ipynb --execute --stdout --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120

RUN dotnet build Measurements
RUN jupyter nbconvert Measurements/Measurements.ipynb --execute --stdout --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120

RUN dotnet build Superposition
RUN jupyter nbconvert Superposition/Superposition.ipynb --execute --stdout --to markdown  --allow-errors  --ExecutePreprocessor.timeout=120
