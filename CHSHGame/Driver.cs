// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Quantum.Kata.CHSHGame
{
    using System;
    using Microsoft.Quantum.Simulation.Simulators;

    /// <summary>
    /// The classical driver for the quantum computation.
    /// </summary>
    public class Driver
    {
        /// <summary>
        /// Main entry point to the program.
        /// </summary>
        /// <param name="args">Command-line parameters.</param>
        static void Main(string[] args)
        {
            for (int rotationFactor = 0; rotationFactor < 8; rotationFactor++)
            {
                System.Console.WriteLine($"Rotation factor: {rotationFactor}");
                Play(rotationFactor);
            }
        }

        static void Play(int rotationFactor)
        {
            const int trialCount = 10000;
            Random generator = new Random();
            using (QuantumSimulator sim = new QuantumSimulator())
            {
                int classicalWinCount = 0;
                int quantumWinCount = 0;
                for (int i = 0; i < trialCount; i++)
                {
                    bool aliceBit = GetRandomBit(generator);
                    bool bobBit = GetRandomBit(generator);
                    bool aliceMeasuresFirst = GetRandomBit(generator);
                    bool classicalXor =
                        PlayClassicalStrategy(aliceBit, bobBit);
                    bool quantumXor =
                        PlaySuboptimalQuantumStrategy_Reference.Run(
                            sim,
                            aliceBit,
                            bobBit,
                            aliceMeasuresFirst,
                            rotationFactor).Result;

                    if ((aliceBit && bobBit) == classicalXor)
                    {
                        classicalWinCount++;
                    }

                    if ((aliceBit && bobBit) == quantumXor)
                    {
                        quantumWinCount++;
                    }
                }

                Console.WriteLine(
                    "Classical success rate: "
                    + classicalWinCount / (float)trialCount);
                Console.WriteLine(
                    "Quantum success rate: "
                    + quantumWinCount / (float)trialCount);

                if (quantumWinCount > classicalWinCount)
                {
                    Console.WriteLine("The quantum success rate exceeded the classical success rate!");
                }
            }
        }

        /// <summary>
        /// Generates a single random bit.
        /// </summary>
        /// <param name="generator">An initialized RNG.</param>
        /// <returns>A single random bit, as a bool.</returns>
        private static bool GetRandomBit(Random generator)
        {
            int next = generator.Next();
            return (next & 1) == 1;
        }

        /// <summary>
        /// Plays the optimal classical strategy for the CHSH game:
        /// both Alice and Bob both always output 0. This should result
        /// in success 75% of the time.
        /// </summary>
        /// <param name="aliceBit">The bit given to Alice (X).</param>
        /// <param name="bobBit">The bit given to Bob (Y).</param>
        /// <returns>Whether Alice and Bob's output bits match.</returns>
        private static bool PlayClassicalStrategy(bool aliceBit, bool bobBit)
        {
            bool aliceOutput = false;
            bool bobOutput = false;
            return aliceOutput != bobOutput;
        }
    }
}
