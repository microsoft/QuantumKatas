// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System;
using Xunit;
using Quantum.DumpUnitary;

namespace Test
{
    public class DumpUnitaryTest
    {
        [Fact]
        public void BlockDiagonalTest()
        {
            string[] unitaryPattern = null;

            Driver.RunTest(ref unitaryPattern);

            string[] expected = System.IO.File.ReadAllLines("BlockDiagonalPattern.txt");
            Assert.Equal(String.Join("\n", expected),
                String.Join("\n", unitaryPattern));
        }
    }
}
