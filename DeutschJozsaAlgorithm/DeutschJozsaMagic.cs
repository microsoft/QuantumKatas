using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Quantum.IQSharp;
using Microsoft.Quantum.Katas;
using Microsoft.Quantum.Simulation.Common;

namespace Quantum.Kata.DeutschJozsaAlgorithm
{
    public class DeutschJozsaMagic : KataMagic
    {
        public DeutschJozsaMagic(IOperationResolver resolver, ISnippets snippets) : base(resolver, snippets)
        {
        }

        public override SimulatorBase CreateSimulator() => new OracleCounterSimulator();
    }
}
