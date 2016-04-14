using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace simpleATMproject
{
    class BankAccount
    {
        int pinNum;
        double accBalance;

        public void MyAccount()
        {
            this.pinNum = 1234;
            this.accBalance = 1000;
        }
        public int MyPin()
        {
            return this.pinNum;
        }
        public double MyBalance()
        {
            return this.accBalance;
        }
        public void Deposit(double d)
        {
            this.accBalance = this.accBalance + d;
        }
        public void Withdraw(double w)
        {
            this.accBalance = this.accBalance - w;
        }
    }
}
