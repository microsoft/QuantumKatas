using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;

namespace Quantum.Kata.MagicSquareGame {
    class PlayGame {
        static void Main(string[] args) {
                var (choice, row, col) = GetInputs();

                if (row > 2 || col > 2 || row < 0 || col < 0) {
                    Console.WriteLine("Invalid indices.");
                    return;
                }

                switch (choice) {
                case "q":
                    PlayQuantum(row, col);
                    break;
                case "c":
                    PlayClassical(row, col);
                    break;
                case "r":
                    PlayRandom(row, col);
                    break;
                default:
                    Console.WriteLine("Invalid choice.");
                    break;
                }
        }

        static (string, int, int) GetInputs() {
            string choice;
            string[] tokens;
            int row, col;

            Console.WriteLine("Welcome the the Mirman Magic Square game.");
            Console.Write("Which strategy would you like to try? " +
            "(q)uantum optimal, (c)lassical optimal, classical (r)andom): ");
            choice = Console.ReadLine();

            Console.Write("From a 3x3 grid, choose a 0-indexed " +
            "row and column for Alice and Bob to be assigned. ");
            tokens = Console.ReadLine().Split();
            row = int.Parse(tokens[0]);
            col = int.Parse(tokens[1]);

            return (choice, row, col);
        }
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

        static void PlayQuantum(int row, int col) {
            using (var qsim = new QuantumSimulator()) {
                var (aliceQ, bobQ) = gameRunnerQuantum.Run(qsim, row, col).Result;
                var (alice, bob) = ConvertArrays(aliceQ.ToArray(), bobQ.ToArray());

                DrawGrid(row, alice, col, bob);
            }
        }

        static void PlayClassical(int row, int col) {
            using (var qsim = new QuantumSimulator()) {
                var (aliceQ, bobQ) = gameRunnerClassicalOptimal.Run(qsim, row, col).Result;
                var (alice, bob) = ConvertArrays(aliceQ.ToArray(), bobQ.ToArray());

                DrawGrid(row, alice, col, bob);
            }
        }

        static void PlayRandom(int row, int col) {
            using (var qsim = new QuantumSimulator()) {
                var (aliceQ, bobQ) = gameRunnerClassicalRandom.Run(qsim, row, col).Result;
                var (alice, bob) = ConvertArrays(aliceQ.ToArray(), bobQ.ToArray());

                DrawGrid(row, alice, col, bob);
            }
        }
    }
}