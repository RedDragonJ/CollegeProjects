#include <iostream>
#include "Character.h"

Mycharacterstats::Mycharacterstats(int hp, int attack, int defense, int magic)
{
     myCharHP = hp;
     myCharAttack = attack;
     myCharDefense = defense;
     myCharMagicAttack = magic;
}

int Mycharacterstats::getMyHp()
{
     return myCharHP;
}

int Mycharacterstats::getMyAttack()
{
    return myCharAttack;
}

int Mycharacterstats::getMyDefense()
{
    return myCharDefense;
}

int Mycharacterstats::getMyMagic()
{
    return myCharMagicAttack;
}



