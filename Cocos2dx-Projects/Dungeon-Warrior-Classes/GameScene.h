#ifndef __GameScene__
#define __GameScene__

#include "cocos2d.h"
#include "InfiniteParallaxNode.h"

class GameScene : public cocos2d::Layer
{
private:
    cocos2d::Sprite* wall = cocos2d::Sprite::create("wall.png");
    cocos2d::Sprite* wall2 = cocos2d::Sprite::create("wall.png");
    cocos2d::Sprite* block2 = cocos2d::Sprite::create("block.png");
    cocos2d::Sprite* spike = cocos2d::Sprite::create("spikes.png");
    cocos2d::Sprite* spike2 = cocos2d::Sprite::create("spikes.png");
    cocos2d::Sprite* floor = cocos2d::Sprite::create("floor.png");
    cocos2d::Sprite* floor2 = cocos2d::Sprite::create("floor.png");
    cocos2d::Sprite* rock = cocos2d::Sprite::create("rocks.png");
    cocos2d::Sprite* rock2 = cocos2d::Sprite::create("rocks.png");
    
    cocos2d::Sprite* jump = cocos2d::Sprite::create("jump.png");
    cocos2d::Sprite* music = cocos2d::Sprite::create("Sound.png");
    cocos2d::Sprite* playpause = cocos2d::Sprite::create("playpause.png");
    cocos2d::Sprite* hp = cocos2d::Sprite::create("health.png");
    cocos2d::Sprite* hp1 = cocos2d::Sprite::create("health.png");
    cocos2d::Sprite* hp2 = cocos2d::Sprite::create("health.png");
    
    cocos2d::Sprite* hero = cocos2d::Sprite::create("hero1.png");
    cocos2d::Sprite* walker = cocos2d::Sprite::create("walker1.png");
    cocos2d::Sprite* walker1 = cocos2d::Sprite::create("walker1.png");
    cocos2d::Sprite* walker2 = cocos2d::Sprite::create("walker1.png");
    cocos2d::Sprite* flyer = cocos2d::Sprite::create("flyer1.png");
    cocos2d::Sprite* flyer1 = cocos2d::Sprite::create("flyer1.png");
    cocos2d::Sprite* flyer2 = cocos2d::Sprite::create("flyer1.png");
    
    cocos2d::Sprite* wonsign = cocos2d::Sprite::create("won.png");
    
    cocos2d::Sprite* blocktop1 = cocos2d::Sprite::create("block.png");
    cocos2d::Sprite* blocktop2 = cocos2d::Sprite::create("block.png");

    cocos2d::MoveTo* walkermoveleft;
    cocos2d::MoveTo* walkermoveleft1;
    cocos2d::MoveTo* walkermoveleft2;
    cocos2d::MoveTo* flyermoveleft;
    cocos2d::MoveTo* flyermoveleft1;
    cocos2d::MoveTo* flyermoveleft2;
    
    cocos2d::RepeatForever* heroanimate;
    cocos2d::RepeatForever* walkeranimate;
    cocos2d::RepeatForever* walkeranimate1;
    cocos2d::RepeatForever* walkeranimate2;
    cocos2d::RepeatForever* flyeranimate;
    cocos2d::RepeatForever* flyeranimate1;
    cocos2d::RepeatForever* flyeranimate2;
    
    cocos2d::PhysicsBody* herobody;
    cocos2d::PhysicsBody* blocktopbody1;
    cocos2d::PhysicsBody* blocktopbody2;
    cocos2d::PhysicsBody* blockbody2;
    cocos2d::PhysicsBody* walkerbody;
    cocos2d::PhysicsBody* walkerbody1;
    cocos2d::PhysicsBody* walkerbody2;
    cocos2d::PhysicsBody* flyerbody;
    cocos2d::PhysicsBody* flyerbody1;
    cocos2d::PhysicsBody* flyerbody2;
    
    InfiniteParallaxNode* walls;
    InfiniteParallaxNode* ceiling;
    InfiniteParallaxNode* ground;
    InfiniteParallaxNode* gamerock;
    
    int lifecount = 3;
    
    int gametime = 10;
    
    bool endgameon = true;
    bool herodeadon = true;
    bool herohiton = true;
    
public:
    // there's no 'id' in cpp, so we recommend returning the class instance pointer
    static cocos2d::Scene* createScene();
    
    cocos2d::PhysicsWorld* sceneWorld;
    void setPhysicsWorld( cocos2d::PhysicsWorld* world)
    { this->sceneWorld = world; };
    
    // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
    virtual bool init();
    
    bool onTouchBegan(cocos2d::Touch* touch, cocos2d::Event* event);
    
    bool physcisOnContactBegin(const cocos2d::PhysicsContact &contact);
    
    void initPhysicsSprites();
    
    void runninganimation();
    
    void walkmonsters();
    
    void flymonsters();
    
    void update(float newdelta);
    
    void GoToEndGameScene();
    
    void GoToBossScene();
    
    // implement the "static create()" method manually
    CREATE_FUNC(GameScene);
};


#endif /* defined(__Game__GameScene__) */
