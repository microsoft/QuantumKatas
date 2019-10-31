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
            string[] unitaryPattern = null;

            Driver.runTest(ref unitaryPattern);

            string[] expected = System.IO.File.ReadAllLines("ExpectedUnitaryPattern.txt");
            Assert.Equal(String.Join("\n", expected),
                String.Join("\n", unitaryPattern));
        }
    }
}
