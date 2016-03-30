#import "SpriteFactory.h"

@implementation SpriteFactory

+ (SKSpriteNode *)newBird
{
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"bird-1"];
    SKTexture *f2 = [SKTexture textureWithImageNamed:@"bird-2"];
    SKTexture *f3 = [SKTexture textureWithImageNamed:@"bird-3"];
    NSArray *birdAnimation = @[f1, f2, f3];
    
    SKSpriteNode *bird = [SKSpriteNode spriteNodeWithTexture:f1];
    bird.name = @"bird";
    
    SKAction *flying = [SKAction animateWithTextures:birdAnimation timePerFrame:0.08];
    [bird runAction:[SKAction repeatActionForever:flying]];
    
    return bird;
}

+ (SKSpriteNode *)newBackButton
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"button-back"];
    node.name = @"button-back";
    
    return node;
}

+ (SKSpriteNode *)newStart
{
    SKSpriteNode *start = [SKSpriteNode spriteNodeWithImageNamed:@"button-start"];
    start.name = @"button-start";
    
    return start;
}

+ (SKSpriteNode *)newLeader
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"leader"];
    node.name = @"leader";
    
    return node;
}

+ (SKSpriteNode *)newGetReady
{
    SKSpriteNode *getReady = [SKSpriteNode spriteNodeWithImageNamed:@"get-ready"];
    getReady.name = @"get-ready";
    
    return getReady;
}

+ (SKSpriteNode *)newGameOverSprite
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"game-over"];
    node.name = @"game-over";
    
    return node;
}

+ (SKSpriteNode *)newMenu
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"menu"];
    node.name = @"menu";
    
    return node;
}

+ (SKSpriteNode *)newBackround
{
    SKSpriteNode *backrgound = [SKSpriteNode spriteNodeWithImageNamed:@"background1"];

    return backrgound;
}

+ (SKSpriteNode *)newBottom
{
    SKSpriteNode *bottom = [SKSpriteNode spriteNodeWithImageNamed:@"bottom"];
    bottom.name = @"bottom";
    
    return bottom;
}

+ (SKSpriteNode *)newPipeWithOption:(PipeOption)option
{
    SKSpriteNode *pipe;
    
    switch (option) {
        case UpperPipe:
            pipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe-upper"];
            break;
            
        case BottomPipe:
            pipe = [SKSpriteNode spriteNodeWithImageNamed:@"pipe-bottom"];
            break;
    }
    
    return pipe;
}

+ (SKSpriteNode *)newInfo
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"info"];
    node.size = CGSizeMake(25, 25);
    node.name = @"info";
    
    return node;
}

+ (SKSpriteNode *)newReleaseMenu
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"release-menu"];
    node.name = @"release-menu";
    
    return node;
}

+ (SKSpriteNode *)newMedalWithBestScore:(NSUInteger)score
{
    SKSpriteNode *node;
    
    if (score < 10)
    {
        node = nil;
    }
    if (score >= 10 && score < 20)
    {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"10-points"];
    }
    else if (score >= 20 && score < 30)
    {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"20-points"];
    }
    else if (score >= 30 && score < 40)
    {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"30-points"];
    }
    else if (score >= 40)
    {
        node = [SKSpriteNode spriteNodeWithImageNamed:@"40-points"];
    }
    node.name = @"medal";
    
    return node;
}

+ (SKSpriteNode *)newFlappyBird
{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"flappy-bird"];
    node.name = @"flappy-bird";
    
    return node;
}

@end
