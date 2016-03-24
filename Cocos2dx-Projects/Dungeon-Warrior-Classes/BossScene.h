#ifndef __Game__BossScene__
#define __Game__BossScene__

#include "cocos2d.h"

class Boss : public cocos2d::Layer
{
private:
    cocos2d::Sprite* wall = cocos2d::Sprite::create("wall.png");
    cocos2d::Sprite* spike = cocos2d::Sprite::create("lavaspike.png");
    
    cocos2d::Sprite* leftkey = cocos2d::Sprite::create("left.png");
    cocos2d::Sprite* rightkey = cocos2d::Sprite::create("right.png");
    cocos2d::Sprite* upkey = cocos2d::Sprite::create("up.png");
    cocos2d::Sprite* downkey = cocos2d::Sprite::create("down.png");
    cocos2d::Sprite* attackkey = cocos2d::Sprite::create("attack.png");
    
    cocos2d::Sprite* hero = cocos2d::Sprite::create("hero1.png");
    cocos2d::Sprite* boss = cocos2d::Sprite::create("boss1.png");
    
    cocos2d::Sprite* fireball = cocos2d::Sprite::create("fireball.png");
    cocos2d::Sprite* death1 = cocos2d::Sprite::create("bossdeathball.png");
    
    cocos2d::Sprite* bosshp = cocos2d::Sprite::create("bosshp.png");
    cocos2d::Sprite* herohp = cocos2d::Sprite::create("herohp.png");
    
    cocos2d::Sprite* lavalight = cocos2d::Sprite::create("lavalight.png");
    cocos2d::Sprite* lava = cocos2d::Sprite::create("lava.png");
    
    cocos2d::Sprite* side1 = cocos2d::Sprite::create("siderock.png");
    cocos2d::Sprite* side2 = cocos2d::Sprite::create("siderock.png");
    
    cocos2d::Label* text1 = cocos2d::Label::createWithSystemFont("HP:            /15000", "fonts/Marker Felt.ttf", 20);
    cocos2d::Label* text2 = cocos2d::Label::createWithSystemFont("HP:            /50000", "fonts/Marker Felt.ttf", 20);
    cocos2d::Label* texthp1 = cocos2d::Label::createWithSystemFont("15000", "fonts/Marker Felt.ttf", 20);
    cocos2d::Label* texthp2 = cocos2d::Label::createWithSystemFont("50000", "fonts/Marker Felt.ttf", 20);
    
    cocos2d::Sprite* herohead = cocos2d::Sprite::create("herohead.png");
    cocos2d::Sprite* bosshead = cocos2d::Sprite::create("bosshead.png");
    
    cocos2d::Sprite* music = cocos2d::Sprite::create("Sound.png");
    cocos2d::Sprite* playpause = cocos2d::Sprite::create("playpause.png");
    
    cocos2d::Sequence* bossseq;
    
    cocos2d::RepeatForever* heroanimate;
    cocos2d::RepeatForever* bossanimate;
    
    int gametime = 351;
    bool bossattackon = true;
    bool deathballon = true;
    bool attackswitch = false;
    bool intersect = true;
    bool intersectboss = true;
    bool bosskilled = true;
    bool herokilled = true;
    bool hitwalls = true;
    
    bool bosshiton = true;
    bool wingame = true;
    bool playhit = true;
    bool playdeath = true;
    bool playdeadsound = true;
    bool playrock = true;
    
    double bosshpX = 0.25;
    double herohpX = 0.15;
    int herohealth = 15000;
    int bosshealth = 50000;
    
public:
    static cocos2d::Scene* createScene();
    
    virtual bool init();
    
    bool onTouchBegan(cocos2d::Touch* touch, cocos2d::Event* event);
    
    void heroanimation();
    
    void bossanimation();
    
    void movedeathball();
    
    void resetfireball ();
    
    void resetdeath();
    
    void update(float delta);

    void GoToEndGameScene();
    
    void GoToWinnerScene();
    
    // implement the "static create()" method manually
    CREATE_FUNC(Boss);
};

#endif /* defined(__Game__BossScene__) */
