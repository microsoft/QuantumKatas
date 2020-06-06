namespace SuperPosition.Reference
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;

    operation AllocateAndMeasureSingleQubit () : String
    {
        body
        {
            mutable msg = "";

            using (qs = Qubit[1])
            {
                let q = qs[0];

                let result = M (q);

                if (result == Zero) 
                {
                    set msg = "Zero";
                }
                else
                {
                    set msg = "One";
                }                
            }

            return msg;
        }
    }

    operation MeasureToString (q : Qubit) : String
    {
        body
        {
            mutable msg = "";

            if (M (q) == Zero) 
            {
                set msg = "Zero";
            }
            else
            {
                set msg = "One";
            }

            return msg;
        }
    }

    operation PutInOneState () : String
    {
        body
        {
            mutable msg = "";

            using (qs = Qubit[1])
            {
                let q = qs[0];

                AssertQubit(Zero, q);

                X (q);

                set msg = MeasureToString (q);

                Reset (q);
            }

            return msg;
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