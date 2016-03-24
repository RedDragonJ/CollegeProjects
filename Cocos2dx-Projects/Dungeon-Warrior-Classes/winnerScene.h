#ifndef __Game__winnerScene__
#define __Game__winnerScene__

#include "cocos2d.h"
#include "InfiniteParallaxNode.h"

class winner : public cocos2d::Layer
{
private:
    cocos2d::Sprite* wall = cocos2d::Sprite::create("wall.png");
    cocos2d::Sprite* wall2 = cocos2d::Sprite::create("wall.png");
    cocos2d::Sprite* spike = cocos2d::Sprite::create("spikes.png");
    cocos2d::Sprite* spike2 = cocos2d::Sprite::create("spikes.png");
    cocos2d::Sprite* floor = cocos2d::Sprite::create("floor.png");
    cocos2d::Sprite* floor2 = cocos2d::Sprite::create("floor.png");
    cocos2d::Sprite* rock = cocos2d::Sprite::create("rocks.png");
    cocos2d::Sprite* rock2 = cocos2d::Sprite::create("rocks.png");
    cocos2d::Sprite* gamewon = cocos2d::Sprite::create("won.png");
    
    InfiniteParallaxNode* walls;
    InfiniteParallaxNode* ceiling;
    InfiniteParallaxNode* ground;
    InfiniteParallaxNode* gamerock;
    
public:
    static cocos2d::Scene* createScene();
    
    virtual bool init();
    
    void update(float delta);
    
    void GoToMainMenuScene(Ref* mynewscene);
    
    // implement the "static create()" method manually
    CREATE_FUNC(winner);
};

#endif /* defined(__Game__winnerScene__) */
