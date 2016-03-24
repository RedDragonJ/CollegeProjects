#ifndef __MAINMENU_SCENE_H__
#define __MAINMENU_SCENE_H__

#include "cocos2d.h"

class MainMenu : public cocos2d::Layer
{
private:
    cocos2d::Sprite* wall = cocos2d::Sprite::create("xp.jpg");
    
public:
    
    static cocos2d::Scene* createScene();
    
    virtual bool init();
    
    CREATE_FUNC(MainMenu);
    
    void GoToGameScene(Ref* mynewscene);
};

#endif // __HELLOWORLD_SCENE_H__
