using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SuperPosition
{
#region Hidden
    internal static class Utilities
    {
        private static string ResultToString (this Result qr) => qr == Result.Zero ? "0" : "1";

        private static string RunManyTimes<T>(this QuantumSimulator sim, Func<QuantumSimulator, Task<T>> op, int count, Func<T, string> format)
        {
            var results = 
                from i in Enumerable.Range(0, count)
                let result = op(sim).Result
                let pattern = format (result)
                group pattern by pattern into g
                select new { Ket = $"|{g.Key}>", Count = g.Count() };

            return ($"[\n\t{String.Join(",\n\t", results)}\n]");
        }

        public static string RunManyTimes(this QuantumSimulator sim, Func<QuantumSimulator, Task<Result>> op, int count)
        {
            return sim.RunManyTimes(op, count, ResultToString);
        }

        public static string RunManyTimesN(this QuantumSimulator sim, Func<QuantumSimulator, Task<QArray<Result>>> op, int count)
        {
            string ResultArrayToString (QArray<Result> result) => result.Select(ResultToString).Aggregate((r, c) => r + c);
            return sim.RunManyTimes(op, count, ResultArrayToString);
        }
    }
#endregion

    class Driver
    {
        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                var message = AllocateAndMeasureSingleQubit.Run(sim).Result;
                System.Console.WriteLine($"The result of allocating and measuring a qubit was {message}");

                message = PutInOneState.Run(sim).Result;
                System.Console.WriteLine($"The result of putting a qubit in |1> was {message}");

                message = sim.RunManyTimes(PutInPlusState.Run, 100);
                System.Console.WriteLine($"The result of putting a qubit in |+> was {message}");

                var qubitCount = 4;
                message = sim.RunManyTimesN(s => SuperPositionOverAllBasisVectors.Run(s, qubitCount), 10000);
                System.Console.WriteLine($"The result of putting {qubitCount} qubits in the GHZ state was {message}");
            }
        }
    }
}