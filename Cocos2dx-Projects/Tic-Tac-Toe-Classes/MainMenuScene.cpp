#include "MainMenuScene.h"
#include "GameScene.h"

USING_NS_CC;

Scene* MainMenu::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = MainMenu::create();
    
    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

bool MainMenu::init()
{
    if (!Layer::init())
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    this->wall->setPosition(Point(visibleSize.width/2, visibleSize.height/2));
    this->addChild(this->wall, -1);
    
    auto text = Label::createWithSystemFont("Tic-Tac-Toe", "fonts/Marker Felt.ttf", 80);
    text->setPosition(visibleSize.width/2, visibleSize.height-50);
    text->setColor(Color3B::BLACK);
    text->enableShadow(Color4B::WHITE,Size(5,3));
    this->addChild(text);
    
    auto text2 = Label::createWithSystemFont("(Browsers War!)", "fonts/Marker Felt.ttf", 50);
    text2->setPosition(visibleSize.width/2, visibleSize.height-120);
    text2->setColor(Color3B::BLACK);
    text2->enableShadow(Color4B::WHITE,Size(5,3));
    this->addChild(text2);
    
    auto click = Label::createWithSystemFont("Click to Play!", "fonts/Marker Felt.ttf", 50);
    click->setPosition(visibleSize.width/2, visibleSize.height/2+100);
    click->setColor(Color3B::BLACK);
    this->addChild(click);

    auto play = MenuItemImage::create("play.png", "play.png", CC_CALLBACK_1(MainMenu::GoToGameScene, this));
    auto menu = Menu::create(play, NULL);
    this->addChild(menu);
    
    return true;
}

void MainMenu::GoToGameScene(cocos2d::Ref* mynewscene)
{
    auto scene = GameScene::createScene();
    
    Director::getInstance()->replaceScene(scene);
}





