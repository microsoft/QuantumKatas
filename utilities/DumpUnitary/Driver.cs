// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using System;
using Microsoft.Quantum.Diagnostics.Emulation;
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
            int size = 1 << N;
            Array data = Array.CreateInstance(typeof(double), size, size, 2);

            using (var qsim = new QuantumSimulator())
            {
                // Extract information produced by DumpOperation call.
                qsim.OnDisplayableDiagnostic += (diagnostic) =>
                {
                    if (diagnostic is DisplayableUnitaryOperator op)
                    {
                        var displayable = (DisplayableUnitaryOperator)diagnostic;
                        // Copy the data into a multidimensional array.
                        data = displayable.Data.ToMuliDimArray<double>();
                    }
                };

                run(qsim, N).Wait();
            }

            // Convert the matrix elements to the string representation and the pattern.
            string[,] unitary = new string[size, size];
            unitaryPattern = new string[size];

            for (int column = 0; column < size; ++column)
            {
                for (int row = 0; row < size; ++row)
                {
                    double realD = (double)data.GetValue(row, column, 0);
                    double imagD = (double)data.GetValue(row, column, 1);
                    unitary[row, column] = $"({realD}, {imagD})";

                    double amplitudeSquare = Math.Pow(realD, 2) + Math.Pow(imagD, 2);
                    unitaryPattern[row] += (amplitudeSquare > eps) ? 'X' : '.';
                }
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

            Console.WriteLine("Unitary pattern:");
            foreach (var row in unitaryPattern) 
            {
                Console.WriteLine(row);
            }
        }
    }
}
