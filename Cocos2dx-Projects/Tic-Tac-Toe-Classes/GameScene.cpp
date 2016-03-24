#include "GameScene.h"
#include "MainMenuScene.h"

USING_NS_CC;

Scene* GameScene::createScene()
{
    auto scene = Scene::create();
    
    auto layer = GameScene::create();
    
    scene->addChild(layer);
    
    return scene;
}

bool GameScene::init()
{
    if ( !Layer::init() )
    {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    auto returnkey = MenuItemImage::create("return.png", "return.png", CC_CALLBACK_1(GameScene::GoToMainMenu, this));
    auto menu = Menu::create(returnkey, NULL);
    menu->setPosition(origin.x+50,visibleSize.height-50);
    this->addChild(menu);
    
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
    
    auto text3 = Label::createWithSystemFont("Player1", "fonts/Marker Felt.ttf", 30);
    text3->setPosition(visibleSize.width/4-80, visibleSize.height/4-100);
    text3->setColor(Color3B::YELLOW);
    this->addChild(text3);
    
    auto text4 = Label::createWithSystemFont("Player2", "fonts/Marker Felt.ttf", 30);
    text4->setPosition(visibleSize.width-80, visibleSize.height/4-100);
    text4->setColor(Color3B::YELLOW);
    this->addChild(text4);
    
    this->wall->setPosition(Point(visibleSize.width/2, visibleSize.height/2));
    this->addChild(this->wall, -1);
    
    for(int i = 0; i < 9; i++)
    {
        gridSprite[i] = Sprite::create("square.png");
        if(i==0)
        {
            gridSprite[0] -> setPosition(Point(visibleSize.width/2, visibleSize.height/2));
        }
        if(i==1)
        {
            gridSprite[1]-> setPosition(Point(visibleSize.width/2-gridSprite[1]->getContentSize().width, visibleSize.height/2));
        }
        if(i==2)
        {
            gridSprite[2]->setPosition(Point(visibleSize.width/2+ gridSprite[2]->getContentSize().width, visibleSize.height/2));
        }
        if(i==3)
        {
            gridSprite[3]->setPosition(Point(visibleSize.width/2-gridSprite[3]->getContentSize().width, visibleSize.height/2+ gridSprite[3]->getContentSize().height));
        }
        if(i==4)
        {
            gridSprite[4]->setPosition(Point(visibleSize.width/2-gridSprite[4]->getContentSize().width, visibleSize.height/2-gridSprite[4]->getContentSize().height));
        }
        if(i==5)
        {
            gridSprite[5]->setPosition(Point(visibleSize.width/2+gridSprite[5]->getContentSize().width, visibleSize.height/2+gridSprite[5]->getContentSize().height));
        }
        if(i==6)
        {
            gridSprite[6]->setPosition(Point(visibleSize.width/2+gridSprite[6]->getContentSize().width, visibleSize.height/2-gridSprite[6]->getContentSize().height));
        }
        if(i==7)
        {
            gridSprite[7]->setPosition(Point(visibleSize.width/2, visibleSize.height/2+gridSprite[7]->getContentSize().height));
        }
        if(i==8)
        {
            gridSprite[8]->setPosition(Point(visibleSize.width/2, visibleSize.height/2-gridSprite[8]->getContentSize().height));
        }
        
        this -> addChild(gridSprite[i]);
    }
    
    float rshh = this->refresh->getContentSize().height/2;
    this->refresh->setPosition(Point(visibleSize.width/2, origin.y+rshh));
    left -> setPosition(Point(origin.x+left->getContentSize().width/2+10, origin.y+left->getContentSize().height/2+10));
    right -> setPosition(Point(visibleSize.width-right->getContentSize().width/2-10, origin.y+right->getContentSize().height/2+10));
    
    _eventDispatcher->addEventListenerWithSceneGraphPriority(this->touch1().clone(), this->left);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(this->touch2().clone(), this->right);
    
    auto resetlistener = EventListenerTouchOneByOne::create();
    resetlistener->setSwallowTouches(true);
    resetlistener->onTouchBegan = CC_CALLBACK_2(GameScene::onTouchBegan, this);
    resetlistener->onTouchMoved = CC_CALLBACK_2(GameScene::onTouchMoved, this);
    resetlistener->onTouchEnded = CC_CALLBACK_2(GameScene::onTouchEnded, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(resetlistener, this->refresh);
    
    this->addChild(this->refresh);
    this->addChild(this->left, 20);
    this->addChild(this->right, 20);
    
    return true;
}

cocos2d::EventListenerTouchOneByOne GameScene::touch1() {
    auto touchListener = EventListenerTouchOneByOne::create();
    touchListener->setSwallowTouches(true);
    touchListener -> onTouchBegan = CC_CALLBACK_2(GameScene::onTouchBegan, this);
    touchListener -> onTouchMoved = CC_CALLBACK_2(GameScene::onTouchMoved, this);
    touchListener -> onTouchEnded = CC_CALLBACK_2(GameScene::onTouchEnded, this);
    
    return *touchListener;
}

cocos2d::EventListenerTouchOneByOne GameScene::touch2() {
    auto touchListener = EventListenerTouchOneByOne::create();
    touchListener->setSwallowTouches(true);
    touchListener -> onTouchBegan = CC_CALLBACK_2(GameScene::onTouchBegan, this);
    touchListener -> onTouchMoved = CC_CALLBACK_2(GameScene::onTouchMoved, this);
    touchListener -> onTouchEnded = CC_CALLBACK_2(GameScene::onTouchEnded, this);
    
    return *touchListener;
}


bool GameScene::onTouchBegan(cocos2d::Touch* touch, cocos2d::Event* event) {
    
    auto target = static_cast<Sprite*>(event->getCurrentTarget());
    Point locationInNode = target->convertToNodeSpace(touch->getLocation());
    
    Size s = target->getContentSize();
    Rect rect = Rect(0, 0, s.width, s.height);
    
    if (target == this->left){
        if (rect.containsPoint(locationInNode)){
            CCLOG("left touched");
            target->setZOrder(100);
            
            return true;
        }
        else{
            return false;
        }
    }
    else if (target == this->right){
        if (rect.containsPoint(locationInNode)){
            CCLOG("right touched");
            target->setZOrder(100);
            
            return true;
        }
        else{
            return false;
        }
    }
    else if (target == refresh){
        if (rect.containsPoint(locationInNode)){
            CCLOG("resh touched");
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return true;
    }
}

void GameScene::onTouchMoved(cocos2d::Touch* touch, cocos2d::Event* event){
    
    auto target = static_cast<Sprite*>(event->getCurrentTarget());
    
    if (target == this->left){
        CCLOG("left moved");
        auto fbmove1 = MoveTo::create(0.01, Point(touch->getLocation().x, touch->getLocation().y));
        auto fbmove2 = EaseInOut::create(fbmove1, 0);
        this->left->runAction(fbmove2);
    }
    else if (target == this->right){
        CCLOG("right moved");
        auto fbmove1 = MoveTo::create(0.01, Point(touch->getLocation().x, touch->getLocation().y));
        auto fbmove2 = EaseInOut::create(fbmove1, 0);
        this->right->runAction(fbmove2);
    }
}

void GameScene::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event){
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    auto target = static_cast<Sprite*>(event->getCurrentTarget());
    
    cocos2d::Sprite* newsprite;
    
    if (target == this->left)
    {
        CCLOG("left ended");
        if (checkbox(left) == true)
        {
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(target);
            if (TTTlogic(this->leftSprite) == true){
                _eventDispatcher->removeEventListener(this->touch1().clone());
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(right);
                auto text = Label::createWithSystemFont("GOOGLE WON!!!", "fonts/Marker Felt.ttf", 70);
                auto fadeTILE = FadeTo::create(0.8, 180);
                right -> runAction(fadeTILE);
                text->setPosition(visibleSize.width/2, visibleSize.height-200);
                text->setColor(Color3B::RED);
                this->addChild(text, 100);
            }
            else {
                if (this->checkdraw(occupySprite) == true) {
                    _eventDispatcher->removeEventListener(this->touch1().clone());
                    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(right);
                    auto text = Label::createWithSystemFont("IT'S A DRAW!!", "fonts/Marker Felt.ttf", 70);
                    text->setPosition(visibleSize.width/2, visibleSize.height-200);
                    text->setColor(Color3B::RED);
                    this->addChild(text, 100);
                    auto fadeTILE = FadeTo::create(0.8, 180);
                    right -> runAction(fadeTILE);
                }
                else {
                    newsprite =cocos2d::Sprite::create("google.png");
                    left = newsprite;
                    left -> setPosition(Point(origin.x+left->getContentSize().width/2+10, origin.y+left->getContentSize().height/2+10));
                    _eventDispatcher->addEventListenerWithSceneGraphPriority(this->touch1().clone(), right);
                    this->addChild(left, 20);
                }
            }
        }
        else
        {
            auto move1 = cocos2d::MoveTo::create(2, Point(origin.x+left->getContentSize().width/2+10, origin.y+left->getContentSize().height/2+10));
            auto move2 = cocos2d::EaseIn::create(move1, 0);
            this->left->runAction(move2);
        }
    }
    else if (target == this->right)
    {
        CCLOG("right ended");
        if (checkbox(right) == true)
        {
            Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(target);
            if (TTTlogic(this->rightSprite) == true) {
                _eventDispatcher->removeEventListener(this->touch2().clone());
                Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(left);
                auto text = Label::createWithSystemFont("FIREFOX WON!!", "fonts/Marker Felt.ttf", 60);
                auto fadeTILE = FadeTo::create(0.8, 180);
                left -> runAction(fadeTILE);
                text->setPosition(visibleSize.width/2, visibleSize.height-200);
                text->setColor(Color3B::RED);
                this->addChild(text, 100);
            }
            else {
                if (this->checkdraw(occupySprite) == true) {
                    _eventDispatcher->removeEventListener(this->touch2().clone());
                    Director::getInstance()->getEventDispatcher()->pauseEventListenersForTarget(left);
                    auto text = Label::createWithSystemFont("IT'S A DRAW!!", "fonts/Marker Felt.ttf", 60);
                    text->setPosition(visibleSize.width/2, visibleSize.height-200);
                    text->setColor(Color3B::RED);
                    this->addChild(text, 100);
                    auto fadeTILE = FadeTo::create(0.8, 160);
                    left -> runAction(fadeTILE);
                }
                else {
                    newsprite =cocos2d::Sprite::create("firefox.png");
                    right = newsprite;
                    right -> setPosition(Point(visibleSize.width-right->getContentSize().width/2-10, origin.y+right->getContentSize().height/2+10));
                    _eventDispatcher->addEventListenerWithSceneGraphPriority(this->touch2().clone(), left);
                    this->addChild(right, 20);
                }
            }
        }
        else
        {
            auto move1 = cocos2d::MoveTo::create(2, Point(visibleSize.width-right->getContentSize().width/2-10, origin.y+right->getContentSize().height/2+10));
            auto move2 = cocos2d::EaseIn::create(move1, 0);
            this->right->runAction(move2);
        }
    }
    else if (target == refresh)
    {
        this->stopAllActions();
        CCLOG("ready to change scene");
        auto callback1 = CallFunc::create([this](){this->handlerefresh();});
        auto callback2 = CallFunc::create([this](){this->newscene();});
        auto delay = DelayTime::create(1.6);
        auto seq = Sequence::create(callback1, delay, callback2, NULL);
        this->runAction(seq);
    }
}

bool GameScene::checkbox(cocos2d::Sprite* insprites){
    
    CCLOG("checking box");
    
    cocos2d::Rect spritebox = insprites->getBoundingBox();
    
    static bool isProcessingCollide = false;
    
    for(int i = 0; i < 9; i++)
    {
        if (spritebox.containsPoint(gridSprite[i] -> getPosition()))
        {
            if(occupySprite[i]!= NULL)
            {
                cocos2d::Rect gridbox = this -> gridSprite[i]-> getBoundingBox();
                cocos2d::Rect occupybox = occupySprite[i]->getBoundingBox();
                if (gridbox.intersectsRect(occupybox) && isProcessingCollide == false)
                {
                    isProcessingCollide = true;
                    CCLOG("they collided");
                    return false;
                }
            }
            else
            {
                auto move1 = cocos2d::MoveTo::create(2, gridSprite[i]->getPosition());
                auto move2 = cocos2d::EaseIn::create(move1, 0);
                insprites->runAction(move2);
                
                if(insprites== left && occupySprite[i] == NULL)
                {
                    leftSprite[i] = insprites;
                    occupySprite[i] = leftSprite[i];
                }
                if(insprites== right && occupySprite[i] == NULL)
                {
                    rightSprite[i] = insprites;
                    occupySprite[i] = rightSprite[i];
                }
                return true;
            }
        }
    }
    return false;
}

bool GameScene::TTTlogic(cocos2d::Sprite* arrayin[])
{
    if(arrayin[0] && arrayin[1] && arrayin[2])
    {
        CCLOG("WIN: 0, 1, 2");
        CCLOG("fade gridbox");
        for(int i=0; i<9; i++)
        {
            if(i != 0 && i != 1 &&i != 2)
            {
                auto fadeTILE1 = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE1);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        CCLOG("return true");
        return true;
    }
    else if(arrayin[3] && arrayin[7] && arrayin[5])
    {
        CCLOG("WIN: 3, 7, 5");
        for(int i=0; i<9; i++)
        {
            if(i != 3 && i != 7 &&i != 5)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else if(arrayin[4] && arrayin[8] && arrayin[6])
    {
        CCLOG("WIN: 4, 8, 6");
        for(int i=0; i<9; i++)
        {
            if(i != 4 && i != 8 &&i != 6)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else if(arrayin[3] && arrayin[1] && arrayin[4])
    {
        CCLOG("WIN: 3, 1, 4");
        for(int i=0; i<9; i++)
        {
            if(i != 3 && i != 1 &&i != 4)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else if(arrayin[7] && arrayin[0] && arrayin[8])
    {
        CCLOG("WIN: 7, 0, 8");
        for(int i=0; i<9; i++)
        {
            if(i != 7 && i != 0 &&i != 8)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else if(arrayin[5] && arrayin[6] && arrayin[2])
    {
        CCLOG("WIN: 5, 6, 2");
        for(int i=0; i<9; i++)
        {
            if(i != 5 && i != 6 &&i != 2)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else if(arrayin[3] && arrayin[0] && arrayin[6])
    {
        CCLOG("WIN: 3, 0, 6");
        for(int i=0; i<9; i++)
        {
            if(i != 3 && i != 0 &&i != 6)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else if(arrayin[0] && arrayin[4] && arrayin[5])
    {
        CCLOG("WIN: 0, 4, 5");
        for(int i=0; i<9; i++)
        {
            if(i != 0 && i != 4 &&i != 5)
            {
                auto fadeTILE = FadeTo::create(0.8, 160);
                this->gridSprite[i]->runAction(fadeTILE);
                CCLOG("fade other sprites");
                if (this->occupySprite[i] != NULL){
                    auto fadeTILE2 = FadeTo::create(0.8, 160);
                    this->occupySprite[i]->runAction(fadeTILE2);
                }
            }
        }
        return true;
    }
    else{
        CCLOG("is winner or draw");
        return false;
    }
}

bool GameScene::checkdraw(cocos2d::Sprite* arrayin[]) {
    
    if(arrayin[0] && arrayin[1] && arrayin[2] && arrayin[3] && arrayin[4] && arrayin[5] && arrayin[6] && arrayin[7]&& arrayin[8])
    {
        CCLOG("its draw");
        for (int i=0; i<9; i++) {
            auto fade1 = FadeTo::create(0.8, 180);
            this->gridSprite[i]->runAction(fade1);
            if (this->occupySprite[i] != NULL) {
                auto fade2 = FadeTo::create(0.8, 180);
                this->occupySprite[i]->runAction(fade2);
            }
        }
        return true;
    }
    else
    {
        CCLOG("no draw and continue");
        return false;
    }
}

void GameScene::handlerefresh() {
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    CCLOG("handle refresh");
    for (int i=0; i<sizeof(occupySprite); i++) {
        CCLOG("in for loop");
        if (occupySprite[i] != NULL) {
            CCLOG("in if for occupy");
            if (this->occupySprite[i] == this->leftSprite[i]) {
                CCLOG("check left sprite then action");
                if (occupySprite[i] != NULL) {
                auto move1 = cocos2d::MoveTo::create(1.5, Point(origin.x+left->getContentSize().width/2+10, origin.y+left->getContentSize().height/2+10));
                occupySprite[i]->runAction(move1);
                }
            }
            else if (this->occupySprite[i] == this->rightSprite[i]) {
                CCLOG("or check right sprite then action");
                if (this->occupySprite[i] != NULL) {
                auto move1 = cocos2d::MoveTo::create(1.5, Point(visibleSize.width-right->getContentSize().width/2-10, origin.y+right->getContentSize().height/2+10));
                occupySprite[i]->runAction(move1);
                }
            }
        }
    }
    for (int i=0; i<9; i++) {
        CCLOG("fade boxes");
        auto fade = cocos2d::FadeIn::create(0.8);
        this->gridSprite[i]->runAction(fade);
    }
}

void GameScene::newscene() {
    CCLOG("reset scene");
    auto newScene = GameScene::createScene();
    Director::getInstance()->replaceScene(newScene);
}

void GameScene::GoToMainMenu(cocos2d::Ref* mynewscene)
{
    auto scene = MainMenu::createScene();
    Director::getInstance()->replaceScene(scene);
}














