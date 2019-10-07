// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using Microsoft.Jupyter.Core;

namespace Microsoft.Quantum.Katas
{
    /// <summary>
    /// This is a Jupyter Core IChannel that wraps an existing IChannel and 
    /// adds NewLine symbols (\\n)
    /// to every message that gets logged to Stdout and Stderror.
    /// </summary>
    public class ChannelWithNewLines : IChannel
    {
        public IChannel BaseChannel { get; }

        public ChannelWithNewLines(IChannel original)
        {
            BaseChannel = original;
        }

        public static string Format(string msg) => $"{msg}\n";

        public void Stdout(string message) => BaseChannel?.Stdout(Format(message));

        public void Stderr(string message) => BaseChannel?.Stderr(Format(message));

        public void Display(object displayable) => BaseChannel?.Display(displayable);
    }

    public static partial class Extensions
    {
        /// <summary>
        /// Creates a wrapper of an IChannel that adds new lines to every message
        /// sent to stdout and stderr
        /// </summary>
        public static ChannelWithNewLines WithNewLines(this IChannel original) =>
            (original is ChannelWithNewLines ch) ? ch : new ChannelWithNewLines(original);
    }
}
