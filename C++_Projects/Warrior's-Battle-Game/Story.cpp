#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <stdlib.h>
#include <time.h>
#include "Story.h"
#include "Character.h"
#include "StoryBattle.h"
#include "BossBattle.h"

using namespace std;

void writeGameData (string charName, int a, int b, int c, int d, int p);
bool checkFile (string charName);

bool checkFile (string charName)
{
     string filename = "StoryData/" + charName + ".txt";
     if (ifstream(filename.c_str()))
     {
          return false;
     }
     else
     {
         return true;
     }
}

void writeGameData (string charName, int a, int b, int c, int d, int p)
{
     string filename = "StoryData/" + charName + ".txt";
     ofstream writeData;
     writeData.open(filename.c_str());
     
     writeData << a << endl
               << b << endl
               << c << endl
               << d << endl
               << p << endl;
     writeData.close();        
}

void StoryMode (int id)
{    
     system ("CLS");
     if (id == 1)
     {
          string characterName;
          bool done = false;
          
          int* heroArray;//array contain data
          
          cout << "Welcome to your new Journey!" << endl;
          system ("Pause");
          
          system ("CLS");
          cout << endl << endl << endl << endl << endl;
          cout << "AHH!!!!!The Evillord, oh no!!!!" << endl;
          system ("Pause");
          cout << endl;
          cout << "Haha!!! You can never defeat me, and the village will NEVER at peace!!" << endl;
          system ("Pause");
          cout << endl;
          cout << "Hahahahaha!!!!!" << endl;
          system ("Pause");
          cout << endl;
     
          system ("CLS");
          cout << endl << endl << endl << endl << endl;
          cout << "You must defeat the Evillord before he start destroy the village!" << endl;
          system ("Pause");
          cout << endl;
          cout << "You only have 3 days, hurry up!!!" << endl;
          system ("Pause");
          cout << endl;
     
          system ("CLS");
          cout << "What is your name warrior:";
          cin >> characterName;
          cout << endl;
          
          if (checkFile(characterName) == false)
          {
               cout << "Character name already exist, pick a new one!!!" << endl;
          }
          else 
          {
               system ("CLS");
               cout << "May the guardian be with you, " << characterName << endl; 
               system ("Pause");
          
               //get my character stats
               Mycharacterstats myChar;
               int hp, attack, defense, magic, process;
               process = 0;
               hp = myChar.getMyHp();
               attack = myChar.getMyAttack();
               defense = myChar.getMyDefense();
               magic = myChar.getMyMagic();
          
               //random number stuffs
               srand (time(NULL));
               int gameCH;
               ////////////////
          
               system ("CLS");
               bool endGame = false;
               int userCH;
          
               while (endGame != true)
               {
                    if (process >= 3)
                    {
                         int finalValue;
                         finalValue = BossFight (characterName, hp, attack, defense, magic);
                         system ("CLS");
                         if (finalValue == 2)
                         {
                              cout << endl << endl << "                    Congratulation!! You saved the village!!" << endl << endl << endl << endl << endl;
                              endGame = true;
                         }
                         else
                         {
                              cout << endl << endl << "                    Sorry!! Evillord killed you!!" << endl << endl << endl << endl << endl;
                              endGame = true;
                         }
                    }
                    else
                    {
                         system ("CLS");
                         cout << "====================================" << endl;
                         cout << "What would you like to do?" << endl;
                         cout << "1. March forward    2. Save and quit" << endl;
                         cout << "(1 or 2): ";
                         cin >> userCH;
          
                         if (userCH == 1)
                         {
                              gameCH = rand() % 6 + 1;
                    
                              if (gameCH == 6)
                              {
                                   hp = hp + 300;
                                   if (hp <= 1500)
                                   {
                                        cout << "You stopped by a hotel and rested, your health has been increased!!" << endl;
                                   }
                                   else if (hp > 1500)
                                   {
                                        hp = 1500;
                                        cout << "Even you stopped by hotal and rested, but your health already full!!" << endl;
                                   }
                                   system ("Pause");
                              }
                              else if (gameCH == 1 || gameCH == 3 || gameCH == 5)
                              {
                                   cout << "Suddenly! There is a monster of the Evillord try to stop and kill you!!" << endl;
                                   system ("Pause");
                                   heroArray = HeroVSMonsterORBoss (characterName, hp, attack, defense, magic);
          
                                   if (heroArray[0] == 0)
                                   {
                                         cout << endl << "!!!!! You died terribly !!!!!" << endl << endl;
                                         endGame = true;
                                   }
                                   else 
                                   {
                                         hp = heroArray[0];
                                         attack = heroArray[1];
                                         defense = heroArray[2];
                                         magic = heroArray[3];
                                         process = process + 1;
                                   }    
          
                                   system ("Pause");
                              }
                              else if (gameCH == 2 || gameCH == 4)
                              {
                                   cout << "It's a nice day, nothing really happened, you continue on your journey!!!" << endl;
                                   system ("Pause");
                              }
                         }
                         else if (userCH == 2)
                         {
                               //call method to save data to file
                               writeGameData (characterName, hp, attack, defense, magic, process);
                               cout << "game saved, quit now!" << endl;
                               endGame = true;
                         }
                         else
                         {
                               cout << "Please choose seriously, its about life and death!!!" << endl;
                         }
                    }
               }
          }
     }
     else
     {
         /////////////////////////////////////////////////////read file section
          string myCharName;
          int* heroArray;
          
          cout << endl << endl;
          cout << "Enter your exist character name: ";
          cin >> myCharName;
          cout << endl;
          
          int newHP, newAttack, newDefense, newMagic, newProcess;
          string filename = "StoryData/" + myCharName + ".txt";
          
          ifstream readData;
          readData.open(filename.c_str());
          
          if (readData.fail())
          {
               cout << "Fail to load story data, maybe not exist!!" << endl;
               system ("Pause");
          }
          
          cout << "Welcome back! Let's continue your journey!!" << endl;
          system ("Pause");
          //read data from file
          readData >> newHP >> newAttack >> newDefense >> newMagic >> newProcess;
          readData.close();
          //////////////////////////////////////////////////
          
          //random number stuffs
          srand (time(NULL));
          int gameCH;
          ////////////////
          
          system ("CLS");
          bool endGame = false;
          int userCH;
          
          while (endGame != true)
          {
               if (newProcess >= 3)
               {
                    int finalValue;
                    finalValue = BossFight (myCharName, newHP, newAttack, newDefense, newMagic);
                    system ("CLS");
                    if (finalValue == 2)
                    {
                         cout << endl << endl << "                    Congratulation!! You saved the village!!" << endl << endl << endl << endl << endl;
                         endGame = true;
                    }
                    else
                    {
                         cout << endl << endl << "                    Sorry!! Evillord killed you!!" << endl << endl << endl << endl << endl;
                         endGame = true;
                    }
               }
               else
               {
                    system ("CLS");
                    cout << "====================================" << endl;
                    cout << "What would you like to do?" << endl;
                    cout << "1. March forward    2. Save and quit" << endl;
                    cout << "(1 or 2): ";
                    cin >> userCH;
          
                    if (userCH == 1)
                    {
                          gameCH = rand() % 6 + 1;
                    
                          if (gameCH == 6)
                          {
                                newHP = newHP + 100;
                                if (newHP <= 1500)
                                {
                                      cout << "You stopped by a hotel and rested, your health has been increased!!" << endl;
                                }
                                else if (newHP > 1500)
                                {
                                      newHP = 1500;
                                      cout << "Even you stopped by hotal and rested, but your health already full!!" << endl;
                                }
                                system ("Pause");
                          }
                          else if (gameCH == 1 || gameCH == 3 || gameCH == 5)
                          {
                                cout << "Suddenly! There is a monster of the Evillord try to stop and kill you!!" << endl;
                                system ("Pause");
                                heroArray = HeroVSMonsterORBoss (myCharName, newHP, newAttack, newDefense, newMagic);
          
                                if (heroArray[0] == 0)
                                {
                                      cout << endl << "!!!!! You died terribly !!!!!" << endl << endl;
                                      endGame = true;
                                }
                                else 
                                {
                                      newHP = heroArray[0];
                                      newAttack = heroArray[1];
                                      newDefense = heroArray[2];
                                      newMagic = heroArray[3];
                                      newProcess = newProcess + 1;
                                }    
                                system ("Pause");
                          }
                          else if (gameCH == 2 || gameCH == 4)
                          {
                               cout << "It's a nice day, nothing really happened, you continue on your journey!!!" << endl;
                               system ("Pause");
                          }
                     }
                     else if (userCH == 2)
                     {
                          //call method to save data to file
                          writeGameData (myCharName, newHP, newAttack, newDefense, newMagic, newProcess);
                          cout << "game saved, quit now!" << endl;
                          endGame = true;
                     }
                     else
                     {
                          cout << "Please choose seriously, its about life and death!!!" << endl;
                     }
               }
          }    
     }
}
















