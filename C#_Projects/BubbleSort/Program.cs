using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BubbleSort
{
    class Program
    {
        static int B_Sort()
        {
            Console.Write("\nEnter  number of Elements: ");
            int Maxamam = Convert.ToInt32(Console.ReadLine());

            int[] NumberOfArray = new int[Maxamam];

            for (int a = 0; a < Maxamam; a++)
            {
                Console.Write("\nEnter Number_" + (a + 1).ToString() + "   ");
                NumberOfArray[a] = Convert.ToInt32(Console.ReadLine());
            }



            for (int a = 1; a < Maxamam; a++)
            {
                for (int b = 0; b < Maxamam - a; b++)
                {
                    if (NumberOfArray[b] > NumberOfArray[b + 1])
                    {
                        int temp = NumberOfArray[b];
                        NumberOfArray[b] = NumberOfArray[b + 1];
                        NumberOfArray[b + 1] = temp;
                    }
                }

            }

            Console.Write("\n\n Numbers in ascending orders:\n\n");
            for (int a = 0; a < Maxamam; a++)
            {

                Console.Write("   " + NumberOfArray[a]);
                Console.Write("\n");
            }
            return 0;
        }

        static void Main(string[] args)
        {
            B_Sort();
            Console.WriteLine("press any key to get out :)");
            Console.ReadKey();

        }
    }
}