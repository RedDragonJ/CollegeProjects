#include <iostream>
#include "Monster.h"

Monsters::Monsters(int hp, int attack, int defense)
{
     monsterHP = hp;
     monsterAttack = attack;
     monsterDefense = defense;
}

int Monsters::getmonsterHP()
{
     return monsterHP;
}

int Monsters::getmonsterAttack()
{
    return monsterAttack;
}

int Monsters::getmonsterDefense()
{
    return monsterDefense;
}
