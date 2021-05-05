using System;
using Microsoft.Quantum.QsCompiler.SyntaxTree;
using Microsoft.Quantum.QsCompiler.SyntaxTokens;

namespace Microsoft.Quantum.Katas
{
    internal static class Extensions
    {
        internal static bool TryAsStringLiteral(this TypedExpression expression, out string? value)
        {
            if (expression.Expression is QsExpressionKind<TypedExpression, Identifier, ResolvedType>.StringLiteral literal)
            {
                value = literal.Item1;
                return true;
            }
            else
            {
                value = null;
                return false;
            }
        }
    }
    
}