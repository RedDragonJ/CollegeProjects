#include <iostream>
#include <string>
#include "PvP.h"

using namespace std;

void PlayerVSPlayer ()
{
     string player_1;
     string player_2;
     
     bool termSwitch = true;
     bool finish = false;
     
     int player_1HP = 1000;
     int player_2HP = 1000;
     
     int player_1Attack = 20;
     int player_2Attack = 20;
     
     int player_1Defense = 10;
     int player_2Defense = 10;
     
     int Heal = 100;
     int Axe = 30;
     int Shield = 10;
     int superAttack = 200;
     int superAttackCount_1 = 0, superAttackCount_2 = 0;
     
     int player_1CH, player_2CH;
     
     system ("CLS");
     cout << "=================================================================" << endl;
     cout << "Welcome to Player Vs. Player mode!!!" << endl;
     
     cout << "Please enter player 1 name: ";
     cin >> player_1;
     cout << endl;
     cout << "Please enter player 2 name: ";
     cin >> player_2;
     cout << endl;
     
     system ("CLS");
     while (finish != true)
     {
           system ("CLS");
           cout << "=================================================================" << endl;
           cout << "||Player 1: " << player_1 << "                     " << "||" << "Player 2: " << player_2 << endl;
           cout << "||Health: " << player_1HP << "                        " << "||" << "Health: " << player_2HP << endl;
           cout << "||Attack: " << player_1Attack << "                          " << "||" << "Attack: " << player_2Attack << endl;
           cout << "||Defense: " << player_1Defense << "                         " << "||" << "Defense: " << player_2Defense << endl;
           cout << "||Super Damage Rate: " << superAttackCount_1 << "%" << "             " << "||" << "Super Damage Rate: " << superAttackCount_2 << "%" << endl;
           cout << "||--------------------" << endl;
           cout << "||Axe damage: 30" << endl;
           cout << "||Shield rate: 20" << endl;
           cout << "||Heal amount: 100" << endl;
           cout << "||Super damage: 200" << endl;
           cout << "=================================================================" << endl;
           
           if (termSwitch == true)
           {
            ////////////player 1 term/////////////////////////////
                 cout << endl;
                 cout << "1. Attack with axe        2. Defense with shield" << endl;
                 cout << "3. Heal yourself          4. Do nothing" << endl;
                 cout << "5. Super Attack" << endl;
                 cout << "What would you like to do " << player_1 << ": ";
                 cin >> player_1CH;
                 cout << endl;
           
                 if (player_1CH == 1)
                 {
                       if (player_2Defense > 10)
                       {
                             player_2HP = player_2HP - ((player_1Attack + Axe) - player_2Defense);
                             player_2Defense = player_2Defense - Shield;
                             cout << player_1 << " has attacked " << player_2 << " while " << player_2 << " has shield on!" << endl;
                             if (player_2HP <= 0)
                             {
                                   cout << "You killed " << player_2 << endl;
                                   cout << "You won the battle!!" << endl;
                                   finish = true;
                             }
                       }
                       else
                       {
                             player_2HP = player_2HP - player_1Attack;
                             cout << player_1 << " has attacked " << player_2 << "!" << endl;
                             if (player_2HP <= 0)
                             {
                                   cout << "You killed " << player_2 << endl;
                                   cout << "You won the battle!!" << endl;
                                   finish = true;
                             }
                       }
                       if (superAttackCount_1 < 100)
                       {
                             superAttackCount_1 = superAttackCount_1 + 10;
                       }
                       else 
                       {
                             superAttackCount_1 = 100;
                       }
                       system ("Pause");
                 }
                 else if (player_1CH == 2)
                 {
                       if (player_1Defense >= 50)
                       {
                             player_1Defense = 50;
                             cout << "Max shield rate reached!!" << endl;
                       }
                       else
                       {
                             player_1Defense = player_1Defense + Shield;
                             if (player_1Defense >= 50)
                             {
                                  player_1Defense = 50;
                                  cout << "Raise defense to max!!" << endl;
                             }
                             else
                             {
                                  cout << player_1 << " defense has been increased!" << endl;
                             }
                       }
                       system ("Pause");
                 }
                 else if (player_1CH == 3)
                 {
                       if (player_1HP == 1000)
                       {
                             cout << "Your health is full!" << endl;
                       }
                       else
                       {
                             player_1HP = player_1HP + Heal;
                             if (player_1HP > 1000)
                             {
                                   player_1HP = 1000;
                             }
                             cout << "You has been healed!" << endl;
                       }
                       system ("Pause");
                 }
                 else if (player_1CH == 4)
                 {
                       cout << "You did nothing, and you gonna die fast!" << endl;
                       system ("Pause");
                 } 
                 else if (player_1CH == 5)
                 {
                      if (superAttackCount_1 == 100)
                      {
                            player_2HP = player_2HP - (superAttack - player_2Defense);
                            superAttackCount_1 = 0;
                            cout << player_1 << " hit " << player_2 << " with a super attack!!!" << endl; 
                            cout << "BOOM!!!!!" << endl;
                            cout << endl;
                            if (player_2HP <= 0)
                            {
                                  cout << "You killed " << player_2 << endl;
                                  cout << "You won the battle!!" << endl;
                                  finish = true;
                            }
                      }
                      else 
                      {
                           cout << "Super Attack Charge Not Ready Yet!!" << endl;
                      }
                      system ("Pause");
                 }
                 else 
                 {
                      cout << "You been fooled by your enemy, change term!!!" << endl;
                      system ("Pause");
                 }
                 termSwitch = false;
            }
            else if (termSwitch == false)
            {
                 /////////////////Player 2 term///////////////////////
                 cout << endl;
                 cout << "1. Attack with axe        2. Defense with shield" << endl;
                 cout << "3. Heal yourself          4. Do nothing" << endl;
                 cout << "5. Super Attack" << endl;
                 cout << "What would you like to do " << player_2 << ": ";
                 cin >> player_2CH;
                 cout << endl;
           
                 if (player_2CH == 1)
                 {
                       if (player_1Defense > 10)
                       {
                             player_1HP = player_1HP - ((player_2Attack + Axe) - player_1Defense);
                             player_1Defense = player_1Defense - Shield;
                             cout << player_2 << " has attacked " << player_1 << " while " << player_1 << " has shield on!" << endl;
                             if (player_1HP <= 0)
                             {
                                   cout << "You killed " << player_1 << endl;
                                   cout << "You won the battle!!" << endl;
                                   finish = true;
                             }
                       }
                       else
                       {
                             player_1HP = player_1HP - player_2Attack;
                             cout << player_2 << " has attacked " << player_1 << "!" << endl;
                             if (player_1HP <= 0)
                             {
                                   cout << "You killed " << player_1 << endl;
                                   cout << "You won the battle!!" << endl;
                                   finish = true;
                             }
                       }
                       
                       if (superAttackCount_2 < 100)
                       {
                             superAttackCount_2 = superAttackCount_2 + 10;
                       }
                       else 
                       {
                             superAttackCount_2 = 100;
                       }
                       system ("Pause");
                 }
                 else if (player_2CH == 2)
                 {
                       if (player_2Defense >= 50)
                       {
                             player_2Defense = 50;
                             cout << "Max Defense rate reached!!" << endl;
                       }
                       else
                       {
                             player_2Defense = player_2Defense + Shield;
                             if (player_2Defense >= 50)
                             {
                                  player_2Defense = 50;
                                  cout << "Raise defense to max!!" << endl;
                             }
                             else 
                             {
                                  cout << player_2 << " defense has been increased!" << endl;
                             }
                       }
                       system ("Pause");
                 }
                 else if (player_2CH == 3)
                 {
                       if (player_2HP == 1000)
                       {
                             cout << "Your health is full!" << endl;
                       }
                       else
                       {
                             player_2HP = player_2HP + Heal;
                             if (player_2HP > 1000)
                             {
                                   player_2HP = 1000;
                             }
                             cout << "You has been healed!" << endl;
                       }
                       system ("Pause");
                 }
                 else if (player_2CH == 4)
                 {
                       cout << "You did nothing, and you gonna die fast!" << endl;
                       system ("Pause");
                 } 
                 else if (player_2CH == 5)
                 {
                      if (superAttackCount_2 == 100)
                      {
                            player_1HP = player_1HP - (superAttack - player_1Defense);
                            superAttackCount_2 = 0;
                            cout << player_2 << " hit " << player_1 << " with a super attack!!!" << endl; 
                            cout << "BOOM!!!!!" << endl;
                            cout << endl;
                            if (player_1HP <= 0)
                            {
                                  cout << "You killed " << player_1 << endl;
                                  cout << "You won the battle!!" << endl;
                                  finish = true;
                            }
                      }
                      else 
                      {
                           cout << "Super Attack Charge Not Ready Yet!!" << endl;
                      }
                      system ("Pause");
                 }
                 else 
                 {
                      cout << "You been fooled by your enemy, change term!!!" << endl;
                      system ("Pause");
                 }
                 termSwitch = true;
            }
     }
}














