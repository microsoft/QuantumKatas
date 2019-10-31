using System;
using Xunit;
using Quantum.DumpUnitary;

namespace Test
{
    public class UnitTest1
    {
        [Fact]
        public void Test1()
        {
            string[] outputLines = null;
            string[] unitaryPattern = null;

            Driver.runSim(Test.Run, ref outputLines, ref unitaryPattern);

            string[] expected = System.IO.File.ReadAllLines("ExpectedUnitaryPattern.txt");
            Assert.Equal(expected, unitaryPattern);
        }
    }
}
