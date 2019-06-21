# The same image used by mybinder.org
FROM mcr.microsoft.com/quantum/iqsharp-base:0.8.1906.2007-beta

# Make sure the contents of our repo are in ${HOME}
# Required for mybinder.org
COPY . ${HOME}
USER root
RUN chown -R ${USER} ${HOME} && \
    chmod +x ${HOME}/build/*.sh
USER ${USER}

# Pre-exec notebooks to improve first-use start time
RUN ${HOME}/build/prebuild-kata.sh BasicGates
RUN ${HOME}/build/prebuild-kata.sh CHSHGame
RUN ${HOME}/build/prebuild-kata.sh DeutschJozsaAlgorithm
RUN ${HOME}/build/prebuild-kata.sh GHZGame
RUN ${HOME}/build/prebuild-kata.sh GroversAlgorithm
RUN ${HOME}/build/prebuild-kata.sh JointMeasurements
RUN ${HOME}/build/prebuild-kata.sh Measurements
RUN ${HOME}/build/prebuild-kata.sh SuperdenseCoding
RUN ${HOME}/build/prebuild-kata.sh Superposition
RUN ${HOME}/build/prebuild-kata.sh Teleportation
