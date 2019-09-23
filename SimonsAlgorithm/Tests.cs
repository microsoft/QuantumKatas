// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains parts of the testing harness. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Q22
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;

    using Microsoft.Quantum.Simulation.Core;

    using Quantum.Kata.SimonsAlgorithm;

    using Newtonsoft.Json;

    using Xunit;
    using Xunit.Abstractions;

    public class Simons_Algorithm
    {
        public class Instance : IXunitSerializable
        {
            public List<List<long>> transformation { get; set; }

            public List<long> kernel { get; set; }

            public int instance { get; set; }

            public Instance()
            {
            }

            public Instance(List<List<long>> transformation, List<long> kernel, int instance)
            {
                this.transformation = transformation;
                this.kernel = kernel;
                this.instance = instance;
            }

            public BooleanVector Kernel => new BooleanVector(kernel);

            public IQArray<IQArray<long>> Transformation => new QArray<IQArray<long>>(
                transformation.Select(
                    vector => new QArray<long>(vector)));

            public IQArray<IQArray<long>> ExtendedTransformation
            {
                get
                {
                    var array = (IQArray<IQArray<long>>)new QArray<IQArray<long>>(
                        transformation.Select(vector => new QArray<long>(vector))
                    );
                    array = QArray<IQArray<long>>.Add (array, new QArray<IQArray<long>>(new QArray<long>(transformation.Last())));
                    return array;
                }
            }

            public void Deserialize(IXunitSerializationInfo info)
            {
                kernel = JsonConvert.DeserializeObject<List<long>>(info.GetValue<string>("kernel"));
                transformation = JsonConvert.DeserializeObject<List<List<long>>>(info.GetValue<string>("transformation"));
            }

            public void Serialize(IXunitSerializationInfo info)
            {
                info.AddValue("kernel", JsonConvert.SerializeObject(kernel), typeof(string));
                info.AddValue("transformation", JsonConvert.SerializeObject(transformation), typeof(string));
            }
            
            public override string ToString()
            {
                return instance.ToString("D2");
            }
        }

        private readonly ITestOutputHelper output;

        public Simons_Algorithm(ITestOutputHelper output)
        {
            this.output = output;
        }

        public static IEnumerable<object[]> GetInstances()
        {
            var assembly = System.Reflection.Assembly.GetExecutingAssembly();
            string resourceName = @"Quantum.Kata.SimonsAlgorithm.Instances.json";
            using (var stream = assembly.GetManifestResourceStream(resourceName)) {
                if (stream == null) {
                    var res = String.Join(", ", assembly.GetManifestResourceNames());
                    throw new Exception($"Resource {resourceName} not found in {assembly.FullName}. Valid resources are: {res}.");
                }
                using (var reader = new StreamReader(stream)) {
                    foreach (var instance in JsonSerializer.Create().Deserialize<List<Instance>>(new JsonTextReader(reader)))
                    {
                        yield return new object[] { instance };
                    }
                }
            }
        }

        [Theory]
        [MemberData(nameof(GetInstances))]
        public void Test(Instance instance)
        {
            var sim = new OracleCounterSimulator();
            
            var len = instance.Kernel.Count;
            var saver = new List<IQArray<long>>();

            for (int i = 0; i < len * 4; ++i)
            {
                var (vector, uf) = cs_helper.Run(sim, len, instance.ExtendedTransformation).Result;
                Assert.Equal(1, sim.GetOperationCount(uf));
                saver.Add(vector);
            }

            var matrix = new BooleanMatrix(saver);
            var kernel = matrix.GetKernel();

            Assert.Equal(instance.Kernel.Contains(true) ? 2 : 1, kernel.Count);
            Assert.Contains(instance.Kernel, kernel);
        }
    }
}