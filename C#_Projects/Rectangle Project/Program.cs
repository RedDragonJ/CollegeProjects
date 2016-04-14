using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rectangle_Project
{
    class MyRectangle
    {
        double length;
        double width;

        public void Rect(double l, double w)
        {
            length = l;
            width = w;
        }
        public double RectPerimeter()
        {
            return (2 * this.length) + (2*this.width);
        }
        public double RectArea()
        {
            return (this.length*this.width);
        }
        public void DisplayAnswers()
        {
            Console.WriteLine("Length: {0}, Width: {1}", this.length, this.width);
            Console.WriteLine("Rectangle perimeter is: {0}", this.RectPerimeter());
            Console.WriteLine("Rectangle Area is: {0}", this.RectArea());
        }
    }

    class RectangleTest
    {
        static void Main(string[] args)
        {
            double lg, wd;
            MyRectangle r = new MyRectangle();

            Console.WriteLine("Please Enter Length");
            lg = Convert.ToDouble(Console.ReadLine());
            Console.WriteLine("Please Enter Width");
            wd = Convert.ToDouble(Console.ReadLine());

            r.Rect(lg, wd);
            r.DisplayAnswers();
            Console.ReadKey();
        }
    }
}
