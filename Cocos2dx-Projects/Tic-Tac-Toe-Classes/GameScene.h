#ifndef __Game_Scene_H__
#define __Game_Scene_H__

#include "cocos2d.h"

class GameScene : public cocos2d::Layer
{
private:
    cocos2d::Sprite* wall = cocos2d::Sprite::create("xp.jpg");
    cocos2d::Sprite* refresh = cocos2d::Sprite::create("refresh.png");
    cocos2d::Sprite* gridSprite[9];
    cocos2d::Sprite* occupySprite[9];
    cocos2d::Sprite* leftSprite[9];
    cocos2d::Sprite* rightSprite[9];
    cocos2d::Sprite* left = cocos2d::Sprite::create("google.png");
    cocos2d::Sprite* right = cocos2d::Sprite::create("firefox.png");
    
public:
    static cocos2d::Scene* createScene();
    
    virtual bool init();
    
    cocos2d::EventListenerTouchOneByOne touch1();
    cocos2d::EventListenerTouchOneByOne touch2();
    bool onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event);
    void onTouchMoved(cocos2d::Touch *touch, cocos2d::Event *event);
    void onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event);
    bool TTTlogic(cocos2d::Sprite* arrayin[]);
    bool checkbox(cocos2d::Sprite* insprites);
    bool checkdraw(cocos2d::Sprite* arrayin[]);
    void handlerefresh();
    void newscene();
    void handlesprites(cocos2d::Sprite* newsprites);
    
    void GoToMainMenu(Ref* mynewscene);
    
    CREATE_FUNC(GameScene);
};

#endif /* defined(__Game__MenuScene__) */
