#include <iostream>
#include <string>
#include <stdlib.h>
#include <time.h>
#include "StoryBattle.h"
#include "Monster.h"
#include "Character.h"

using namespace std;

void displayUI (std::string& newName, int a, int b, int c, int d, int mg, int monsterA, int monsterB, int monsterC);

void displayUI (std::string& newName, int a, int b, int c, int d, int mg, int monsterA, int monsterB, int monsterC)
{
     cout << "=================================================================" << endl;
     cout << "||Hero: " << newName << "                         " << "||" << "Monster: " << "A wired looking creature" << endl;
     cout << "||Health: " << a << "                        " << "||" << "Health: " << monsterA << endl;
     cout << "||Attack: " << b << "                          " << "||" << "Attack: " << monsterB << endl;
     cout << "||Defense: " << c << "                         " << "||" << "Defense: " << monsterC << endl;
     cout << "||Magic Attack: " << d << "                         " << endl;
     cout << "||Magic Damage Rate: " << mg << "%" << endl;
     cout << "=================================================================" << endl;
}

int* HeroVSMonsterORBoss(std::string& charName, int a, int b, int c, int d)
{
     //first time battle value
     //////hero
     //hp: 1000
     //attack: 20
     //defense: 10
     //magic: 50
     ////////////
     /////monster
     //hp: 600
     //attack: 50
     //defense: 20
     ////////////
     
     //create monster
     Monsters newMonsters;
     int monsterHp = newMonsters.getmonsterHP();
     int monsterAttack = newMonsters.getmonsterAttack();
     int monsterDefense = newMonsters.getmonsterDefense();
     
     //random number stuffs
     srand (time(NULL));
     ////////////////
     
     int *newHeroArray = new int[4];
     bool finish = false;
     bool termSwitch = true;
     
     int heroCH, monsterCH;
     int magicRate = 0;
     
     system ("CLS");
     while (finish != true)
     {
           system ("CLS");
           displayUI (charName, a, b, c, d, magicRate, monsterHp, monsterAttack, monsterDefense);
           
           if (termSwitch == true)
           {
/////////////////////////////////////////Hero term////////////////////////////////////////////////////////
                 cout << endl;
                 cout << "1. Attack with sword        2. Defense with shield" << endl;
                 cout << "3. Do nothing          4. Magic Attack" << endl;
                 cout << "What would you like to do " << charName << ": ";
                 cin >> heroCH;
                 cout << endl;
           
                 if (heroCH == 1)
                 {
                       if (monsterHp >= 50)
                       {
                            cout << "***You attacked the monster***" << endl << endl;
                            monsterHp = monsterHp - (b - monsterDefense);
                            if (monsterHp == 0 || monsterHp < 0)
                            {
                                 system ("CLS");
                                 displayUI (charName, a, b, c, d, magicRate, monsterHp, monsterAttack, monsterDefense);
                                 cout << endl << endl;
                                 cout << "Monster died! You Won!!!" << endl;
                                 finish = true;
                            }
                            
                            if (magicRate != 100)
                            {
                                 magicRate = magicRate + 10;
                            }
                       }
                       else if (monsterHp < 50)
                       {
                            monsterHp = 0;
                            system ("CLS");
                            displayUI (charName, a, b, c, d, magicRate, monsterHp, monsterAttack, monsterDefense);
                            cout << endl << endl;
                            cout << "Monster died! You Won!!!" << endl;
                            finish = true;
                       }
                       system ("Pause");
                 }
                 else if (heroCH == 2)
                 {
                       if (c < 20)
                       {
                             c = c + 10;
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
                            cout << "***You attacked monster with your magic power***" << endl << endl;
                            if (monsterHp > 50)
                            {
                                 monsterHp = monsterHp - d;
                                 magicRate = 0;
                            }
                            else if (monsterHp <= 50)
                            {
                                 monsterHp = 0;
                                 system ("CLS");
                                 displayUI (charName, a, b, c, d, magicRate, monsterHp, monsterAttack, monsterDefense);
                                 cout << endl << endl;
                                 cout << "Monster died! You Won!!!" << endl;
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
                 
                 if (monsterDefense = 30)//reset monster defense value if defense been increased
                 {
                       monsterDefense = monsterDefense - 10;
                 }
            }
            else if (termSwitch == false)
            {
///////////////////////////////////////////////////////Monster term////////////////////////////////////////////////////////////
                 
                 cout << endl;
                 cout << "##### Monster term #####" << endl; 
                 monsterCH = rand() % 3 + 1;
           
                 if (monsterCH == 1)
                 {
                       if (a >= 50)
                       {
                            cout << "***Monster attacked you***" << endl << endl;
                            a = a - (monsterAttack - c);
                            if (a == 0 || a < 0)
                            {
                                 system ("CLS");
                                 displayUI (charName, a, b, c, d, magicRate, monsterHp, monsterAttack, monsterDefense);
                                 cout << endl << endl;
                                 cout << "You died! Monster Won!!!" << endl;
                                 finish = true;
                            }
                       }
                       else if (a < 50)
                       {
                            a = 0;
                            system ("CLS");
                            displayUI (charName, a, b, c, d, magicRate, monsterHp, monsterAttack, monsterDefense);
                            cout << endl << endl;
                            cout << "You died! Monster Won!!!" << endl;
                            finish = true;
                       }
                       system ("Pause");
                 }
                 else if (monsterCH == 2)
                 {
                       if (monsterDefense < 30)
                       {
                             monsterDefense = monsterDefense + 10;
                             cout << "***Monster defense has been increased!!!" << endl << endl;
                       }
                       else
                       {
                             cout << "Monster cannot increase defense anymore!!!" << endl << endl; 
                       }
                       
                       system ("Pause");
                 }
                 else if (monsterCH == 3)
                 {
                       cout << "Monster just gonna stand there and let you kick it's butt!!!" << endl << endl;
                       system ("Pause");
                 }
                 termSwitch = true;
                 
                 if (c = 20)//reset hero defense value if defense been increased
                 {
                       c = c - 10;
                 }
            }
     }
     
     newHeroArray[0] = a;
     newHeroArray[1] = b;
     newHeroArray[2] = c;
     newHeroArray[3] = d;
     
     return newHeroArray;
}
