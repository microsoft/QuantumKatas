namespace SuperPosition
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;

    operation AllocateAndMeasureSingleQubit () : String
    {
        body
        {
            mutable result = "";

            using (qs = Qubit[1])
            {
                let q = qs[0];
                let m = M (q);

                if (m == Zero)
                {
                    set result = "Zero";
                }
                else
                {
                    set result = "One";
                }
            }

            return result;
        } 
    }

    operation PutInOneState () : String
    {
        body
        {
            mutable result = "";

            using (qs = Qubit[1])
            {
                let q = qs[0];

                AssertQubit(Zero, q);

                X(q);

                let m = M (q);

                if (m == Zero)
                {
                    set result = "Zero";
                }
                else
                {
                    set result = "One";
                }

                Reset (q);
            }

            return result;
        } 
    }

    operation PutInPlusState () : Result
    {
        body
        {
            mutable result = Zero;

            using (qs = Qubit[1])
            {
                let q = qs[0];

                AssertQubit(Zero, q);

                H (q);

                set result = M (q);

                Reset (q);
            }

            return result;
        }
    }

    operation SuperPositionOverAllBasisVectors (numberOfQubits : Int) : Result[]
    {
        body
        {
            mutable result = new Result[numberOfQubits];

            using (qs = Qubit[numberOfQubits])
            {
                for (i in 0..(numberOfQubits - 1))
                {
                    H (qs[i]);
                }

                for (i in 0..(numberOfQubits - 1))
                {
                    set result[i] = M (qs[i]);
                }

                ResetAll (qs);
            }

            return result;
        } 
    }    
}