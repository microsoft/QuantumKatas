// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains an underlying implementation of a matrix.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.SimonsAlgorithm
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;

    public class BooleanVector : IEnumerable<bool>, IComparable<BooleanVector>, IEquatable<BooleanVector>
    {
        private readonly List<bool> values;

        public BooleanVector(int size)
        {
            values = new List<bool>(size);
        }
        
        public BooleanVector(IEnumerable<bool> array)
        {
            values = new List<bool>();
            values.AddRange(array);
        }

        public BooleanVector(IEnumerable<long> array)
            : this(array.Select(v => v != 0))
        {
        }

        public bool this[int index]
        {
            get => values[index];
            set => values[index] = value;
        }

        public static BooleanVector operator +(BooleanVector vector1, BooleanVector vector2)
        {
            if (vector1.Count != vector2.Count)
            {
                throw new ArgumentException($"Vectors have different sizes [{vector1.Count} != {vector2.Count}]");
            }

            return new BooleanVector(vector1.Zip(vector2, (val1, val2) => val1 ^ val2));
        }

        public static BooleanVector operator -(BooleanVector vector1, BooleanVector vector2)
        {
            return vector1 + vector2;
        }

        public IEnumerator<bool> GetEnumerator()
        {
            return values.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return values.GetEnumerator();
        }

        public int CompareTo(BooleanVector other)
        {
            int length = Math.Min(Count, other.Count);
            for (int i = 0; i < length; i++)
            {
                var comp = this[i].CompareTo(other[i]);
                if (comp != 0) return comp;
            }

            return Count.CompareTo(other.Count);
        }

        public int Count => values.Count;

        public bool Equals(BooleanVector other)
        {
            return CompareTo(other) == 0;
        }

        #region Overrides of Object

        public override string ToString()
        {
            return string.Join(", ", this);
        }

        #endregion
    }

    public class BooleanMatrix
    {
        private readonly List<BooleanVector> matrix = new List<BooleanVector>();

        public int Height { get; }

        public int? Width { get; }

        public BooleanMatrix(BooleanMatrix matrix)
        {
            foreach (var vector in matrix.matrix)
            {
                this.matrix.Add(new BooleanVector(vector));
            }

            Height = matrix.Height;
            Width = matrix.Width;
        }

        public BooleanMatrix(IEnumerable<BooleanVector> rows)
        {
            foreach (var row in rows)
            {
                matrix.Add(row);
                if (Width == row.Count || Width == null)
                {
                    Width = row.Count;
                }
                else
                {
                    throw new ArgumentException("Not every row has the same size");
                }
            }

            Height = matrix.Count;
        }

        public BooleanMatrix(IEnumerable<IEnumerable<long>> source)
        {
            foreach (var row in source)
            {
                matrix.Add(new BooleanVector(row.Select(x => x != 0)));
                Width = matrix.Last().Count;
            }

            Height = matrix.Count;
        }

        public BooleanMatrix(IEnumerable<IEnumerable<bool>> rows)
            : this(rows.Select(row => new BooleanVector(row)))
        {
        }

        public BooleanVector this[int index]
        {
            get => matrix[index];
            set => matrix[index] = value;
        }

        public List<BooleanVector> GetKernel()
        {
            if (Width == null)
            {
                throw new ArgumentNullException(nameof(Width));
            }

            return GetKernel(Width.Value - 1);
        }

        public List<BooleanVector> GetKernel(int minimalRank)
        {
            return GaussianElimination.GetKernel(this, minimalRank);
        }
    }
}