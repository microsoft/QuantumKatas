# We use the iqsharp-base image, as that includes
# the .NET Core SDK, IQ#, and Jupyter Notebook already
# installed for us.
FROM mcr.microsoft.com/quantum/iqsharp-base:0.10.1911.1607

# Add metadata indicating that this image is used for the katas.
ENV IQSHARP_HOSTING_ENV=KATAS_DOCKERFILE

# Make sure the contents of our repo are in ${HOME}
# Required for mybinder.org
COPY . ${HOME}
USER root

# Install Python dependencies for the Python visualization and tutorial notebooks
RUN pip install "matplotlib"
RUN pip install "pytest"

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
RUN ${HOME}/scripts/prebuild-kata.sh KeyDistribution_BB84
RUN ${HOME}/scripts/prebuild-kata.sh MagicSquareGame
RUN ${HOME}/scripts/prebuild-kata.sh Measurements
RUN ${HOME}/scripts/prebuild-kata.sh PhaseEstimation
RUN ${HOME}/scripts/prebuild-kata.sh QEC_BitFlipCode
RUN ${HOME}/scripts/prebuild-kata.sh RippleCarryAdder
RUN ${HOME}/scripts/prebuild-kata.sh SolveSATWithGrover
RUN ${HOME}/scripts/prebuild-kata.sh SuperdenseCoding
RUN ${HOME}/scripts/prebuild-kata.sh Superposition
RUN ${HOME}/scripts/prebuild-kata.sh Teleportation
# Exclude Unitary patterns, since it times out in Binder prebuild
# RUN ${HOME}/scripts/prebuild-kata.sh UnitaryPatterns
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/ComplexArithmetic ComplexArithmetic.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/ExploringDeutschJozsaAlgorithm DeutschJozsaAlgorithmTutorial.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/ExploringGroversAlgorithm ExploringGroversAlgorithmTutorial.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/LinearAlgebra LinearAlgebra.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/MultiQubitGates MultiQubitGates.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/MultiQubitSystems MultiQubitSystems.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/Qubit Qubit.ipynb
RUN ${HOME}/scripts/prebuild-kata.sh tutorials/SingleQubitGates SingleQubitGates.ipynb
