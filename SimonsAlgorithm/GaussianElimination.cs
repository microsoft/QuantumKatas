// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains an implementation of Gauss' Elimination algorithm.
// It's used for post-processing in Simon' algorithm.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SimonsAlgorithm
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class GaussianElimination
    {
        /// <summary>
        /// Finds all vectors v for which vM = 0, where M is an argument matrix.
        /// If rank of matrix is less then minimalRank exception is raised to protect from too big kernel.
        /// </summary>
        /// <param name="matrix">linear transformation</param>
        /// <param name="minimalRank">required minimal rank</param>
        /// <returns></returns>
        public static List<BooleanVector> GetKernel(BooleanMatrix matrix, int minimalRank)
        {
            matrix = new BooleanMatrix(matrix);

            var columnPivot = new List<int?>();
            var row = 0;

            for (var column = 0; column < matrix.Width; column++)
            {
                var foundPivot = FindPivotAndSwapRows(matrix, row, column);
                if (foundPivot)
                {
                    ReduceRows(matrix, row, column);
                    columnPivot.Add(row);
                    row++;
                }
                else
                {
                    columnPivot.Add(null);
                }
            }

            if (row < minimalRank)
                throw new InvalidOperationException("Matrix doesn't have sufficient rank");

            return FindSolution(matrix, columnPivot, 0).Select(list => new BooleanVector(Enumerable.Reverse(list))).ToList();
        }

        /// <summary>
        /// Finds first row (with index greater or equal to <paramref name="row"/>) for which value in <paramref name="column"/> is
        /// positive and swaps it with <paramref name="row"/>-th row.
        /// </summary>
        /// <param name="matrix">processed matrix</param>
        /// <param name="row">index of first row</param>
        /// <param name="column">index of column in which pivot is looked for</param>
        /// <returns></returns>
        private static bool FindPivotAndSwapRows(BooleanMatrix matrix, int row, int column)
        {
            for (var i = row; i < matrix.Height; i++)
            {
                if (!matrix[i][column]) continue;
                SwapRows(matrix, i, row);
                return true;
            }

            return false;
        }

        /// <summary>
        /// Reduce rows with index greater then <paramref name="row"/> to ensure that value in <paramref name="column"/> is equal
        /// to zero.
        /// </summary>
        /// <param name="matrix">processed matrix</param>
        /// <param name="row">index of first row</param>
        /// <param name="column">index of column to be cleared</param>
        private static void ReduceRows(BooleanMatrix matrix, int row, int column)
        {
            for (var i = row + 1; i < matrix.Height; i++)
            {
                if (matrix[i][column])
                {
                    matrix[i] -= matrix[row];
                }
            }
        }

        /// <summary>
        /// Finds partial solutions for columns with index greater or equal to <paramref name="column"/>.
        /// </summary>
        /// <param name="upperTriangleMatrix">matrix in upper triangle form to be processed</param>
        /// <param name="columnPivot">indexes of rows containing pivots for every column</param>
        /// <param name="column">index of first column in partial solution</param>
        /// <returns></returns>
        private static IEnumerable<List<bool>> FindSolution(BooleanMatrix upperTriangleMatrix, IReadOnlyList<int?> columnPivot, int column)
        {
            if (column >= upperTriangleMatrix.Width)
            {
                return new List<List<bool>>
                {
                    new List<bool>()
                };
            }

            return FindSolution(upperTriangleMatrix, columnPivot, column + 1)
                .SelectMany(solutionVector => ExtendSolutionVector(solutionVector, upperTriangleMatrix, column, columnPivot[column]))
                .ToList();
        }

        /// <summary>
        /// Extend partial solution to column with given index.
        /// </summary>
        /// <param name="solutionVector">partial solution to be extended</param>
        /// <param name="upperTriangleMatrix">matrix in upper triangle form to be processed</param>
        /// <param name="column">index of column to be extended</param>
        /// <param name="row">index of row containing pivot for column, null if there is no pivot</param>
        /// <returns></returns>
        private static IEnumerable<List<bool>> ExtendSolutionVector(
            IReadOnlyList<bool> solutionVector,
            BooleanMatrix upperTriangleMatrix,
            int column,
            int? row)
        {
            if (row.HasValue)
            {
                var sum = false;
                for (var i = 1; column + i < upperTriangleMatrix.Width; i++)
                {
                    sum ^= upperTriangleMatrix[row.Value][upperTriangleMatrix.Width.Value - i] & solutionVector[i - 1];
                }

                return new List<List<bool>>
                {
                    new List<bool>(solutionVector)
                    {
                        sum
                    }
                };
            }

            return new List<List<bool>>
            {
                new List<bool>(solutionVector)
                {
                    true
                },
                new List<bool>(solutionVector)
                {
                    false
                }
            };
        }

        /// <summary>
        /// Swaps two rows of matrix.
        /// </summary>
        /// <param name="matrix">matrix to be processed</param>
        /// <param name="firstRow">index of first row</param>
        /// <param name="secondRow">index of second row</param>
        private static void SwapRows(BooleanMatrix matrix, int firstRow, int secondRow)
        {
            var row1 = matrix[firstRow];
            var row2 = matrix[secondRow];
            matrix[secondRow] = row1;
            matrix[firstRow] = row2;
        }
    }
}