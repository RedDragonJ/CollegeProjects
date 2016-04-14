using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FunArray
{
    class Program
    {
        static void Main(string[] args)
        {
            string userString;
            double userNum;
            double[] userArr = new double[10];
            double[] systemArr = new double[10] {0, 0,5, 7, 8, 11, 15, 22.5, 3.4, 71.0};

            for (int i = 0; i < 10; i++ )
            {
                Console.Write("Enter your "+ i + "number:");
                userString = Console.ReadLine();
                Console.WriteLine();
                if (double.TryParse(userString, out userNum))
                {
                    userArr[i] = userNum;
                }
                else
                {
                    Console.WriteLine("parse double ERROR!!");
                    break;
                }
            }

            for (int i = 0; i < 10; i++ )
            {
                Console.Write(userArr[i] + systemArr[i] + " ");
            }
            Console.WriteLine();

            Console.ReadKey();
        }
    }
}
