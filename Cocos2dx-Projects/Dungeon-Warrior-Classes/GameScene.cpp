#include "GameScene.h"
//#include "BossScene.h"
#include "MainMenuScene.h"
#include "EndGameScene.h"
#include "BossScene.h"
#include "InfiniteParallaxNode.h"
#include "SimpleAudioEngine.h"

USING_NS_CC;

Scene* GameScene::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::createWithPhysics();
    scene->getPhysicsWorld() -> setGravity(Vect(0, -580.0f));
    
    //scene->getPhysicsWorld() -> setDebugDrawMask(PhysicsWorld::DEBUGDRAW_ALL);
    
    // 'layer' is an autorelease object
    auto layer = GameScene::create();
    layer -> setPhysicsWorld(scene->getPhysicsWorld());
    
    // add layer as a child to scene
    scene->addChild(layer);
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool GameScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("gamemusics/dungeon.mp3", true);
    
    this -> walls = InfiniteParallaxNode::create();
    this-> ceiling = InfiniteParallaxNode::create();
    this-> ground = InfiniteParallaxNode::create();
    this-> gamerock = InfiniteParallaxNode::create();
    
    this->wall->setScaleY(visibleSize.height/wall->getContentSize().height*1);
    this->wall->setAnchorPoint(Point(0.0, 0.0));
    this->wall2->setScaleY(visibleSize.height/wall2->getContentSize().height*1);
    this->wall2->setAnchorPoint(Point(0.0, 0.0));
    this->spike->setScaleY(visibleSize.height/wall->getContentSize().height*1);
    this->spike->setAnchorPoint(Point(0,0));
    this->spike2->setScaleY(visibleSize.height/wall2->getContentSize().height*1);
    this->spike2->setAnchorPoint(Point(0, 0));
    this->floor->setScaleY(visibleSize.height/floor->getContentSize().height*1);
    this->floor->setAnchorPoint(Point(0,0));
    this->floor2->setScaleY(visibleSize.height/floor2->getContentSize().height*1);
    this->floor2->setAnchorPoint(Point(0, 0));
    this->rock->setScaleY(visibleSize.height/rock->getContentSize().height*1);
    this->rock->setAnchorPoint(Point(0,0));
    this->rock2->setScaleY(visibleSize.height/rock2->getContentSize().height*1);
    this->rock2->setAnchorPoint(Point(0,0));
    
    this-> walls-> addChild(this->wall, -9, Point(1, 1), origin);
    this-> walls-> addChild(this->wall2, -9, Point(1, 1), origin+Point(this->wall2->getContentSize().width, 0));
    this->addChild(walls);
    this-> ceiling-> addChild(this->spike, -5, Point(2, 1), origin);
    this-> ceiling-> addChild(this->spike2, -5, Point(2, 1), origin+Point(this->spike2->getContentSize().width, 0));
    this->addChild(ceiling);
    this-> ground-> addChild(this->floor, -5, Point(3, 1), origin);
    this-> ground-> addChild(this->floor2, -5, Point(3, 1), origin+Point(this->floor2->getContentSize().width, 0));
    this->addChild(ground);
    this-> gamerock-> addChild(this->rock, 5, Point(3, 1), origin);
    this-> gamerock-> addChild(this->rock2, 5, Point(3, 1), origin+Point(this->rock2->getContentSize().width, 0));
    this->addChild(gamerock);

    music->setScale(0.5);
    music->setPosition(origin.x+visibleSize.width-music->getContentSize().width-10, origin.y+visibleSize.height-music->getContentSize().height/2);
    playpause->setScale(0.5);
    playpause->setPosition(origin.x+visibleSize.width-playpause->getContentSize().width/2, origin.y+visibleSize.height-playpause->getContentSize().height/2);
    
    this->jump->setScale(0.8);
    this-> jump-> setPosition(origin.x+jump->getContentSize().width/2, origin.y+jump->getContentSize().height/2);
    auto fade = FadeTo::create(0, 150);
    jump->runAction(fade);
    auto listener = EventListenerTouchOneByOne::create();
    listener->setSwallowTouches(true);
    listener->onTouchBegan = CC_CALLBACK_2(GameScene::onTouchBegan, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this->jump);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->music);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->playpause);
    this->addChild(this->jump, 20);
    this->addChild(this->music, 20);
    this->addChild(this->playpause, 20);
    
    //set walkers
    this->walker->setScale(0.5);
    this->walker->setPosition(origin.x+visibleSize.width+walker->getContentSize().width/2, origin.y+40);
    this->walker1->setScale(0.5);
    this->walker1->setPosition(origin.x+visibleSize.width/2+(walker1->getContentSize().width*2), origin.y+40);
    this->walker2->setScale(0.5);
    this->walker2->setPosition(origin.x+visibleSize.width*2, origin.y+40);
    //set flyers
    this->flyer->setScale(0.5);
    this->flyer->setPosition(origin.x+visibleSize.width+flyer->getContentSize().width, origin.y+visibleSize.height-80);
    this->flyer1->setScale(0.5);
    this->flyer1->setPosition(origin.x+visibleSize.width*2+visibleSize.width/2, origin.y+visibleSize.height/2-80);
    this->flyer2->setScale(0.5);
    this->flyer2->setPosition(origin.x+visibleSize.width+visibleSize.width-flyer2->getContentSize().width, origin.y+visibleSize.height-150);
    
    //set hero
    this->hero->setScale(0.5);
    this->hero->setPosition(origin.x+180, origin.y+55);
    this->block2->setPosition(origin.x+visibleSize.width/2, origin.y+this->block2->getContentSize().height/2);
    this->blocktop1->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height-5);
    this->blocktop2->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height+10);
    
    this->hp ->setScale(0.03);
    this->hp ->setPosition(origin.x+50, origin.y+visibleSize.height-50);
    this->addChild(hp);
    this->hp1 ->setScale(0.03);
    this->hp1 ->setPosition(origin.x+70, origin.y+visibleSize.height-50);
    this->addChild(hp1);
    this->hp2 ->setScale(0.03);
    this->hp2 ->setPosition(origin.x+90, origin.y+visibleSize.height-50);
    this->addChild(hp2);
    
    this->runninganimation();
    this->walkmonsters();
    this->flymonsters();
    
    this->initPhysicsSprites();
    auto physciscontact = EventListenerPhysicsContact::create();
    physciscontact->onContactBegin = CC_CALLBACK_1(GameScene::physcisOnContactBegin, this);
    this->getEventDispatcher()->addEventListenerWithSceneGraphPriority(physciscontact, this);
    
    auto fadebox = FadeOut::create(0.1);
    blocktop1->runAction(fadebox);
    
    this->scheduleUpdate();
    
    return true;
}

bool GameScene::onTouchBegan(cocos2d::Touch* touch, cocos2d::Event* event) {
    
    auto target = static_cast<Sprite*>(event->getCurrentTarget());
    Point locationInNode = target->convertToNodeSpace(touch->getLocation());
    
    Size s = target->getContentSize();
    Rect rect = Rect(0, 0, s.width, s.height);
    
    if (target == this->jump){
        if (rect.containsPoint(locationInNode)){
            CCLOG("jump touched");
            herobody->setEnable(true);
            herobody->setResting(false);
            herobody->setGravityEnable(true);
            hero->getPhysicsBody()->applyImpulse(Vect(0, 150));
            return true;
        }
        else{
            return false;
        }
    }
    else if (target == this->music){
        if (rect.containsPoint(locationInNode)){
            CCLOG("play and pause music touched");
            if (CocosDenshion::SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying() == true) {
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseAllEffects();
                this->endgameon = false;
                this->herodeadon = false;
                this->herohiton = false;
                return true;
            }
            else {
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeAllEffects();
                this->endgameon = true;
                this->herodeadon = true;
                this->herohiton = true;
                return true;
            }
        }
        else {
            return false;
        }
    }
    else if (target == this->playpause){
        if (rect.containsPoint(locationInNode)){
            CCLOG("play and pause touched");
            if (Director::getInstance()->isPaused() == false) {
                herobody->setGravityEnable(false);
                herobody->setResting(true);
                herobody->setEnable(false);
                Director::getInstance()->pause();
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->jump);
                return true;
            }
            else {
                herobody->setEnable(true);
                herobody->setResting(false);
                herobody->setGravityEnable(true);
                Director::getInstance()->resume();
                auto move = MoveTo::create(0.1, Point(hero->getPositionX(), hero->getPositionY()));
                hero->runAction(move);
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
                Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->jump);
                return true;
            }
        }
        else {
            return false;
        }
    }
    else{
        return true;
    }
}

bool GameScene::physcisOnContactBegin(const cocos2d::PhysicsContact &contact) {
    CCLOG("player killed by monsters");
    
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    if (lifecount == 3) {
        if (this->herohiton == true) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/hit.mp3");
        }
        
        auto flash = Blink::create(0.6, 3);
        hero->runAction(flash);
        this->removeChild(hp2);
        lifecount--;
        return false;
    }
    else if (lifecount == 2) {
        if (this->herohiton == true) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/hit.mp3");
        }
        
        auto flash = Blink::create(0.6, 3);
        hero->runAction(flash);
        this->removeChild(hp1);
        lifecount--;
        return false;
    }
    else if (lifecount == 1) {
        auto flash = Blink::create(0.6, 3);
        hero->runAction(flash);
        this->removeChild(hp);
        lifecount--;
        
        CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
        if (this->herodeadon == true) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/death.mp3");
        }
        
        
        hero->stopAction(heroanimate);
        herobody->setEnable(false);
        
        auto moveup = MoveTo::create(0.3, Point(origin.x+180, hero->getPositionY()+30));
        auto movedown = MoveTo::create(1, Point(origin.x+180, origin.y-hero->getContentSize().height-10));
        hero->runAction(Sequence::create(moveup, movedown, NULL));
        
        auto togrey = TintTo::create(0.1, 128*65536, 128*256, 128);
        hero->runAction(togrey);
        
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->jump);
        
        CallFunc *runCallback = CallFunc::create(CC_CALLBACK_0(GameScene::GoToEndGameScene, this));
        this->runAction(Sequence::create(DelayTime::create(2.0), runCallback, NULL));
        
        return false;
    }
    else {
        return true;
    }
}

void GameScene::initPhysicsSprites () {

    herobody = PhysicsBody::createBox(Size(40, 40), PhysicsMaterial(0,0,0));
    blocktopbody1 = PhysicsBody::createBox(Size(1000, 30), PhysicsMaterial(0,0,0));
    blocktopbody2 = PhysicsBody::createBox(Size(1000, 30), PhysicsMaterial(0,0,0));
    blockbody2 = PhysicsBody::createBox(Size(1000, 30), PhysicsMaterial(100,0,0));
    walkerbody = PhysicsBody::createBox(Size(30, 30), PhysicsMaterial(0,0,0));
    walkerbody1 = PhysicsBody::createBox(Size(30, 30), PhysicsMaterial(0,0,0));
    walkerbody2 = PhysicsBody::createBox(Size(30, 30), PhysicsMaterial(0,0,0));
    flyerbody = PhysicsBody::createBox(Size(30, 30), PhysicsMaterial(0,0,0));
    flyerbody1 = PhysicsBody::createBox(Size(30, 30), PhysicsMaterial(0,0,0));
    flyerbody2 = PhysicsBody::createBox(Size(30, 30), PhysicsMaterial(0,0,0));
    
    herobody-> setDynamic(true);
    blocktopbody1-> setDynamic(false);
    blocktopbody2-> setDynamic(false);
    blockbody2-> setDynamic(false);
    walkerbody-> setDynamic(false);
    walkerbody1-> setDynamic(false);
    walkerbody2-> setDynamic(false);
    flyerbody-> setDynamic(false);
    flyerbody1-> setDynamic(false);
    flyerbody2-> setDynamic(false);
    
    blockbody2->setGravityEnable(false);
    
    hero-> setPhysicsBody(herobody);
    blocktop1-> setPhysicsBody(blocktopbody1);
    blocktop2-> setPhysicsBody(blocktopbody2);
    block2-> setPhysicsBody(blockbody2);
    walker-> setPhysicsBody(walkerbody);
    walker1-> setPhysicsBody(walkerbody1);
    walker2-> setPhysicsBody(walkerbody2);
    flyer-> setPhysicsBody(flyerbody);
    flyer1-> setPhysicsBody(flyerbody1);
    flyer2-> setPhysicsBody(flyerbody2);
    
    this->addChild(hero, 8);
    this->addChild(blocktop1, 8);
    this->addChild(blocktop2, -10);
    this->addChild(block2, -12);
    this->addChild(walker, 8);
    this->addChild(walker1, 8);
    this->addChild(walker2, 8);
    this->addChild(flyer, 8);
    this->addChild(flyer1, 8);
    this->addChild(flyer2, 8);
    
    herobody->setContactTestBitmask(0x10);
    blocktopbody1->setContactTestBitmask(0x10);
    walkerbody->setContactTestBitmask(0x10);
    walkerbody1->setContactTestBitmask(0x10);
    walkerbody2->setContactTestBitmask(0x10);
    flyerbody->setContactTestBitmask(0x10);
    flyerbody1->setContactTestBitmask(0x10);
    flyerbody2->setContactTestBitmask(0x10);
}

void GameScene::runninganimation() {
    CCLOG("hero animation called");
    
    Vector<SpriteFrame*> animFrames(4);
    char str[100] = {0};
    for(int i = 1; i <= 4; i++)
    {
        sprintf(str, "hero/hero%d.png",i);
        auto frame = SpriteFrame::create(str,Rect(0,0,100,100));
        animFrames.pushBack(frame);
    }
    
    auto animation = Animation::createWithSpriteFrames(animFrames, 0.2f);
    heroanimate = RepeatForever::create(Animate::create(animation));
    hero->runAction(heroanimate);
}

void GameScene::walkmonsters() {
    CCLOG("walker animation called");
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    Vector<SpriteFrame*> animFrames(3);
    char str[100] = {0};
    for(int i = 1; i <= 3; i++)
    {
        sprintf(str, "walkers/walker%d.png",i);
        auto frame = SpriteFrame::create(str,Rect(0,0,60,85));
        animFrames.pushBack(frame);
    }
    auto animation = Animation::createWithSpriteFrames(animFrames, 0.4f);
    auto animation1 = Animation::createWithSpriteFrames(animFrames, 0.6f);
    auto animation2 = Animation::createWithSpriteFrames(animFrames, 0.7f);
    
    //first walker animation
    walkeranimate = RepeatForever::create(Animate::create(animation));
    walker->runAction(walkeranimate);
    walkermoveleft = MoveTo::create(9, Point(origin.x-walker->getContentSize().width/2-1, origin.y+40));
    walker->runAction(RepeatForever::create(walkermoveleft));

    //second walker animation
    walkeranimate1 = RepeatForever::create(Animate::create(animation1));
    walker1->runAction(walkeranimate1);
    walkermoveleft1 = MoveTo::create(15, Point(origin.x-walker1->getContentSize().width/2-1, origin.y+40));
    walker1->runAction(RepeatForever::create(walkermoveleft1));
    
    //third walker animation
    walkeranimate2 = RepeatForever::create(Animate::create(animation2));
    walker2->runAction(walkeranimate2);
    walkermoveleft2 = MoveTo::create(19, Point(origin.x-walker2->getContentSize().width/2-1, origin.y+40));
    walker2->runAction(RepeatForever::create(walkermoveleft2));
}

void GameScene::flymonsters() {
    CCLOG("walker animation called");
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    Vector<SpriteFrame*> animFrames(3);
    char str[100] = {0};
    for(int i = 1; i <= 3; i++)
    {
        sprintf(str, "flyers/flyer%d.png",i);
        auto frame = SpriteFrame::create(str,Rect(0,0,100,100));
        animFrames.pushBack(frame);
    }
    auto animation = Animation::createWithSpriteFrames(animFrames, 0.6f);
    auto animation1 = Animation::createWithSpriteFrames(animFrames, 1.0f);
    auto animation2 = Animation::createWithSpriteFrames(animFrames, 0.7f);
    
    //first flyer animation
    flyeranimate = RepeatForever::create(Animate::create(animation));
    flyer->runAction(flyeranimate);
    flyermoveleft = MoveTo::create(12, Point(origin.x-flyer->getContentSize().width/2-1, origin.y+visibleSize.height-80));
    flyer->runAction(RepeatForever::create(flyermoveleft));
    
    //second flyer animation
    flyeranimate1 = RepeatForever::create(Animate::create(animation1));
    flyer1->runAction(flyeranimate1);
    flyermoveleft1 = MoveTo::create(19, Point(origin.x-flyer1->getContentSize().width/2-1, origin.y+visibleSize.height/2-80));
    flyer1->runAction(RepeatForever::create(flyermoveleft1));
    
    //third walker animation
    flyeranimate2 = RepeatForever::create(Animate::create(animation2));
    flyer2->runAction(flyeranimate2);
    flyermoveleft2 = MoveTo::create(14, Point(origin.x-flyer2->getContentSize().width/2-1, origin.y+visibleSize.height-150));
    flyer2->runAction(RepeatForever::create(flyermoveleft2));
}

void GameScene::update(float newdelta) {
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CCLOG("time is %d", gametime);
    gametime--;
    
    if (this->gametime > 0) {
        Point scrollDecrement = Point(1, 0);
        this -> walls -> setPosition(this -> walls -> getPosition() -scrollDecrement);
        this -> walls -> updatePosition();
        this -> ceiling -> setPosition(this -> ceiling -> getPosition() -scrollDecrement);
        this -> ceiling -> updatePosition();
        this -> ground -> setPosition(this -> ground -> getPosition() -scrollDecrement);
        this -> ground -> updatePosition();
        this -> gamerock -> setPosition(this -> gamerock -> getPosition() -scrollDecrement);
        this -> gamerock -> updatePosition();

        //re-position walker
        if (walker->getPositionX() < origin.x-walker->getContentSize().width/2) {
            CCLOG("reset position of walker");
            this->walker->setPosition(origin.x+visibleSize.width+walker->getContentSize().width/2, origin.y+40);
        }
        else if (walker1->getPositionX() < origin.x-walker1->getContentSize().width/2) {
            CCLOG("reset position of walker1");
            this->walker1->setPosition(origin.x+visibleSize.width+visibleSize.width/2+(walker1->getContentSize().width*2), origin.y+40);
        }
        else if (walker2->getPositionX() < origin.x-walker2->getContentSize().width*2) {
            CCLOG("reset position of walker2");
            this->walker2->setPosition(origin.x+visibleSize.width+visibleSize.width/2, origin.y+40);
        }
        //re-position flyer
        else if (flyer->getPositionX() < origin.x-flyer->getContentSize().width/2) {
            CCLOG("reset position of flyer");
            this->flyer->setPosition(origin.x+visibleSize.width+flyer->getContentSize().width, origin.y+visibleSize.height-80);
        }
        else if (flyer1->getPositionX() < origin.x-flyer1->getContentSize().width/2) {
            CCLOG("reset position of flyer1");
            this->flyer1->setPosition(origin.x+visibleSize.width*2+visibleSize.width/2, origin.y+visibleSize.height/2-80);
        }
        else if (flyer2->getPositionX() < origin.x-flyer2->getContentSize().width/2) {
            CCLOG("reset position of flyer2");
            this->flyer2->setPosition(origin.x+visibleSize.width+visibleSize.width-flyer2->getContentSize().width, origin.y+visibleSize.height-150);
        }
    }
    else if (this->gametime == 0) {
        CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
        if (this->endgameon == true) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/endgame.mp3");
        }
        
        walker->stopAllActions();
        walker1->stopAllActions();
        walker2->stopAllActions();
        flyer->stopAllActions();
        flyer1->stopAllActions();
        flyer2->stopAllActions();
        herobody->setDynamic(false);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->jump);
        auto moveout = MoveTo::create(5, Point(origin.x+visibleSize.width+hero->getContentSize().width, origin.y+visibleSize.height/2));
        hero->runAction(moveout);
        CallFunc *runCallback = CallFunc::create(CC_CALLBACK_0(GameScene::GoToBossScene, this));
        this->runAction(Sequence::create(DelayTime::create(5.0), runCallback, NULL));
    }
}

void GameScene::GoToEndGameScene() {
    CocosDenshion::SimpleAudioEngine::sharedEngine()->pauseAllEffects();
    auto scene = EndGame::createScene();
    Director::getInstance()->pushScene(TransitionFade::create(2.0f, scene));
}

void GameScene::GoToBossScene() {
    CocosDenshion::SimpleAudioEngine::sharedEngine()->pauseAllEffects();
    auto scene = Boss::createScene();
    Director::getInstance()->pushScene(TransitionFade::create(2.0f, scene));
}






