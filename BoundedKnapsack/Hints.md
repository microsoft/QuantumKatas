```
//////////////////////////////////////////////////////////////////////
// This file contains hints to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up these hints, and ultimately
// the solutions if you get stuck.
//////////////////////////////////////////////////////////////////////
```

Hints have been provided to clarify and guide your work through some of
the more complicated tasks. The hints within each task gradually reveal
more and more of the solution. You might consider reading hints for a task
up to a point of understanding, and then try finishing the task yourself.

```
// Task 1.3. Calculate total value of selected items
```
1) The IncrementByInteger operation may be of use: https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arithmetic.incrementbyinteger.

2) How does the state of a qubit in the `selectedItems` register affect whether its corresponding value should be added into the total? How can you express this in quantum computing?


```
// Task 1.4. Compare an integer stored in a qubit array with an integer (>)
```
1) Given two classical bit strings, what would be the most straightforward way to compare them?

2) Are the more significant bits or the less significant bits more important in the comparison of two integers?

3) If we begin at the most significant bit and iterate towards the least significant bit, at what point can we conclude whether a or b is larger?

4) We can conclude which number is larger upon arriving at the highest (first encountered) bit that has different value
   in a and b. Example: If a = 10101101₂ (173) and b = 10100011₂ (163), the highest 4 bits are the same in a and b. The 5th bit from the left (4th least significant bit) is the highest bit that has different values in a and b. Since it is 1 in a and 0 in b,
   we can conclude that a > b.

5) After passing through one of a's qubits in iteration, how can we temporarily change its state to mark whether a and b had different bits in this position or the same ones? Then it can be used to determine whether
   a later, less significant bit is the first bit with different values in a and b? (Remember that you have to uncompute any changes you've done to the input register!)



```
// Task 1.5. Compare an integer stored in a qubit array with an integer (≤)
```

1) You can use bitwise logic similar to the previous task. Is it necessary to go through all these steps, though, or is there an easier way to solve this task? Remember that you can reuse the code of previous tasks.


```
// Task 2.2. Convert an array into a jagged array
```

1) For each i, xᵢ can have values from 0 to bᵢ, inclusive. How many distinct values are thus possible for xᵢ? What's the minimum number of (qu)bits required to hold these values?
2) Consider using library operations from [Microsoft.Quantum.Arrays namespace](https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arrays) instead of manipulating array elements manually.


```
// Task 2.4. Increment a quantum integer by a product of classical and quantum integers
```

1) Given two classical unsigned integers and their bit string representations, how would you calculate their product? Could you split this product into partial products?
2) Additional information on multiplication: https://en.wikipedia.org/wiki/Binary_multiplier##Unsigned_integers
3) Consider using library operations from [Microsoft.Quantum.Arithmetic namespace](https://docs.microsoft.com/en-us/qsharp/api/qsharp/microsoft.quantum.arithmetic) to simplify your implementation.



```
// Task 2.6. Calculate total value of selected items
```

1) How do the weight of an item and the selected number of copies of that item affect how much weight that item type contributes to the total?



```
// Task 3.3. Using Grover search to solve (a slightly modified) knapsack decision problem
```

1) How many total qubits are necessary for the register? You may want to revisit Hint #1 for Task 2.2.
2) If you know how to implement the quantum counting algorithm in Q#, feel free to do so. Otherwise, consider
  using the iteration method in the GraphColoring kata.



```
// Task 3.4. Solving the bounded knapsack optimization search
```
1) The key in this task is choosing an efficient method to adjust the value P over several calls to Grover's algorithm, to ultimately
  identify the maximum achievable profit value. The method should minimize the number of calls to Grover's algorithm and the total number of oracle
  oracle calls.
2) There are numerous methods of performing the task as previously described. One such method is exponential search. See
  https://en.wikipedia.org/wiki/Exponential_search for more information.
