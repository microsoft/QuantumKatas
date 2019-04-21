using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;

namespace Quantum.Kata.MagicSquareGame {
    class PlayGame {
        static void Main(string[] args) {}

        static (int[], int[]) ConvertArrays(long[] aliceL, long[] bobL) {
            var alice = new int[3];
            var bob = new int[3];

            for (int i = 0; i < 3; i++) {
                alice[i] = (int)aliceL[i];
                bob[i] = (int)bobL[i];
            }
            return (alice, bob);
        }

        static void DrawGrid(int row, int[] alice, int col, int[] bob) {
            string[,] grid = new string[3,3];

            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    grid[i,j] = " ";
                }
            }
            for (int i = 0; i < 3; i++) {
                grid[row,i] = alice[i] == 1 ? "+" : "-";
                grid[i,col] = bob[i] == 1 ? "+" : "-";
            }
            if (alice[col] != bob[row]) {
                grid[row,col] = "±";
            }

            for (int i = 0; i < 7; i++) {
                if (i % 2 == 0) {
                    Console.WriteLine("-------");
                } else {
                    Console.WriteLine("|{0}|{1}|{2}|", grid[i/2,0],
                    grid[i/2,1], grid[i/2,2]);
                }
            }
        }
    }
}