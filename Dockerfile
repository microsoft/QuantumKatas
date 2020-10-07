# We use the iqsharp-base image, as that includes
# the .NET Core SDK, IQ#, and Jupyter Notebook already
# installed for us.
FROM mcr.microsoft.com/quantum/iqsharp-base:0.12.20100504

# Add metadata indicating that this image is used for the katas.
ENV IQSHARP_HOSTING_ENV=KATAS_DOCKERFILE

# Make sure the contents of our repo are in ${HOME}
# Required for mybinder.org
COPY . ${HOME}

# Run some commands as root
USER root
# Install Python dependencies for the Python visualization and tutorial notebooks
RUN pip install -I --no-cache-dir \
        matplotlib \
        numpy \
        pytest && \
# Give permissions to the jovyan user
    chown -R ${USER} ${HOME} && \
    chmod +x ${HOME}/scripts/*.sh

# From now own, just run things as the jovyan user
USER ${USER}

RUN cd ${HOME} && \
# Call dotnet restore for each project to pre-populate NuGet cache
    dotnet restore BasicGates && \
    dotnet restore CHSHGame && \
    dotnet restore DeutschJozsaAlgorithm && \
    dotnet restore DistinguishUnitaries && \
    dotnet restore GHZGame && \
    dotnet restore GraphColoring && \
    dotnet restore GroversAlgorithm && \
    dotnet restore JointMeasurements && \
    dotnet restore KeyDistribution_BB84 && \
    dotnet restore MagicSquareGame && \
    dotnet restore Measurements && \
    dotnet restore PhaseEstimation && \
    dotnet restore QEC_BitFlipCode && \
    dotnet restore QFT && \
    dotnet restore RippleCarryAdder && \
    dotnet restore SolveSATWithGrover && \
    dotnet restore SuperdenseCoding && \
    dotnet restore Superposition && \
    dotnet restore Teleportation && \
    dotnet restore TruthTables && \
    dotnet restore UnitaryPatterns && \
    dotnet restore tutorials/ComplexArithmetic && \
    dotnet restore tutorials/ExploringDeutschJozsaAlgorithm && \
    dotnet restore tutorials/ExploringGroversAlgorithm && \
    dotnet restore tutorials/LinearAlgebra && \
    dotnet restore tutorials/MultiQubitGates && \
    dotnet restore tutorials/MultiQubitSystems && \
    dotnet restore tutorials/QuantumClassification && \
    dotnet restore tutorials/Qubit && \
    dotnet restore tutorials/RandomNumberGeneration && \
    dotnet restore tutorials/SingleQubitGates && \
# To improve performance when loading packages at IQ# kernel initialization time,
# we remove all online sources for NuGet such that IQ# Package Loading and NuGet dependency
# resolution won't attempt to resolve packages dependencies again (as it was already done
# during the dotnet restore steps above).
# The downside is that only packages that were already downloaded to .nuget/packages folder
# will be available to get loaded.
# Users that require loading additional packages should use the iqsharp-base image instead.
    rm ${HOME}/NuGet.config && \
    echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\
          <configuration>\
              <packageSources>\
                   <clear />\
              </packageSources>\
          </configuration>\
    " > ${HOME}/.nuget/NuGet/NuGet.Config && \
# Pre-exec notebooks to improve first-use start time
# (the katas that are less frequently used on Binder are excluded to improve overall Binder build time)
    ./scripts/prebuild-kata.sh BasicGates && \
    ./scripts/prebuild-kata.sh CHSHGame && \
    ./scripts/prebuild-kata.sh DeutschJozsaAlgorithm && \
    ./scripts/prebuild-kata.sh DistinguishUnitaries && \
    #./scripts/prebuild-kata.sh GHZGame && \
    ./scripts/prebuild-kata.sh GraphColoring && \
    ./scripts/prebuild-kata.sh GroversAlgorithm && \
    ./scripts/prebuild-kata.sh JointMeasurements && \
    #./scripts/prebuild-kata.sh KeyDistribution_BB84 && \
    #./scripts/prebuild-kata.sh MagicSquareGame && \
    ./scripts/prebuild-kata.sh Measurements && \
    ./scripts/prebuild-kata.sh PhaseEstimation && \
    #./scripts/prebuild-kata.sh QEC_BitFlipCode && \
    ./scripts/prebuild-kata.sh QFT && \
    #./scripts/prebuild-kata.sh RippleCarryAdder && \
    ./scripts/prebuild-kata.sh SolveSATWithGrover && \
    ./scripts/prebuild-kata.sh SuperdenseCoding && \
    ./scripts/prebuild-kata.sh Superposition && \
    ./scripts/prebuild-kata.sh Teleportation && \
    ./scripts/prebuild-kata.sh TruthTables && \
    # Exclude Unitary patterns, since it times out in Binder prebuild
    #./scripts/prebuild-kata.sh UnitaryPatterns && \
    ./scripts/prebuild-kata.sh tutorials/ComplexArithmetic ComplexArithmetic.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/ExploringDeutschJozsaAlgorithm DeutschJozsaAlgorithmTutorial.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/ExploringGroversAlgorithm ExploringGroversAlgorithmTutorial.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/LinearAlgebra LinearAlgebra.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/MultiQubitGates MultiQubitGates.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/MultiQubitSystems MultiQubitSystems.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/Qubit Qubit.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/RandomNumberGeneration RandomNumberGenerationTutorial.ipynb && \
    ./scripts/prebuild-kata.sh tutorials/SingleQubitGates SingleQubitGates.ipynb

# Set the working directory to $HOME (/home/jovyan/)
WORKDIR ${HOME}

# Set default command when running a Docker container instance
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
