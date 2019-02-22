# DumpUnitary tool

This is a simple tool to help you work through the tasks in the UnitaryPatterns kata. It dumps the pattern implemented by the provided operation ("DumpUnitaryPattern.txt") and the matrix of complex numbers from which the pattern has been obtained ("DumpUnitary.txt"). The row/column ordering and the conversion of the matrix into the pattern follow the description in the kata.

**Note 1.** The columns of the matrix are obtained independently, and the relative phase between the columns is not preserved. Thus the matrix dumped might differ from the actual unitary implemented in phases of the entries (the absolute values of the amplitudes are preserved).

**Note 2.** The tool does not verify that the operation you provided is a unitary; it will process operations which use measurements, even though their results might not be unitary.