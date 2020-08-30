// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

//////////////////////////////////////////////////////////////////////
// This file contains implementations of training and classification routines
// used in part 1 of the tutorial ("Exploring Quantum Classification Library").
// You should not modify anything in this file.
//////////////////////////////////////////////////////////////////////

namespace Microsoft.Quantum.Kata.QuantumClassification {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.MachineLearning;
    open Microsoft.Quantum.Math;

    function DefaultSchedule(samples : Double[][]) : SamplingSchedule {
        return SamplingSchedule([
            0..Length(samples) - 1
        ]);
    }

    // The definition of classifier structure for the case when the data is linearly separable and fits into 1 qubit
    function ClassifierStructure() : ControlledRotation[] {
        return [
            ControlledRotation((0, new Int[0]), PauliY, 0)
        ];
    }


    // Entry point for training a model; takes the data as the input and uses hard-coded classifier structure.
    operation TrainLinearlySeparableModel(
        trainingVectors : Double[][],
        trainingLabels : Int[],
        initialParameters : Double[][]
    ) : (Double[], Double) {
        // convert training data and labels into a single data structure
        let samples = Mapped(
            LabeledSample,
            Zip(trainingVectors, trainingLabels)
        );
        let (optimizedModel, nMisses) = TrainSequentialClassifier(
            Mapped(
                SequentialModel(ClassifierStructure(), _, 0.0),
                initialParameters
            ),
            samples,
            DefaultTrainingOptions()
                w/ LearningRate <- 2.0
                w/ Tolerance <- 0.0005,
            DefaultSchedule(trainingVectors),
            DefaultSchedule(trainingVectors)
        );
        Message($"Training complete, found optimal parameters: {optimizedModel::Parameters}, {optimizedModel::Bias} with {nMisses} misses");
        return (optimizedModel::Parameters, optimizedModel::Bias);
    }


    // Entry point for using the model to classify the data; takes validation data and model parameters as inputs and uses hard-coded classifier structure.
    operation ClassifyLinearlySeparableModel(
        samples : Double[][],
        parameters : Double[],
        bias : Double,
        tolerance  : Double,
        nMeasurements : Int
    )
    : Int[] {
        let model = Default<SequentialModel>()
            w/ Structure <- ClassifierStructure()
            w/ Parameters <- parameters
            w/ Bias <- bias;
        let probabilities = EstimateClassificationProbabilities(
            tolerance, model,
            samples, nMeasurements
        );
        return InferredLabels(model::Bias, probabilities);
    }

}
