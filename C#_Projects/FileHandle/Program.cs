using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileHandle
{
    class Program
    {
        static void Main(string[] args)
        {
            int ch = 0;
            String filePath = @"F:\Public\VS c# study\FileHandle\FileHandle\";

            while (ch != 4)
            {
                Console.WriteLine("Choose option:");
                Console.WriteLine("1. Edit file/ Create new file");
                Console.WriteLine("2. Read file");
                Console.WriteLine("3. Delete file");
                Console.WriteLine("4. Quit program");
                Console.WriteLine();

                ch = Convert.ToInt32(Console.ReadLine());
                if (ch == 1)
                {
                    String writePath, fileName1;
                    String userInputText;

                    Console.Write("Enter the file name(example.extension):");
                    fileName1 = Console.ReadLine();//read file name and extension
                    writePath = String.Concat(filePath, fileName1);//creating file path
                    if (File.Exists(writePath))
                    {
                        Console.WriteLine("Opening file...");
                        Console.Write("File is ready, type here:");
                        userInputText = Console.ReadLine();
                        using (StreamWriter sw = File.AppendText(writePath))
                        {
                            sw.WriteLine(userInputText);//write to file
                        }
                    }
                    else
                    {
                        Console.WriteLine("File not exist, creating file...");
                        Console.Write("File is ready, type here:");
                        userInputText = Console.ReadLine();
                        using (StreamWriter sw = File.CreateText(writePath))
                        {
                            sw.WriteLine(userInputText);//write to file
                        }
                    }
                    Console.ReadLine();
                }
                else if (ch == 2)
                {
                    String readPath, fileName2;
                    Console.Write("Enter the file name(example.extension):");
                    fileName2 = Console.ReadLine();//read file name and extension
                    readPath = String.Concat(filePath, fileName2);//creating file path
                    if (File.Exists(readPath))
                    {
                        Console.WriteLine("Opening file to read...");
                        Console.WriteLine();
                        using (StreamReader sr = new StreamReader(readPath))
                        {
                            String line = sr.ReadToEnd();
                            Console.WriteLine(line);
                        }
                    }
                    else
                    {
                        Console.WriteLine("Failed to read file, file may not exist or error!");
                    }
                    Console.ReadLine();
                }
                else if (ch == 3)
                {
                    String delPath, fileName3;
                    Console.Write("Enter the file name(example.extension):");
                    fileName3 = Console.ReadLine();//read file name and extension
                    delPath = String.Concat(filePath, fileName3);//creating file path
                    if (File.Exists(delPath))
                    {
                        File.Delete(delPath);
                        Console.WriteLine("File has been deleted!");
                    }
                    else
                    {
                        Console.WriteLine("Failed delete file, file not exist or error!");
                    }
                    Console.WriteLine();
                }
                else if (ch == 4)
                {
                    Console.WriteLine("Quit program!");
                    Console.WriteLine();
                }
                else
                {
                    Console.WriteLine("Please enter correct option!");
                    Console.WriteLine();
                }
                
            }
        }
    }
}
