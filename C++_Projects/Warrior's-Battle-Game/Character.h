class Mycharacterstats
{
      private:
              int myCharHP;
              int myCharAttack;
              int myCharDefense;
              int myCharMagicAttack;
      public:
             Mycharacterstats(int = 1000, int = 50, int = 10, int = 50);
             int getMyHp();
             int getMyAttack();
             int getMyDefense();
             int getMyMagic();
};
