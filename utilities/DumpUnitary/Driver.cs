// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;

using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.DumpUnitary
{
    class Driver
    {
        static void Main(string[] args)
        {
            double eps = 1E-5;          // the square of the absolute value of the amplitude has to be less than or equal to eps^2 to be considered 0

            int N = 3;                  // the number of qubits on which the unitary acts
            using (var qsim = new QuantumSimulator())
            {
                CallDumpUnitary.Run(qsim, N).Wait();
            }

            // read the content of the files and store it in a single unitary
            int size = 1 << N;
            string[,] unitary = new string[size, size];
            string[] unitaryPattern = new string[size];
            for (int column = 0; column < size; ++column) {
                string fileName = $"DU_{N}_{column}.txt";
                string[] fileContent = System.IO.File.ReadAllLines(fileName);
                for (int row = 0; row < size; ++row) {
                    // skip the first line of the file (header)
                    string line = fileContent[row + 1];
                    // split the line into 3 space-separated elements: index, real part and complex part
                    string[] parts = line.Split('\t');
                    // drop the index and store real and complex parts
                    string real = parts[1];
                    string complex = parts[2];
                    // write the number to the matrix as a string "(real, complex)"
                    unitary[column, row] = $"({real}, {complex})";
                    // for a pattern, convert real and complex parts into doubles and add them up
                    double amplitudeSquare = Math.Pow(double.Parse(real), 2) + Math.Pow(double.Parse(complex), 2);
                    unitaryPattern[row] += (amplitudeSquare > eps * eps) ? 'X' : '.';
                }
                // clean up the file with individual amplitudes
                System.IO.File.Delete(fileName);
            }

            // print the combined unitary to a file
            string[] outputLines = new string[size];
            for (int row = 0; row < size; ++row) {
                outputLines[row] = unitary[row, 0];
                for (int col = 1; col < size; ++col) {
                    outputLines[row] += "\t" + unitary[row, col];
                }
            }
            System.IO.File.WriteAllLines("DumpUnitary.txt", outputLines);

            System.IO.File.WriteAllLines("DumpUnitaryPattern.txt", unitaryPattern);
        }
    }
}