#include "MainMenuScene.h"
#include "GameScene.h"
#include "InfiniteParallaxNode.h"
#include "SimpleAudioEngine.h"

//debug scene
#include "BossScene.h"

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

// on "init" you need to initialize your instance
bool MainMenu::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/begingame.mp3", true);
    
    this -> walls = InfiniteParallaxNode::create();
    this-> ceiling = InfiniteParallaxNode::create();
    this-> ground = InfiniteParallaxNode::create();
    this-> gamerock = InfiniteParallaxNode::create();
    
    this->wall->setScaleY(visibleSize.height/wall->getContentSize().height*1);
    this->wall->setAnchorPoint(Point(0,0));
    this->wall2->setScaleY(visibleSize.height/wall2->getContentSize().height*1);
    this->wall2->setAnchorPoint(Point(0,0));
    this->spike->setScaleY(visibleSize.height/spike->getContentSize().height*1);
    this->spike->setAnchorPoint(Point(0,0));
    this->spike2->setScaleY(visibleSize.height/spike2->getContentSize().height*1);
    this->spike2->setAnchorPoint(Point(0,0));
    this->floor->setScaleY(visibleSize.height/floor->getContentSize().height*1);
    this->floor->setAnchorPoint(Point(0,0));
    this->floor2->setScaleY(visibleSize.height/floor2->getContentSize().height*1);
    this->floor2->setAnchorPoint(Point(0,0));
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

    
    this->title->setScale(visibleSize.width/title->getContentSize().width*1, visibleSize.height/title->getContentSize().height*1);
    this-> title->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2-10);
    this->addChild(title, 10);
    
    auto play = MenuItemImage::create("playbutton.png", "playbutton.png", CC_CALLBACK_1(MainMenu::GoToGameScene, this));
    auto menu = Menu::create(play, NULL);
    menu->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2-60);
    menu->setScale(1);
    this->addChild(menu, 10);
    
    this->displayhero();
    
    this->scheduleUpdate();
    
    return true;
}

void MainMenu::displayhero() {
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    SpriteFrameCache::getInstance()-> addSpriteFramesWithFile("showhero/showheroanimate.plist", "showhero/showheroanimate.png");
    
    showhero->setPosition(origin.x+240, origin.y+265);
    this->addChild(showhero, 0);
    
    Vector<SpriteFrame*> animFrames(4);
    char str[100] = {0};
    for(int i = 1; i <= 4; i++)
    {
        sprintf(str, "showhero/showhero%d.png",i);
        auto frame = SpriteFrame::create(str,Rect(0,0,100,100));
        animFrames.pushBack(frame);
    }
    
    auto animation = Animation::createWithSpriteFrames(animFrames, 0.2f);
    heroanimate = RepeatForever::create(Animate::create(animation));
    showhero->runAction(heroanimate);
}

void MainMenu::update(float delta) {
    
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

void MainMenu::GoToGameScene(Ref* mynewscene){
    auto scene = GameScene::createScene();
    //auto scene = Boss::createScene();
    Director::getInstance()->pushScene(TransitionFade::create(2.0f, scene));
    CocosDenshion::SimpleAudioEngine::getInstance()->pauseAllEffects();
}




