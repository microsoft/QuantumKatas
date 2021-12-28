// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using Xunit;
using Quantum.DumpUnitaryTest;
using Quantum.DumpUnitary;

namespace Test
{
    public class DumpUnitaryTest
    {
        [Fact]
        public void BlockDiagonalTest()
        {
            string[] unitaryPattern = null;
            string[] matrixElements = null;
            Driver.RunDumpUnitary(TestBlockDiagonalUnitary.Run, ref unitaryPattern, ref matrixElements);

            string[] expected = System.IO.File.ReadAllLines("BlockDiagonalPattern.txt");
            Assert.Equal(string.Join("\n", expected),
                string.Join("\n", unitaryPattern));
        }

        [Fact]
        public void CreeperTest()
        {
            string[] unitaryPattern = null;
            string[] matrixElements = null;
            Driver.RunDumpUnitary(TestCreeperUnitary.Run, ref unitaryPattern, ref matrixElements);

            string[] expected = System.IO.File.ReadAllLines("CreeperPattern.txt");
            Assert.Equal(string.Join("\n", expected),
                string.Join("\n", unitaryPattern));
        }
    }
}
