#include "EndGameScene.h"
#include "MainMenuScene.h"
#include "InfiniteParallaxNode.h"
#include "SimpleAudioEngine.h"

USING_NS_CC;

Scene* EndGame::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = EndGame::create();
    
    // add layer as a child to scene
    scene->addChild(layer);
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool EndGame::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CocosDenshion::SimpleAudioEngine::getInstance()->pauseAllEffects();
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("gamemusics/gameover.mp3", false);
    
    this -> walls = InfiniteParallaxNode::create();
    this-> ceiling = InfiniteParallaxNode::create();
    this-> ground = InfiniteParallaxNode::create();
    this-> gamerock = InfiniteParallaxNode::create();
    
    this->wall->setScaleY(visibleSize.height/wall->getContentSize().height*1);
    this->wall->setAnchorPoint(Point(0.0, 0.0));
    this->wall2->setScaleY(visibleSize.height/wall2->getContentSize().height*1);
    this->wall2->setAnchorPoint(Point(0.0, 0.0));
    this->spike->setScaleY(visibleSize.height/spike->getContentSize().height*1);
    this->spike->setAnchorPoint(Point(0,0));
    this->spike2->setScaleY(visibleSize.height/spike2->getContentSize().height*1);
    this->spike2->setAnchorPoint(Point(0, 0));
    this->floor->setScaleY(visibleSize.height/floor->getContentSize().height*1);
    this->floor->setAnchorPoint(Point(0,0));
    this->floor2->setScaleY(visibleSize.height/floor2->getContentSize().height*1);
    this->floor2->setAnchorPoint(Point(0, 0));
    this->rock->setScaleY(visibleSize.height/rock->getContentSize().height*1);
    this->rock->setAnchorPoint(Point(0,0));
    this->rock2->setScaleY(visibleSize.height/rock2->getContentSize().height*1);
    this->rock2->setAnchorPoint(Point(0,0));
    
    this-> walls-> addChild(this->wall, -10, Point(4, 1), origin);
    this-> walls-> addChild(this->wall2, -10, Point(4, 1), origin+Point(this->wall2->getContentSize().width, 0));
    this->addChild(walls);
    this-> ceiling-> addChild(this->spike, -5, Point(5, 1), origin);
    this-> ceiling-> addChild(this->spike2, -5, Point(5, 1), origin+Point(this->spike2->getContentSize().width, 0));
    this->addChild(ceiling);
    this-> ground-> addChild(this->floor, -5, Point(6, 1), origin);
    this-> ground-> addChild(this->floor2, -5, Point(6, 1), origin+Point(this->floor2->getContentSize().width, 0));
    this->addChild(ground);
    this-> gamerock-> addChild(this->rock, 5, Point(6, 1), origin);
    this-> gamerock-> addChild(this->rock2, 5, Point(6, 1), origin+Point(this->rock2->getContentSize().width, 0));
    this->addChild(gamerock);
    
    this->gameover->setScale(visibleSize.width/gameover->getContentSize().width*1, visibleSize.height/gameover->getContentSize().height*1);
    this->gameover->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2);
    this->addChild(gameover);
    
    auto play = MenuItemImage::create("menubutton.png", "menubutton.png", CC_CALLBACK_1(EndGame::GoToMainMenuScene, this));
    auto menu = Menu::create(play, NULL);
    menu->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2-50);
    menu->setScale(1);
    this->addChild(menu, 10);
    
    this->scheduleUpdate();
    
    return true;
}

void EndGame::update(float delta) {
    
    Point scrollDecrement = Point(1, 0);
    this -> walls -> setPosition(this -> walls -> getPosition() -scrollDecrement);
    this -> walls -> updatePosition();
    this -> ceiling -> setPosition(this -> ceiling -> getPosition() -scrollDecrement);
    this -> ceiling -> updatePosition();
    this -> ground -> setPosition(this -> ground -> getPosition() -scrollDecrement);
    this -> ground -> updatePosition();
    this -> gamerock -> setPosition(this -> gamerock -> getPosition() -scrollDecrement);
    this -> gamerock -> updatePosition();
}

void EndGame::GoToMainMenuScene(cocos2d::Ref* mynewscene){
    
    CocosDenshion::SimpleAudioEngine::getInstance()->pauseAllEffects();
    auto scene = MainMenu::createScene();
    Director::getInstance()->pushScene(TransitionFlipX::create(2, scene));
}
