#include "BossScene.h"
#include "SimpleAudioEngine.h"
#include "EndGameScene.h"
#include "winnerScene.h"

USING_NS_CC;

Scene* Boss::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = Boss::create();
    
    // add layer as a child to scene
    scene->addChild(layer);
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool Boss::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CocosDenshion::SimpleAudioEngine::sharedEngine()->playBackgroundMusic("gamemusics/bossmusic.mp3", true);
    
    this->wall->setScaleY(visibleSize.height/wall->getContentSize().height*1);
    this->wall->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2);
    this->spike->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height);
    this->hero->setScale(0.5);
    this->hero->setPosition(origin.x+hero->getContentSize().width/2, origin.y+visibleSize.height/2);
    this->boss->setScale(0.8);
    this->boss->setPosition(origin.x+visibleSize.width-50, origin.y+visibleSize.height/2);
    this->lava->setPosition(origin.x+visibleSize.width/2, origin.y+this->lava->getContentSize().height-60);
    this->lava->setScale(1.7, 1);
    
    //position keys
    this->upkey->setPosition(origin.x+100, origin.y+105);
    this->downkey->setPosition(origin.x+100, origin.y+35);
    this->leftkey->setPosition(origin.x+35, origin.y+65);
    this->rightkey->setPosition(origin.x+165, origin.y+65);
    this->attackkey->setPosition(origin.x+visibleSize.width-attackkey->getContentSize().width/2, origin.y+attackkey->getContentSize().height/2);
    this->upkey->setScale(0.5);
    this->downkey->setScale(0.5);
    this->leftkey->setScale(0.5);
    this->rightkey->setScale(0.5);
    this->attackkey->setScale(0.8);
    auto fadekey1 = FadeTo::create(0, 150);
    this->upkey->runAction(fadekey1);
    auto fadekey2 = FadeTo::create(0, 150);
    this->downkey->runAction(fadekey2);
    auto fadekey3 = FadeTo::create(0, 150);
    this->leftkey->runAction(fadekey3);
    auto fadekey4 = FadeTo::create(0, 150);
    this->rightkey->runAction(fadekey4);
    auto fadekey5 = FadeTo::create(0, 150);
    this->attackkey->runAction(fadekey5);
    
    //move boss and hero to position
    auto flyin = MoveTo::create(2, Point(origin.x+150, origin.y+visibleSize.height/2));
    this->hero->runAction(flyin);
    
    //touch listener
    auto listener = EventListenerTouchOneByOne::create();
    listener->setSwallowTouches(true);
    listener->onTouchBegan = CC_CALLBACK_2(Boss::onTouchBegan, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this->attackkey);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->upkey);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->downkey);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->leftkey);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->rightkey);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->music);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener->clone(), this->playpause);
    
    //pause arrow keys
    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->upkey);
    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->downkey);
    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->leftkey);
    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->rightkey);
    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->attackkey);
    
    //hp text
    this->text1->setPosition(origin.x+125, origin.y+visibleSize.height-40);
    this->addChild(text1, 5);
    this->text2->setPosition(origin.x+visibleSize.width-175, origin.y+visibleSize.height-40);
    this->addChild(text2, 5);
    this->texthp1->setPosition(origin.x+105, origin.y+visibleSize.height-40);
    this->addChild(texthp1, 5);
    this->texthp2->setPosition(origin.x+visibleSize.width-195, origin.y+visibleSize.height-40);
    this->addChild(texthp2, 5);
    
    //damages
    this->fireball->setPosition(origin.x-this->fireball->getContentSize().width, origin.y+visibleSize.height/2);
    this->fireball->setScale(0.5);
    this->addChild(fireball, 1);
    this->death1->setPosition(origin.x+visibleSize.width+this->death1->getContentSize().width, origin.y+visibleSize.height/2);
    this->death1->setScale(0.8);
    this->addChild(death1, 2);
    
    //health
    this->bosshp->setPosition(origin.x+visibleSize.width-250, origin.y+visibleSize.height-20);
    this->bosshp->setScale(bosshpX, 0.02);
    this->bosshp->setAnchorPoint(Point(0, 0.5));
    this->addChild(bosshp, 5);
    this->herohp->setPosition(origin.x+50, origin.y+visibleSize.height-20);
    this->herohp->setScale(herohpX, 0.02);
    this->herohp->setAnchorPoint(Point(0, 0.5));
    this->addChild(herohp, 5);
    
    //hp head
    this->herohead->setPosition(origin.x+40, origin.y+visibleSize.height-20);
    this->herohead->setScale(1.4);
    this->addChild(this->herohead, 5);
    this->bosshead->setPosition(origin.x+visibleSize.width-260, origin.y+visibleSize.height-20);
    this->bosshead->setScale(1.2);
    this->addChild(this->bosshead, 5);
    
    //scene effects
    this->lavalight->setPosition(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2);
    this->lavalight->setScale(1, 0.8);
    auto fadelight = FadeTo::create(0.1, 80);
    this->lavalight->runAction(fadelight);
    this->addChild(lavalight);
    this->side1->setPosition(origin.x-this->side1->getContentSize().width, origin.y+visibleSize.height/2);
    this->side1->setScale(1, 1.8);
    this->addChild(side1);
    this->side2->setPosition(origin.x+visibleSize.width+this->side2->getContentSize().width, origin.y+visibleSize.height/2);
    this->side2->setScale(1, 1.8);
    this->addChild(side2);
    
    //play/ pause scene and music
    this->music->setScale(0.5);
    this->music->setPosition(origin.x+visibleSize.width/2-music->getContentSize().width+15, origin.y+visibleSize.height-music->getContentSize().height/2);
    this->addChild(music);
    this->playpause->setScale(0.5);
    this->playpause->setPosition(origin.x+visibleSize.width/2-playpause->getContentSize().width/2+25, origin.y+visibleSize.height-playpause->getContentSize().height/2);
    this->addChild(playpause);
    
    this->addChild(upkey, 10);
    this->addChild(downkey, 10);
    this->addChild(leftkey, 10);
    this->addChild(rightkey, 10);
    this->addChild(attackkey, 3);
    this->addChild(hero, 2);
    this->addChild(boss, 1);
    this->addChild(wall, -10);
    this->addChild(spike, -1);
    this->addChild(lava, -1);
    
    this->heroanimation();
    this->bossanimation();
    
    this->scheduleUpdate();
    
    return true;
}

bool Boss::onTouchBegan(cocos2d::Touch* touch, cocos2d::Event* event){
    auto target = static_cast<Sprite*>(event->getCurrentTarget());
    Point locationInNode = target->convertToNodeSpace(touch->getLocation());
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    Size s = target->getContentSize();
    Rect rect = Rect(0, 0, s.width, s.height);
    
    if (target == this->attackkey){
        if (rect.containsPoint(locationInNode)){
            CCLOG("attack!!!!");
            this->attackswitch = true;
            
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/fireballsound.mp3");
            
            this->fireball->setPosition(this->hero->getPositionX()+10, this->hero->getPositionY());
            auto fire = MoveTo::create(2,Point(origin.x+visibleSize.width+fireball->getContentSize().width, hero->getPositionY()));
            fireball ->runAction(fire);
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->attackkey);
            return true;
        }
        else {
            return false;
        }
    }
    else if (target == this->music){
        if (rect.containsPoint(locationInNode)){
            CCLOG("play and pause music touched");
            if (CocosDenshion::SimpleAudioEngine::getInstance()->isBackgroundMusicPlaying() == true) {
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseAllEffects();
                this->playdeath = false;
                this->playhit = false;
                this->playdeadsound = false;
                this->playrock = false;
                this->bosshiton = false;
                this->wingame = false;
                return true;
            }
            else {
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeAllEffects();
                this->playdeath = true;
                this->playhit = true;
                this->playdeadsound = true;
                this->playrock = true;
                this->bosshiton = true;
                this->wingame = true;
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
                Director::getInstance()->pause();
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
                CocosDenshion::SimpleAudioEngine::getInstance()->pauseAllEffects();
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->attackkey);
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->upkey);
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->downkey);
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->leftkey);
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->rightkey);
                return true;
            }
            else {
                Director::getInstance()->resume();
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
                CocosDenshion::SimpleAudioEngine::getInstance()->resumeAllEffects();
                Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->attackkey);
                Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->upkey);
                Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->downkey);
                Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->leftkey);
                Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->rightkey);
                return true;
            }
        }
        else {
            return false;
        }
    }
    else if (target == this->upkey){
        if (rect.containsPoint(locationInNode)){
            CCLOG("UP");
            auto goup = MoveBy::create(0.5, Point(0, 50));
            this->hero->runAction(goup);
            return true;
        }
        else {
            return false;
        }
    }
    else if (target == this->downkey){
        if (rect.containsPoint(locationInNode)){
            CCLOG("DOWN");
            auto godown = MoveBy::create(0.5, Point(0, -50));
            this->hero->runAction(godown);
            return true;
        }
        else {
            return false;
        }
    }
    else if (target == this->leftkey){
        if (rect.containsPoint(locationInNode)){
            CCLOG("LEFT");
            auto goleft = MoveBy::create(0.5, Point(-50, 0));
            this->hero->runAction(goleft);
            return true;
        }
        else {
            return false;
        }
    }
    else if (target == this->rightkey){
        if (rect.containsPoint(locationInNode)){
            CCLOG("RIGHT");
            auto goright = MoveBy::create(0.5, Point(50, 0));
            this->hero->runAction(goright);
            return true;
        }
        else {
            return false;
        }
    }
    else {
        return false;
    }
}

void Boss::resetfireball() {
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    CCLOG("reset fire ball");
    this->fireball->stopAllActions();
    this->fireball->setPosition(origin.x-this->fireball->getContentSize().width, origin.y+visibleSize.height/2);
    Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->attackkey);
}

void Boss::movedeathball() {
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    if (this->playdeath == true) {
        CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/bossdeathsound.mp3");
    }
    
    this->death1->setPosition(this->boss->getPositionX()-20, this->boss->getPositionY()+10);
    auto movedeath1 = MoveTo::create(1.8, Point(origin.x-this->death1->getContentSize().width, this->boss->getPositionY()));
    auto doneCallBack1 = CallFunc::create( [=]() {this->resetdeath();});
    auto sequence1 = Sequence::create(movedeath1, doneCallBack1, NULL);
    this->death1->runAction(sequence1);
}

void Boss::resetdeath() {
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CCLOG("reset death 1");
    this->death1->stopAllActions();
    this->death1->setPosition(origin.x+visibleSize.width+this->death1->getContentSize().width, origin.y+visibleSize.height/2);
}

void Boss::heroanimation() {
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

void Boss::bossanimation() {
    CCLOG("boss animation called");
    
    Vector<SpriteFrame*> animFrames(4);
    char str[100] = {0};
    for(int i = 1; i <= 4; i++)
    {
        sprintf(str, "boss/boss%d.png",i);
        auto frame = SpriteFrame::create(str,Rect(0,0,100,100));
        animFrames.pushBack(frame);
    }
    
    auto animation = Animation::createWithSpriteFrames(animFrames, 0.3f);
    bossanimate = RepeatForever::create(Animate::create(animation));
    boss->runAction(bossanimate);
}

void Boss::update(float delta) {
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    //check hero attack boss
    if (this->fireball != NULL) {
        cocos2d::Rect attackbox = this->fireball->getBoundingBox();
        cocos2d::Rect bossbox = Rect(this->boss->getPositionX(), this->boss->getPositionY(), this->boss->getContentSize().width/2, this->boss->getContentSize().height/2);
        if (bossbox.intersectsRect(attackbox) && this->attackswitch == true) {
            CCLOG("boss is damaged!!!");
            this->attackswitch = false;
            
            //boss got hit
            if (this->bosshiton == true) {
                CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/dragonsound.mp3");
            }
            
            auto flash = Blink::create(0.6, 3);
            this->boss->runAction(flash);
            
            //change boss hp
            this->bosshpX = this->bosshpX - 0.01;
            this->bosshealth = this->bosshealth - 2000;
            this->texthp2->setString(std::to_string(bosshealth));
            this->bosshp->setScaleX(bosshpX);
            this->resetfireball();
        }
        else if (this->fireball->getPositionX() > visibleSize.width) {
            this->attackswitch = false;
            this->resetfireball();
        }
    }
    
    //check boss attack hero
    if (this->death1 != NULL) {
        cocos2d::Rect deathbox = Rect(this->death1->getPositionX(), this->death1->getPositionY(), this->death1->getContentSize().width/2, this->death1->getContentSize().height/2);
        cocos2d::Rect herobox = Rect(this->hero->getPositionX(), this->hero->getPositionY(), this->hero->getContentSize().width/3, this->hero->getContentSize().height/3);
        
        if (deathbox.intersectsRect(herobox) && deathballon == true) {
            CCLOG("hit by deathball");
            this->resetdeath();
            
            if (this->playhit == true) {
                CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/hit.mp3");
            }
            
            this->herohpX = this->herohpX - 0.005;
            this->herohealth = this->herohealth - 500;
            this->texthp1->setString(std::to_string(herohealth));
            this->herohp->setScaleX(herohpX);
            auto flash = Blink::create(0.3, 3);
            this->hero->runAction(flash);
        }
    }
    
    //check hero collide with boss
    if (hero != NULL) {
        cocos2d::Rect herobox = Rect(this->hero->getPositionX(), this->hero->getPositionY(), this->hero->getContentSize().width/3, this->hero->getContentSize().height/3);
        cocos2d::Rect bossbox = Rect(this->boss->getPositionX(), this->boss->getPositionY(), this->boss->getContentSize().width/2, this->boss->getContentSize().height/2);
        
        if (herobox.intersectsRect(bossbox) && intersectboss == true) {
            intersectboss = false;
            
            //turn off all switches
            bossattackon = false;
            deathballon = false;
            intersect = false;
            bosskilled = false;
            herokilled = false;
            hitwalls = false;
            
            if (this->playdeadsound == true) {
                CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/death.mp3");
            }
            
            this->texthp1->setString(std::to_string(0));
            this->herohp->setScaleX(0);
            
            hero->stopAction(heroanimate);
            
            auto moveup = MoveTo::create(0.3, Point(hero->getPositionX()+10, hero->getPositionY()+50));
            auto movedown = MoveTo::create(0.5, Point(hero->getPositionX()+10, origin.y-hero->getContentSize().height-10));
            hero->runAction(Sequence::create(moveup, movedown, NULL));
            
            auto togrey = TintTo::create(0.1, 128*65536, 128*256, 128);
            hero->runAction(togrey);
            
            //pause attack key and other keys
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->attackkey);
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->upkey);
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->downkey);
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->leftkey);
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->rightkey);
            
            CallFunc *runCallback = CallFunc::create(CC_CALLBACK_0(Boss::GoToEndGameScene, this));
            this->runAction(Sequence::create(DelayTime::create(3), runCallback, NULL));
        }
    }
    
    //boss attack scene
    gametime--;
    CCLOG("game time: %d", gametime);
    if (this->death1 != NULL) {
        if (gametime == 200 && bossattackon == true) {
            auto movebossup = MoveTo::create(0.5, Point(origin.x+visibleSize.width-50, origin.y+visibleSize.height/2+100));
            auto movebossforward = MoveTo::create(0.5, Point(origin.x+visibleSize.width-200, origin.y+visibleSize.height/2));
            auto movebossdown = MoveTo::create(0.5, Point(origin.x+visibleSize.width-50, origin.y+visibleSize.height/2-100));
            auto movebossback = MoveTo::create(0.5, Point(origin.x+visibleSize.width-50, origin.y+visibleSize.height/2));
            auto doneCallBack1 = CallFunc::create( [=]() {this->movedeathball();;});
            auto doneCallBack2 = CallFunc::create( [=]() {this->movedeathball();;});
            auto doneCallBack3 = CallFunc::create( [=]() {this->movedeathball();;});
            auto delay1 = DelayTime::create(2.5);
            auto delay2 = DelayTime::create(2.5);
            auto delay3 = DelayTime::create(2.5);
            auto delay4 = DelayTime::create(2);
            auto bossseq = Sequence::create(movebossup, doneCallBack1, delay1, movebossforward, doneCallBack2, delay2, movebossdown, doneCallBack3, delay3, movebossback, delay4, NULL);
            this->boss->runAction(bossseq);
        }
        else if (gametime == 300) {
            auto movewallup = MoveTo::create(0.1, Point(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2+20));
            auto movewalldown = MoveTo::create(0.1, Point(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2-20));
            auto movewallback = MoveTo::create(0.1, Point(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2));
            auto wallseq = Sequence::create(movewallup, movewalldown, movewallback, NULL);
            this->wall->runAction(wallseq);
            
            auto moveside1right = MoveTo::create(3, Point(origin.x+3, origin.y+visibleSize.height/2));
            this->side1->runAction(moveside1right);
            auto moveside2left = MoveTo::create(3, Point(origin.x+visibleSize.width-3, origin.y+visibleSize.height/2));
            this->side2->runAction(moveside2left);
            
            if (this->playrock == true) {
                CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/rockslidesound.mp3");
            }
        }
        else if (gametime == 202) {
            Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->upkey);
            Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->downkey);
            Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->leftkey);
            Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->rightkey);
            Director::getInstance()->getEventDispatcher()->resumeEventListenersForTarget(this->attackkey);
        }
        else if (gametime == 0) {
            gametime = 201;
        }
    }
    
    //check hit lava or spikes
    if (this->lava != NULL && this->spike != NULL) {
        cocos2d::Rect lavabox = this->lava->getBoundingBox();
        cocos2d::Rect spikebox = this->spike->getBoundingBox();
        cocos2d::Rect herobox = Rect(this->hero->getPositionX(), this->hero->getPositionY(), this->hero->getContentSize().width/3, this->hero->getContentSize().height/3);
        
        if ((herobox.intersectsRect(lavabox) || herobox.intersectsRect(spikebox)) && intersect == true) {
            //prevent check lava and spike again
            intersect = false;
            
            //stop boss attack loop
            bossattackon = false;
            
            CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
            if (this->playdeadsound == true) {
                CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/death.mp3");
            }
            
            this->texthp1->setString(std::to_string(0));
            this->herohp->setScaleX(0);
            
            this->hero->stopAction(heroanimate);
            
            auto moveup = MoveTo::create(0.3, Point(hero->getPositionX()+10, hero->getPositionY()+50));
            auto movedown = MoveTo::create(0.5, Point(hero->getPositionX()+10, origin.y-hero->getContentSize().height-10));
            hero->runAction(Sequence::create(moveup, movedown, NULL));
            
            auto togrey = TintTo::create(0.1, 128*65536, 128*256, 128);
            hero->runAction(togrey);
            
            CallFunc *runCallback = CallFunc::create(CC_CALLBACK_0(Boss::GoToEndGameScene, this));
            this->runAction(Sequence::create(DelayTime::create(3), runCallback, NULL));
        }
    }
    
    //check hit walls
    if (this->side1 != NULL && this->side2 != NULL) {
        cocos2d::Rect side1box = this->side1->getBoundingBox();
        cocos2d::Rect side2box = this->side2->getBoundingBox();
        cocos2d::Rect herobox = Rect(this->hero->getPositionX(), this->hero->getPositionY(), this->hero->getContentSize().width/3, this->hero->getContentSize().height/3);
        
        if ((herobox.intersectsRect(side1box) || herobox.intersectsRect(side2box)) && hitwalls == true) {
            if (this->playhit == true) {
                CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/hit.mp3");
            }
            
            this->herohpX = this->herohpX - 0.010;
            this->herohealth = this->herohealth - 1000;
            this->texthp1->setString(std::to_string(herohealth));
            this->herohp->setScaleX(herohpX);
            this->hero->setPosition(origin.x+150, origin.y+visibleSize.height/2);
            auto flash = Blink::create(0.3, 3);
            this->hero->runAction(flash);
        }
    }
    
    //check if boss killed or hero killed
    if (bosshealth == 0 && bosskilled == true) {
        CCLOG("----BOSS KILLED----");
        bosskilled = false;
        CocosDenshion::SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
        if (this->wingame == true) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/victory.mp3");
        }
        
        //pause attack key and other keys
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->attackkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->upkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->downkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->leftkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->rightkey);
        
        //stop check deathball
        this->deathballon = false;
        
        //set boss heath to 0
        this->texthp2->setString(std::to_string(0));
        this->bosshp->setScaleX(0);
        
        //stop boss actions and attack loop
        this->boss->stopAction(bossanimate);
        bossattackon = false;
        this->boss->stopAllActions();
        
        //move wall away and make can't check walls collision
        auto moveside1back = MoveTo::create(2, Point(origin.x-this->side1->getContentSize().width, origin.y+visibleSize.height/2));
        this->side1->runAction(moveside1back);
        auto moveside2back = MoveTo::create(2, Point(origin.x+visibleSize.width+this->side2->getContentSize().width, origin.y+visibleSize.height/2));
        this->side2->runAction(moveside2back);
        this->hitwalls = false;
        
        //fly hero out screen
        auto moveout = MoveTo::create(5, Point(origin.x+visibleSize.width+hero->getContentSize().width, origin.y+visibleSize.height/2));
        this->hero->runAction(moveout);
        
        //move away boss and tint
        auto moveup = MoveTo::create(0.3, Point(this->boss->getPositionX()-10, this->boss->getPositionY()+50));
        auto movedown = MoveTo::create(0.5, Point(this->boss->getPositionX()-10, origin.y-this->boss->getContentSize().height-10));
        this->boss->runAction(Sequence::create(moveup, movedown, NULL));
        auto togrey = TintTo::create(0.1, 128*65536, 128*256, 128);
        this->boss->runAction(togrey);
        
        CallFunc *runCallback = CallFunc::create(CC_CALLBACK_0(Boss::GoToWinnerScene, this));
        this->runAction(Sequence::create(DelayTime::create(5.0), runCallback, NULL));
    }
    else if (herohealth == 0 && herokilled == true) {
        CCLOG("----HERO KILLED----");
        herokilled = false;
        if (this->playdeadsound == true) {
            CocosDenshion::SimpleAudioEngine::sharedEngine()->playEffect("gamemusics/death.mp3");
        }
        
        //pause attack key and other keys
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->attackkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->upkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->downkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->leftkey);
        Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(this->rightkey);
        
        //disable lava and spike check
        intersect = false;
        
        //reduce hero hp
        this->texthp1->setString(std::to_string(0));
        this->herohp->setScaleX(0);
        
        //stop hero animation
        hero->stopAction(heroanimate);
        
        //move hero fall out screen and tint
        auto moveup = MoveTo::create(0.3, Point(hero->getPositionX()+10, hero->getPositionY()+50));
        auto movedown = MoveTo::create(0.5, Point(hero->getPositionX()+10, origin.y-hero->getContentSize().height-10));
        hero->runAction(Sequence::create(moveup, movedown, NULL));
        auto togrey = TintTo::create(0.1, 128*65536, 128*256, 128);
        hero->runAction(togrey);
        
        CallFunc *runCallback = CallFunc::create(CC_CALLBACK_0(Boss::GoToEndGameScene, this));
        this->runAction(Sequence::create(DelayTime::create(3), runCallback, NULL));
    }
    
    //check if hero fire and boss death collide
    if (this->fireball != NULL && this->death1 != NULL) {
        cocos2d::Rect attackbox = this->fireball->getBoundingBox();
        cocos2d::Rect deathbox = Rect(this->death1->getPositionX(), this->death1->getPositionY(), this->death1->getContentSize().width/2, this->death1->getContentSize().height/2);
        
        if (attackbox.intersectsRect(deathbox)) {
            this->resetfireball();
        }
    }
}

void Boss::GoToEndGameScene() {
    auto scene = EndGame::createScene();
    Director::getInstance()->pushScene(TransitionFade::create(2.0f, scene));
}

void Boss::GoToWinnerScene() {
    auto scene = winner::createScene();
    Director::getInstance()->pushScene(TransitionFade::create(2.0f, scene));
}







