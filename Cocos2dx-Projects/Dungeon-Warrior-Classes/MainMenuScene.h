#ifndef __MAINMENU_SCENE_H__
#define __MAINMENU_SCENE_H__

#include "cocos2d.h"
#include "InfiniteParallaxNode.h"

class MainMenu : public cocos2d::Layer
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
    cocos2d::Sprite* title = cocos2d::Sprite::create("title.png");
    
    cocos2d::Sprite* showhero = cocos2d::Sprite::create("showhero1.png");
    cocos2d::RepeatForever* heroanimate;

    InfiniteParallaxNode* walls;
    InfiniteParallaxNode* ceiling;
    InfiniteParallaxNode* ground;
    InfiniteParallaxNode* gamerock;
        
public:
    static cocos2d::Scene* createScene();

    virtual bool init();
    
    void displayhero();
    
    void update(float delta);
    
    void GoToGameScene(Ref* mynewscene);
    
    // implement the "static create()" method manually
    CREATE_FUNC(MainMenu);
};

#endif // __HELLOWORLD_SCENE_H__
