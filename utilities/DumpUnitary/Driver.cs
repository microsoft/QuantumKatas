// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;

using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.DumpUnitary
{
    public class Driver
    {
        const double eps = 1E-5;          // the square of the absolute value of the amplitude has to be less than or equal to eps to be considered 0

        public static void RunDumpUnitary(
            Func<QuantumSimulator, Int64, System.Threading.Tasks.Task> run,
            ref string[] unitaryPattern,
            ref string[] matrixElements)
        {
            int N = 3;                  // the number of qubits on which the unitary acts
            using (var qsim = new QuantumSimulator())
            {
                run(qsim, N).Wait();
            }

            // read the content of the files and store it in a single unitary
            int size = 1 << N;
            string[,] unitary = new string[size, size];
            unitaryPattern = new string[size];
            for (int column = 0; column < size; ++column)
            {
                string fileName = $"DU_{N}_{column}.txt";
                string[] fileContent = System.IO.File.ReadAllLines(fileName);
                for (int row = 0; row < size; ++row)
                {
                    // skip the first line of the file (header)
                    string line = fileContent[row + 1];

                    // The complex number that represents the amplitude is tab-separated from the rest of the fields, 
                    // and the real and imaginary components within are separated with spaces.
                    string[] parts = line.Split('\t');
                    // drop the index and store real and imaginary parts
                    string amplitude = parts[1];
                    string[] amplitudeParts = amplitude.Split(' ', StringSplitOptions.RemoveEmptyEntries);
                    string real = amplitudeParts[0];
                    string imag = amplitudeParts[2];

                    // write the number to the matrix as a string "(real, complex)"
                    unitary[row, column] = $"({real}, {imag})";
                    // for a pattern, convert real and complex parts into doubles and add them up
                    double amplitudeSquare = Math.Pow(double.Parse(real), 2) + Math.Pow(double.Parse(imag), 2);
                    unitaryPattern[row] += (amplitudeSquare > eps) ? 'X' : '.';
                }
                // clean up the file with individual amplitudes
                System.IO.File.Delete(fileName);
            }

            // Concatenate the elements of the unitary into a matrix representation
            matrixElements = new string[size];
            for (int row = 0; row < size; ++row)
            {
                matrixElements[row] = unitary[row, 0];
                for (int col = 1; col < size; ++col)
                {
                    matrixElements[row] += "\t" + unitary[row, col];
                }
            }
        }
        static void Main(string[] args)
        {
            string[] matrixElements = null;
            string[] unitaryPattern = null;
            RunDumpUnitary(CallDumpUnitary.Run, ref unitaryPattern, ref matrixElements);
            System.IO.File.WriteAllLines("DumpUnitary.txt", matrixElements);
            System.IO.File.WriteAllLines("DumpUnitaryPattern.txt", unitaryPattern);
        }

        public static void RunTest(ref string[] unitaryPattern)
        {
            string[] matrixElements = null;
            RunDumpUnitary(Test.Run, ref unitaryPattern, ref matrixElements);
        }
    }
}