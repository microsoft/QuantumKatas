# We use the iqsharp-base image, as that includes
# the .NET Core SDK, IQ#, and Jupyter Notebook already
# installed for us.
FROM mcr.microsoft.com/quantum/iqsharp-base:0.8.1907.1701

# Add metadata indicating that this image is used for the katas.
ENV IQSHARP_HOSTING_ENV=KATAS_DOCKERFILE

# Make sure the contents of our repo are in ${HOME}
# Required for mybinder.org
COPY . ${HOME}
USER root
RUN chown -R ${USER} ${HOME} && \
    chmod +x ${HOME}/scripts/*.sh
USER ${USER}

# Pre-exec notebooks to improve first-use start time
RUN ${HOME}/scripts/prebuild-kata.sh BasicGates
RUN ${HOME}/scripts/prebuild-kata.sh CHSHGame
RUN ${HOME}/scripts/prebuild-kata.sh DeutschJozsaAlgorithm
RUN ${HOME}/scripts/prebuild-kata.sh GHZGame
RUN ${HOME}/scripts/prebuild-kata.sh GraphColoring
RUN ${HOME}/scripts/prebuild-kata.sh GroversAlgorithm
RUN ${HOME}/scripts/prebuild-kata.sh JointMeasurements
RUN ${HOME}/scripts/prebuild-kata.sh MagicSquareGame
RUN ${HOME}/scripts/prebuild-kata.sh Measurements
RUN ${HOME}/scripts/prebuild-kata.sh QEC_BitFlipCode
RUN ${HOME}/scripts/prebuild-kata.sh SolveSATWithGrover
RUN ${HOME}/scripts/prebuild-kata.sh SuperdenseCoding
RUN ${HOME}/scripts/prebuild-kata.sh Superposition
RUN ${HOME}/scripts/prebuild-kata.sh Teleportation
RUN ${HOME}/scripts/prebuild-kata.sh UnitaryPatterns
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/DeutschJozsaAlgorithm DeutschJozsaAlgorithmTutorial.ipynb
