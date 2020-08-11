// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Reflection;

// Attributes for delay-signing
#if SIGNED
[assembly:AssemblyKeyFile("../../scripts/267DevDivSNKey2048.snk")]
[assembly:AssemblyDelaySign(true)]
#endif

internal static class SigningConstants
{
#if SIGNED
    public const string PUBLIC_KEY = ", PublicKey=" +
        "002400000c800000140100000602000000240000525341310008000001000100613399aff18ef1" +
        "a2c2514a273a42d9042b72321f1757102df9ebada69923e2738406c21e5b801552ab8d200a65a2" +
        "35e001ac9adc25f2d811eb09496a4c6a59d4619589c69f5baf0c4179a47311d92555cd006acc8b" +
        "5959f2bd6e10e360c34537a1d266da8085856583c85d81da7f3ec01ed9564c58d93d713cd0172c" +
        "8e23a10f0239b80c96b07736f5d8b022542a4e74251a5f432824318b3539a5a087f8e53d2f135f" +
        "9ca47f3bb2e10aff0af0849504fb7cea3ff192dc8de0edad64c68efde34c56d302ad55fd6e80f3" +
        "02d5efcdeae953658d3452561b5f36c542efdbdd9f888538d374cef106acf7d93a4445c3c73cd9" +
        "11f0571aaf3d54da12b11ddec375b3";
#else
    public const string PUBLIC_KEY = "";
#endif
}
