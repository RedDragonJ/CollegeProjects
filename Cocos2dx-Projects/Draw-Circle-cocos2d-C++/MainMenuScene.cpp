#include "MainMenuScene.h"

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
    if( !LayerColor::initWithColor(Color4B(255,255,255,255))) {
        return false;
    }
    
    //DrawCircle (xPosition, yPosition, radius, ColorR, ColorG, ColorB, PixelSize);
    this->DrawCircle(150, 250, 80, 0, 0.5, 0.9, 5.0);
    this->DrawCircle(320, 250, 80, 0.1, 0.1, 0.1, 5.0);
    this->DrawCircle(490, 250, 80, 1.0, 0, 0, 5.0);
    this->DrawCircle(235, 150, 80, 1.0, 0.9, 0, 5.0);
    this->DrawCircle(405, 150, 80, 0, 0.7, 0, 5.0);
	
    return true;
}

void MainMenu::DrawCircle(int PosX, int PosY, int radius, float r, float g, float b, float pixelSize) {
    Point origin = Director::getInstance()->getVisibleOrigin();
    
    int x = radius;
    int y = 0;
    int radiusfixer = 1-x;
    
    while (x>=y) {
        auto draw1 = DrawNode::create();
        addChild(draw1);
        Color4F color1 = Color4F(r, g, b, 1.0);
        draw1 -> drawDot(origin + Point(x+PosX, y+PosY), pixelSize, color1 );
        auto draw2 = DrawNode::create();
        addChild(draw2);
        Color4F color2 = Color4F(r, g, b, 1.0);
        draw2 -> drawDot(origin + Point(y+PosX, x+PosY), pixelSize, color2 );
        auto draw3 = DrawNode::create();
        addChild(draw3);
        Color4F color3 = Color4F(r, g, b, 1.0);
        draw3 -> drawDot(origin + Point(-x+PosX, y+PosY), pixelSize, color3 );
        auto draw4 = DrawNode::create();
        addChild(draw4);
        Color4F color4 = Color4F(r, g, b, 1.0);
        draw4 -> drawDot(origin + Point(-y+PosX, x+PosY), pixelSize, color4 );
        auto draw5 = DrawNode::create();
        addChild(draw5);
        Color4F color5 = Color4F(r, g, b, 1.0);
        draw5 -> drawDot(origin + Point(-x+PosX, -y+PosY), pixelSize, color5 );
        auto draw6 = DrawNode::create();
        addChild(draw6);
        Color4F color6 = Color4F(r, g, b, 1.0);
        draw6 -> drawDot(origin + Point(-y+PosX, -x+PosY), pixelSize, color6 );
        auto draw7 = DrawNode::create();
        addChild(draw7);
        Color4F color7 = Color4F(r, g, b, 1.0);
        draw7 -> drawDot(origin + Point(x+PosX, -y+PosY), pixelSize, color7 );
        auto draw8 = DrawNode::create();
        addChild(draw8);
        Color4F color8 = Color4F(r, g, b, 1.0);
        draw8 -> drawDot(origin + Point(y+PosX, -x+PosY), pixelSize, color8 );
        
        y++;
        
        if (radiusfixer<0) {
            radiusfixer += 2*y+1;
        }
        else {
            x--;
            radiusfixer += 2*(y-x)+1;
        }
    }
}

















