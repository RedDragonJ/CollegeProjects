#ifndef __Game__InfiniteParallaxNode__
#define __Game__InfiniteParallaxNode__

#include "cocos2d.h"

class InfiniteParallaxNode : public cocos2d::ParallaxNode
{
public:
    static InfiniteParallaxNode* create();
    void updatePosition();
};

#endif /* defined(__Game__InfiniteParallaxNode__) */
