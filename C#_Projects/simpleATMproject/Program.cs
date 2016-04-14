using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace simpleATMproject
{
    class Program
    {
        static void Main(string[] args)
        {
            int myPinNum, ch = 0;
            double dAmount, wAmount;
            bool isFinished = false;

            do
            {
                BankAccount ba = new BankAccount();
                ba.MyAccount();
                Console.WriteLine();
                Console.WriteLine("Welcome to ATM");
                Console.WriteLine("==============");

                Console.Write("Enter your PIN number: ");
                myPinNum = Convert.ToInt32(Console.ReadLine());
                Console.WriteLine();
                if (myPinNum == ba.MyPin())
                {
                    while (ch != 4)
                    {
                        Console.WriteLine();
                        Console.WriteLine("     What would you like to do?");
                        Console.WriteLine("     1. Deposit");
                        Console.WriteLine("     2. Withdraw");
                        Console.WriteLine("     3. Inquiry");
                        Console.WriteLine("     4. Quit");
                        Console.Write("     Enter your option: ");

                        ch = Convert.ToInt32(Console.ReadLine());
                        if (ch == 1)
                        {
                            Console.WriteLine("     ----------");
                            Console.Write("     Enter the amount: ");
                            dAmount = Convert.ToDouble(Console.ReadLine());
                            Console.WriteLine();
                            ba.Deposit(dAmount);
                            Console.WriteLine("     Deposit was successful!");
                        }
                        else if (ch == 2)
                        {
                            Console.WriteLine("     ----------");
                            Console.Write("     Enter the amount: ");
                            wAmount = Convert.ToDouble(Console.ReadLine());
                            Console.WriteLine();

                            if (wAmount > ba.MyBalance())
                            {
                                Console.WriteLine("     insufficient balance!");
                            }
                            else
                            {
                                ba.Withdraw(wAmount);
                                Console.WriteLine("     Withdraw was successful!");
                            }
                        }
                        else if (ch == 3)
                        {
                            Console.WriteLine("     ----------");
                            Console.WriteLine("     You account balance is {0}", ba.MyBalance());
                        }
                        else if (ch == 4)
                        {
                            isFinished = true;
                            Console.WriteLine("     Log out now!");
                            Console.ReadKey();
                        }
                        else
                        {
                            Console.WriteLine("     Please enter correctly!");
                        }
                    }
                }
                else
                {
                    Console.WriteLine("Sorry, wrong PIN number, enter again!");
                }
            } while (isFinished != true);
            Console.WriteLine();
            Console.WriteLine("Goodbye, have a good day!");
            Console.ReadKey();
        }
    }
}
