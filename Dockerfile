# The same image used by mybinder.org
FROM mcr.microsoft.com/quantum/iqsharp-base:0.8.1907.1701

# Add metadata indicating that this image is used for the katas.
ENV IQSHARP_HOSTING_ENV=KATAS_DOCKERFILE

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
RUN ${HOME}/build/prebuild-kata.sh MagicSquareGame
RUN ${HOME}/build/prebuild-kata.sh Measurements
RUN ${HOME}/build/prebuild-kata.sh QEC_BitFlipCode
RUN ${HOME}/build/prebuild-kata.sh SolveSATWithGrover
RUN ${HOME}/build/prebuild-kata.sh SuperdenseCoding
RUN ${HOME}/build/prebuild-kata.sh Superposition
RUN ${HOME}/build/prebuild-kata.sh Teleportation
RUN ${HOME}/build/prebuild-kata.sh tutorials/DeutschJozsaAlgorithm DeutschJozsaAlgorithmTutorial.ipynb
