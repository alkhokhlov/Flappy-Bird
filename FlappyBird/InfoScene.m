#import "InfoScene.h"
#import "SpriteFactory.h"
#import "MenuScene.h"

@interface InfoScene ()

@property (nonatomic, strong) SKAction *moving;

@end

@implementation InfoScene

- (void)didMoveToView:(SKView *)view
{
    [self createSceneContents];
}

- (void)createSceneContents
{
    [self configureActions];
    
    [self addChild: [self backround]];
    [self addChild: [self newReleaseMenu]];
    [self addChild: [self newBackButton]];
    [self spawnBottomsWithPlacementOption:BeginingOfScreen];
    [self spawnBottomsWithPlacementOption:EndOfScreen];
}

- (void)configureActions
{
    self.moving = [SKAction moveBy:CGVectorMake(-140, 0) duration:1.0];
}

- (SKSpriteNode *)newReleaseMenu
{
    SKSpriteNode *menu = [SpriteFactory newReleaseMenu];
    menu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    menu.zPosition = 5;
    
    return menu;
}

- (SKSpriteNode *)newBackButton
{
    SKSpriteNode *back = [SpriteFactory newBackButton];
    back.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
    back.zPosition = 5;
    
    return back;
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
        
        if ([node.name isEqualToString:@"button-back"])
        {
            SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:0.5];
            MenuScene *menu = [[MenuScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
            [self.view presentScene:menu transition:transition];
        }
    }
}

@end
