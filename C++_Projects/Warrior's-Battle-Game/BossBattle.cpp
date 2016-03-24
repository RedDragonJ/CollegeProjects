#include <iostream>
#include <string>
#include <stdlib.h>
#include <time.h>
#include "BossBattle.h"

using namespace std;

void displayBossUI (std::string& newName, int a, int b, int c, int d, int mg, int bossHp, int bossAttack, int bossDefense);

void displayBossUI (std::string& newName, int a, int b, int c, int d, int mg, int bossHp, int bossAttack, int bossDefense)
{
     cout << "=================================================================" << endl;
     cout << "||Hero: " << newName << "                         " << "||" << "Monster: " << "EveilLord" << endl;
     cout << "||Health: " << a << "                        " << "||" << "Health: " << bossHp << endl;
     cout << "||Attack: " << b << "                          " << "||" << "Attack: " << bossAttack << endl;
     cout << "||Defense: " << c << "                         " << "||" << "Defense: " << bossDefense << endl;
     cout << "||Magic Attack: " << d << "                         " << endl;
     cout << "||Magic Damage Rate: " << mg << "%" << endl;
     cout << "=================================================================" << endl;
}

int BossFight (std::string& heroName, int a, int b, int c, int d)
{
    //boss stuffs
    int bossHp, bossAttack, bossDefense;
    bossHp = 4000;
    bossAttack = 100;
    bossDefense = 50;
    
    int heroCH, bossCH;
    int magicRate = 0;
    bool finish = false;
    bool termSwitch = true;
    
    //random number stuffs
    srand (time(NULL));
    ////////////////
    
    ///////
    //hero first stats
    //hp: 2000
    //attack: 100
    //defense: 30
    //magic: 100
    ////////
    //boss stats
    //hp: 5000
    //attack: 100
    //defense: 50
    ////////////
    
    system ("CLS");
    cout << endl << endl << "Blessing from the Guardian!! All your stats increase!!" << endl;
    a = a + 1000;
    b = b + 50;
    c = c + 20;
    d = d + 50;
    
    system ("CLS");
     while (finish != true)
     {
           system ("CLS");
           displayBossUI (heroName, a, b, c, d, magicRate, bossHp, bossAttack, bossDefense);
           
           if (termSwitch == true)
           {
            ////////////Hero term/////////////////////////////
                 cout << endl;
                 cout << "1. Attack with sword        2. Defense with shield" << endl;
                 cout << "3. Do nothing          4. Magic Attack" << endl;
                 cout << "What would you like to do " << heroName << ": ";
                 cin >> heroCH;
                 cout << endl;
           
                 if (heroCH == 1)
                 {
                       if (bossHp >= 100)
                       {
                            cout << "***You attacked the boss***" << endl << endl;
                            bossHp = bossHp - (b - bossDefense);
                            if (bossHp == 0 || bossHp < 0)
                            {
                                 system ("CLS");
                                 displayBossUI (heroName, a, b, c, d, magicRate, bossHp, bossAttack, bossDefense);
                                 cout << endl << endl;
                                 cout << "Evillord died! You Won!!!" << endl;
                                 finish = true;
                            }
                            
                            if (magicRate != 100)
                            {
                                 magicRate = magicRate + 10;
                            }
                       }
                       else if (bossHp < 100)
                       {
                            bossHp = 0;
                            system ("CLS");
                            displayBossUI (heroName, a, b, c, d, magicRate, bossHp, bossAttack, bossDefense);
                            cout << endl << endl;
                            cout << "Evillord died! You Won!!!" << endl;
                            finish = true;
                       }
                       system ("Pause");
                 }
                 else if (heroCH == 2)
                 {
                       if (c < 50)
                       {
                             c = c + 20;
                             cout << "***You defense has been increased!!!" << endl << endl;
                       }
                       else
                       {
                             cout << "You cannot increase your defense again!!!" << endl << endl; 
                       }
                       
                       system ("Pause");
                 }
                 else if (heroCH == 3)
                 {
                       cout << "Seriously!!! You just gonna stand there and die!!!" << endl << endl;
                       system ("Pause");
                 }
                 else if (heroCH == 4)
                 {
                       if (magicRate == 100)
                       {
                            cout << "***You attacked Evillord with your magic power***" << endl << endl;
                            if (bossHp > 100)
                            {
                                 bossHp = bossHp - d;
                                 magicRate = 0;
                            }
                            else if (bossHp <= 100)
                            {
                                 bossHp = 0;
                                 system ("CLS");
                                 displayBossUI (heroName, a, b, c, d, magicRate, bossHp, bossAttack, bossDefense);
                                 cout << endl << endl;
                                 cout << "Evillord died! You Won!!!" << endl;
                                 finish = true; 
                            }
                            
                       }
                       else if (magicRate < 100)
                       {
                            cout << "Not enought power!!!" << endl;
                       }
                       system ("Pause");
                 }
                 else 
                 {
                      cout << "Please enter your correct choice!!!!!" << endl << endl;
                      system ("Pause");
                 }
                 termSwitch = false;
                 
                 if (bossDefense = 100)//reset monster defense value if defense been increased
                 {
                       bossDefense = bossDefense - 50;
                 }
            }
            else if (termSwitch == false)
            {
                 /////////////////Boss term///////////////////////
                 
                 cout << endl;
                 cout << "##### Evillord term #####" << endl; 
                 bossCH = rand() % 3 + 1;
           
                 if (bossCH == 1)
                 {
                       if (a >= 100)
                       {
                            cout << "***Evillord attacked you***" << endl << endl;
                            a = a - (bossAttack - c);
                            if (a == 0 || a < 0)
                            {
                                 system ("CLS");
                                 displayBossUI (heroName, a, b, c, d, magicRate, bossHp, bossAttack, bossDefense);
                                 cout << endl << endl;
                                 cout << "You died! Evillord Won!!!" << endl;
                                 finish = true;
                            }
                       }
                       else if (a < 100)
                       {
                            a = 0;
                            system ("CLS");
                            displayBossUI (heroName, a, b, c, d, magicRate, bossHp, bossAttack, bossDefense);
                            cout << endl << endl;
                            cout << "You died! Evillord Won!!!" << endl;
                            finish = true;
                       }
                       system ("Pause");
                 }
                 else if (bossCH == 2)
                 {
                       if (bossDefense < 100)
                       {
                             bossDefense = bossDefense + 50;
                             cout << "***Evillord defense has been increased!!!" << endl << endl;
                       }
                       else
                       {
                             cout << "Evillord cannot increase defense anymore!!!" << endl << endl; 
                       }
                       
                       system ("Pause");
                 }
                 else if (bossCH == 3)
                 {
                       cout << "Evillord just gonna stand there and ignore you!!!" << endl << endl;
                       system ("Pause");
                 }
                 termSwitch = true;
                 
                 if (c = 50)//reset hero defense value if defense been increased
                 {
                       c = c - 20;
                 }
            }
     }
     
     if (a <= 0)
     {
          return 1;
     }
     else if (bossHp <= 0)
     {
          return 2;
     }
}
