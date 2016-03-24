#include <cstdlib>
#include <iostream>
#include "AboutGame.h"
#include "PvP.h"
#include "Story.h"

using namespace std;

int checkingInputVal (double newVal)
{
     if (newVal == 1)
     {
        return 1;
     }
     else if (newVal == 2)
     {
        return 2;
     }
     else if (newVal == 3)
     {
        return 3;
     }
     else if (newVal == 4)
     {
        return 4;
     }
     else if (newVal == 5)
     {
        return 5;
     }
     else 
     {
        return 0;
     }
}

int main()
{
    system ("Title Warrior's Game");
    system ("mode 120, 40");
    system ("COLOR 7C");
    
    double userChoice = 0;
    int checkResult;
    
    while (userChoice != 5)
    {
          //system command
          system ("CLS");
          
          //program options 25 blank spaces
          cout << endl << endl;
          cout << "                                                      WARRIOR'S BATTLE" << endl;
          cout << endl << endl;
          cout << "                                                      1. New Story" << endl;
          cout << "                                                      2. Continue Story" << endl;
          cout << "                                                      3. Player vs. Player" << endl;
          cout << "                                                      4. About Game " << endl;
          cout << "                                                      5. Quit Game " << endl;
          
          //user enter option
          cout << endl << "Enter your choice (1..5): ";
          cin >> userChoice;
          cout << endl;
          //check input value
          checkResult = checkingInputVal (userChoice);
          if (checkResult == 0)
          {
              cout << "Please enter correctly!!" << endl;
              cout << endl;
              system ("Pause");
          }
          else if (checkResult == 1)
          {
               StoryMode (1);
               system ("Pause");
          }
          else if (checkResult == 2)
          {
               StoryMode (2);
               system ("Pause");
          }
          else if (checkResult == 3)
          {
               PlayerVSPlayer ();
               system ("Pause");
          }
          else if (checkResult == 4)
          {
               readFiles ();
               system ("Pause");
          }    
    }                                                              
    
    
    cout << "Leaving system....." << endl;
    system ("Pause");
}
