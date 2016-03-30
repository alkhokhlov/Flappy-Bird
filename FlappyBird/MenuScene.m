#import "MenuScene.h"
#import "SpriteFactory.h"
#import "ViewController.h"
#import "DataManager.h"
#import "InfoScene.h"

@interface MenuScene ()

@property (nonatomic, strong) SKAction *moving;

@end

@implementation MenuScene

- (void)didMoveToView: (SKView *) view
{    
    [self createSceneContents];
}

- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self configureActions];
    
    [self addChild: [self start]];
    [self addChild: [self newFlappyBird]];
    [self addChild: [self newLeader]];
    [self addChild: [self getReady]];
    [self addChild: [self backround]];
    [self addChild: [self newInfo]];
    [self spawnBottomsWithPlacementOption:BeginingOfScreen];
    [self spawnBottomsWithPlacementOption:EndOfScreen];
    [self addChild: [self bird]];
}

- (void)configureActions
{
    self.moving = [SKAction moveBy:CGVectorMake(-140, 0) duration:1.0];
}

#pragma mark - Configure components

- (SKSpriteNode *)newFlappyBird
{
    SKSpriteNode *node = [SpriteFactory newFlappyBird];
    node.zPosition = 9;
    node.size = CGSizeMake(300, 80);
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame)+170);
    return node;
}

- (SKSpriteNode *)newInfo
{
    SKSpriteNode *info = [SpriteFactory newInfo];
    info.zPosition = 8;
    info.size = CGSizeMake(25, 25);
    info.position = CGPointMake(self.frame.size.width-15, self.frame.size.height-15);
    
    return info;
}

- (void)showInfoView
{
    SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:0.5];
    InfoScene *info = [[InfoScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    [self.view presentScene:info transition:transition];
}

- (void)showLeadersBoard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leader-board" object:nil];
}

- (SKSpriteNode *)start
{
    SKSpriteNode *start = [SpriteFactory newStart];
    start.zPosition = 7;
    start.position = CGPointMake(CGRectGetMidX(self.frame)-70,
                                 CGRectGetMidY(self.frame)-75);
    return start;
}

- (SKSpriteNode *)newLeader
{
    SKSpriteNode *leader = [SpriteFactory newLeader];
    leader.zPosition = 7;
    leader.position = CGPointMake(CGRectGetMidX(self.frame)+70,
                                  CGRectGetMidY(self.frame)-80);
    return leader;
}

- (SKSpriteNode *)getReady
{
    SKSpriteNode *getReady = [SpriteFactory newGetReady];
    getReady.zPosition = 7;
    getReady.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame)+75);
    return getReady;
}

- (SKSpriteNode *)backround
{
    SKSpriteNode *backrgound = [SpriteFactory newBackround];
    backrgound.zPosition = 1;
    backrgound.size = self.frame.size;
    backrgound.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
    return backrgound;
}

- (void)spawnBottomsWithPlacementOption:(BottomOption)option
{
    SKSpriteNode *bottom = [SpriteFactory newBottom];
    bottom.zPosition = 4;
    bottom.size = CGSizeMake(self.frame.size.width+25,
                             bottom.frame.size.height);
    switch (option)
    {
        case BeginingOfScreen:
            bottom.position = CGPointMake(self.frame.size.width/2.0, bottom.size.height/2.0);
            break;
            
        case EndOfScreen:
            bottom.position = CGPointMake(self.frame.size.width+self.frame.size.width/2.0, bottom.size.height/2.0);
            break;
    }
    bottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottom.size];
    bottom.physicsBody.affectedByGravity = NO;
    bottom.physicsBody.dynamic = NO;
    
    [bottom runAction:[SKAction repeatActionForever:self.moving]];
    
    [self addChild:bottom];
}

- (SKSpriteNode *)bird
{
    SKSpriteNode *bird = [SpriteFactory newBird];
    bird.zPosition = 6;
    bird.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame));
    bird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bird.frame.size];
    bird.physicsBody.usesPreciseCollisionDetection = YES;
    bird.physicsBody.affectedByGravity = NO;
    bird.physicsBody.dynamic = YES;
    bird.physicsBody.mass = 1.0;
    
    return bird;
}

#pragma mark - Game

- (void)startGame
{
    SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:0.5];
    GameScene *game = [[GameScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    [self.view presentScene: game transition:transition];
}

#pragma mark - Process events

- (void)update:(NSTimeInterval)currentTime
{
    [self enumerateChildNodesWithName:@"bottom" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         if (node.position.x < -self.frame.size.width/2.0)
         {
             [self spawnBottomsWithPlacementOption:EndOfScreen];
             [node removeFromParent];
         }
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node.name isEqualToString:@"button-start"])
        {
            [self runAction:[SKAction playSoundFileNamed:@"swooshing.m4a" waitForCompletion:NO]];
            
            SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[fadeAway, remove]];
            
            [node runAction:sequence completion:^{
                [self startGame];
            }];
        }
        else if ([node.name isEqualToString:@"leader"])
        {
            [self showLeadersBoard];
        }
        else if ([node.name isEqualToString:@"info"])
        {
            [self showInfoView];
        }
    }
}

@end