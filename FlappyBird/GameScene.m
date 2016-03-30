#import "GameScene.h"
#import "SpriteFactory.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "Leader.h"

@interface GameScene ()

@property (nonatomic, strong) SKAction *moving;
@property (nonatomic, assign) BOOL contentCreated;
@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger bestScore;

@end

@implementation GameScene

static const uint32_t birdCategory = 0x1 << 0;
static const uint32_t pipeCategory = 0x1 << 1;
static const uint32_t bottomCategory = 0x1 << 2;

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
    }
}

- (void)createSceneContents
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bestScore = [defaults integerForKey:@"best-score"];
    
    self.contentCreated = true;
    self.gameOver = false;
    self.score = 0;
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0, -8.0);
    self.physicsWorld.contactDelegate = self;
    
    [self configureActions];
    
    [self addChild: [self backround]];
    [self showScore];
    [self spawnBottomsWithPlacementOption:BeginingOfScreen];
    [self spawnBottomsWithPlacementOption:EndOfScreen];
    [self addChild: [self newBird]];
    
    [self startGame];
}

- (void)configureActions
{
    self.moving = [SKAction moveBy:CGVectorMake(-140, 0) duration:1.0];
}

#pragma mark - Configure components

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"info-view" object:nil];
}

- (void)showLeadersBoard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leader-board" object:nil];
}

- (void)alertForGetNameOfNewScore
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Новый рекорд"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Введите имя";
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   UITextField *textfield = alert.textFields[0];
                                                   NSDictionary *dict = @{@"nickname": textfield.text,
                                                                          @"score": @(self.score/2)};
                                                   [DataManager saveObject:dict];
                                               }];
    [alert addAction:ok];
    [(ViewController *)self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showScore
{
    NSString *scoreTxt = [NSString stringWithFormat:@"%lu", (unsigned long)self.score];
    SKSpriteNode *score = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:scoreTxt]];
    score.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-150);
    score.zPosition = 5;
    score.name = @"score";
    
    [self addChild: score];
}

- (void)changeScore
{
    [self enumerateChildNodesWithName:@"score" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node removeFromParent];
     }];
    
    CGFloat widthOfDigit = 24;
    NSString *scoreTxt = [NSString stringWithFormat:@"%lu", (unsigned long)(self.score/2)];
    NSMutableArray *finalScore = [NSMutableArray arrayWithCapacity:scoreTxt.length];
    CGFloat currentX = CGRectGetMidX(self.frame) - (scoreTxt.length-1)*widthOfDigit/2.0;
    for (int i = 0; i < scoreTxt.length; i++)
    {
        NSString *digit = [scoreTxt substringWithRange:NSMakeRange(i,1)];
        SKSpriteNode *digitSprite = [SKSpriteNode spriteNodeWithImageNamed:digit];
        digitSprite.position = CGPointMake(currentX, self.frame.size.height-150);
        digitSprite.zPosition = 5;
        digitSprite.name = @"score";
        [finalScore addObject:digitSprite];
        currentX += widthOfDigit;
    }
    
    for (SKSpriteNode *node in finalScore)
    {
        [self addChild:node];
    }
}

- (void)showScoreSmall
{
    CGFloat widthOfDigit = 14;
    NSString *scoreTxt = [NSString stringWithFormat:@"%lu", (unsigned long)(self.score/2)];
    NSMutableArray *finalScore = [NSMutableArray arrayWithCapacity:scoreTxt.length];
    CGFloat currentX = CGRectGetMidX(self.frame)+50 - (scoreTxt.length-1)*widthOfDigit/2.0;
    for (int i = 0; i < scoreTxt.length; i++)
    {
        NSString *number = [scoreTxt substringWithRange:NSMakeRange(i,1)];
        NSString *digit = [NSString stringWithFormat:@"%@-s", number];
        SKSpriteNode *digitSprite = [SKSpriteNode spriteNodeWithImageNamed:digit];
        digitSprite.position = CGPointMake(currentX+20, CGRectGetMidY(self.frame)+17);
        digitSprite.zPosition = 9;
        digitSprite.alpha = 0.0;
        digitSprite.name = @"score-s";
        [finalScore addObject:digitSprite];
        currentX += widthOfDigit;
    }
    
    for (SKSpriteNode *node in finalScore)
    {
        SKAction *waiting = [SKAction waitForDuration:0.2];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];
        
        [node runAction:[SKAction sequence:@[waiting, fadeIn]]];
        
        [self addChild:node];
    }
}

- (void)showBestScoreSmall
{
    CGFloat widthOfDigit = 14;
    NSString *scoreTxt = [NSString stringWithFormat:@"%lu", (unsigned long)(self.bestScore)];
    NSMutableArray *finalScore = [NSMutableArray arrayWithCapacity:scoreTxt.length];
    CGFloat currentX = CGRectGetMidX(self.frame)+50 - (scoreTxt.length-1)*widthOfDigit/2.0;
    for (int i = 0; i < scoreTxt.length; i++)
    {
        NSString *number = [scoreTxt substringWithRange:NSMakeRange(i,1)];
        NSString *digit = [NSString stringWithFormat:@"%@-s", number];
        SKSpriteNode *digitSprite = [SKSpriteNode spriteNodeWithImageNamed:digit];
        digitSprite.position = CGPointMake(currentX+20, CGRectGetMidY(self.frame)-26);
        digitSprite.zPosition = 9;
        digitSprite.alpha = 0.0;
        digitSprite.name = @"score-s";
        [finalScore addObject:digitSprite];
        currentX += widthOfDigit;
    }
    
    for (SKSpriteNode *node in finalScore)
    {
        SKAction *waiting = [SKAction waitForDuration:0.2];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.1];
        
        [node runAction:[SKAction sequence:@[waiting, fadeIn]]];
        
        [self addChild:node];
    }
}

- (SKSpriteNode *)start
{
    SKSpriteNode *start = [SpriteFactory newStart];
    start.zPosition = 7;
    start.position = CGPointMake(CGRectGetMidX(self.frame)-70,
                                 CGRectGetMidY(self.frame)-150);
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *move = [SKAction moveToY:CGRectGetMidY(self.frame)-100 duration:0.2];
    
    [start runAction:[SKAction group:@[fadeIn, move]]];
    
    return start;
}

- (SKSpriteNode *)newLeader
{
    SKSpriteNode *leader = [SpriteFactory newLeader];
    leader.zPosition = 7;
    leader.position = CGPointMake(CGRectGetMidX(self.frame)+70,
                                  CGRectGetMidY(self.frame)-150);
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *move = [SKAction moveToY:CGRectGetMidY(self.frame)-105 duration:0.2];
    
    [leader runAction:[SKAction group:@[fadeIn, move]]];
    return leader;
}

- (SKSpriteNode *)gameOverSprite
{
    SKSpriteNode *node = [SpriteFactory newGameOverSprite];
    node.zPosition = 8;
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame)+150);
    node.alpha = 0.0;
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *move = [SKAction moveToY:CGRectGetMidY(self.frame)+100 duration:0.2];
    
    [node runAction:[SKAction group:@[fadeIn, move]]];
    
    return node;
}

- (SKSpriteNode *)newMenu
{
    SKSpriteNode *node = [SpriteFactory newMenu];
    node.zPosition = 8;
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame)+50);
    
    node.alpha = 0.0;
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *move = [SKAction moveToY:CGRectGetMidY(self.frame) duration:0.2];
    
    [node runAction:[SKAction group:@[fadeIn, move]]];
    
    return node;
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

- (SKSpriteNode *)newBottomWithOption:(BottomOption)option
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
    bottom.physicsBody.categoryBitMask = bottomCategory;
    bottom.physicsBody.contactTestBitMask = bottomCategory | birdCategory;
    bottom.physicsBody.collisionBitMask = bottomCategory | birdCategory;
    
    return bottom;
}

- (void)spawnBottomsWithPlacementOption:(BottomOption)option
{
    SKSpriteNode *bottom = [self newBottomWithOption:option];
    
    [bottom runAction:[SKAction repeatActionForever:self.moving]];
    
    [self addChild:bottom];
}

- (SKSpriteNode *)newBird
{
    SKSpriteNode *bird = [SpriteFactory newBird];
    bird.zPosition = 6;
    bird.position = CGPointMake(CGRectGetMidX(self.frame)-75,
                                CGRectGetMidY(self.frame));
    bird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bird.frame.size];
    bird.physicsBody.usesPreciseCollisionDetection = YES;
    bird.physicsBody.affectedByGravity = NO;
    bird.physicsBody.dynamic = YES;
    bird.physicsBody.mass = 1.0;
    bird.physicsBody.categoryBitMask = birdCategory;
    bird.physicsBody.collisionBitMask = birdCategory | pipeCategory | bottomCategory;
    bird.physicsBody.contactTestBitMask = birdCategory | pipeCategory | bottomCategory;
    
    return bird;
}

- (SKSpriteNode *)newPipeWithOption:(PipeOption)option
{
    SKSpriteNode *pipe = [SpriteFactory newPipeWithOption:option];
    
    switch (option) {
        case UpperPipe:
            pipe.zPosition = 2;
            break;
            
        case BottomPipe:
            pipe.zPosition = 3;
            break;
    }
    pipe.name = @"pipesBeforeBird";
    pipe.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe.size];
    pipe.physicsBody.usesPreciseCollisionDetection = YES;
    pipe.physicsBody.affectedByGravity = NO;
    pipe.physicsBody.dynamic = NO;
    pipe.physicsBody.categoryBitMask = pipeCategory;
    pipe.physicsBody.collisionBitMask = birdCategory | pipeCategory;
    pipe.physicsBody.contactTestBitMask = birdCategory | pipeCategory;
    
    return pipe;
}

- (void)spawnPipes
{
    SKSpriteNode *pipeUpper = [self newPipeWithOption:UpperPipe];
    float positionX = self.frame.size.width+26;
    float positionY = (float)self.frame.size.height+arc4random()%150-160;
    pipeUpper.position = CGPointMake(positionX,
                                     positionY);
    
    SKSpriteNode *pipeBottom = [self newPipeWithOption:BottomPipe];
    pipeBottom.position = CGPointMake(positionX,
                                      positionY-pipeUpper.frame.size.height-100);
    
    [pipeUpper runAction:[SKAction repeatActionForever:self.moving]];
    [pipeBottom runAction:[SKAction repeatActionForever:self.moving]];
    
    [self addChild:pipeUpper];
    [self addChild:pipeBottom];
}

- (void)newMedal
{
    SKSpriteNode *medal = [SpriteFactory newMedalWithBestScore:self.score/2];
    if (medal != nil)
    {
        medal.position = CGPointMake(CGRectGetMidX(self.frame)-67, CGRectGetMidY(self.frame)-4);
        medal.zPosition = 10;
        [self addChild: medal];
    }
}

#pragma mark - Game

- (void)startGame
{
    [self enumerateChildNodesWithName:@"bird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node.physicsBody applyImpulse:CGVectorMake(0, -node.physicsBody.velocity.dy+400)];
     }];
    
    SKAction *actionPipes = [SKAction sequence: @[
                                                  [SKAction waitForDuration:1.5],
                                                  [SKAction performSelector:@selector(spawnPipes) onTarget:self]
                                                  ]];
    [self runAction:[SKAction repeatActionForever:actionPipes]];
    
    SKSpriteNode *bird = (SKSpriteNode *)[self childNodeWithName:@"bird"];
    bird.physicsBody.affectedByGravity = YES;
}

- (void)gameOverActions
{
    [self removeAllActions];
    
    [self enumerateChildNodesWithName:@"pipesBeforeBird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node removeAllActions];
     }];
    [self enumerateChildNodesWithName:@"pipesAfterBird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node removeAllActions];
     }];
    [self enumerateChildNodesWithName:@"bottom" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node removeAllActions];
     }];
    [self enumerateChildNodesWithName:@"bird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node removeAllActions];
     }];
    [self enumerateChildNodesWithName:@"score" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         [node removeFromParent];
     }];
    if (!self.gameOver)
    {
        [self runAction:[SKAction playSoundFileNamed:@"hit.m4a" waitForCompletion:YES]];
        [self runAction:[SKAction playSoundFileNamed:@"die.m4a" waitForCompletion:YES]];

        [self addChild: [self gameOverSprite]];
        [self addChild: [self newMenu]];
        [self addChild: [self start]];
        [self addChild: [self newLeader]];
        [self showScoreSmall];
        [self showBestScoreSmall];
        
        if (self.score/2 > self.bestScore)
        {
            self.bestScore = self.score/2;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:self.bestScore forKey:@"best-score"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(alertForGetNameOfNewScore) withObject:nil afterDelay:0.6];
            });
        }
        [self performSelector:@selector(newMedal) withObject:nil afterDelay:0.6];
        self.gameOver = true;
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = (SKSpriteNode *)contact.bodyA.node;
        secondBody = (SKSpriteNode *)contact.bodyB.node;
    }
    else
    {
        firstBody = (SKSpriteNode *)contact.bodyB.node;
        secondBody = (SKSpriteNode *)contact.bodyA.node;
    }
    
    if (firstBody.physicsBody.categoryBitMask == birdCategory && secondBody.physicsBody.categoryBitMask == pipeCategory)
    {
        [self gameOverActions];
    }
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

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"pipesBeforeBird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         SKSpriteNode *bird = (SKSpriteNode *)[self childNodeWithName:@"bird"];
         if (node.position.x < bird.position.x)
         {
             if (bird.position.y > self.frame.size.height)
             {
                 [self gameOverActions];
             }
             else
             {
                 node.name = @"pipesAfterBird";
                 self.score++;
                 if (self.score%2 == 0)
                 {
                     [self runAction:[SKAction playSoundFileNamed:@"point.m4a" waitForCompletion:NO]];
                     [self changeScore];
                 }
             }
         }
     }];
    [self enumerateChildNodesWithName:@"pipesAfterBird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         if (node.position.x < -26)
         {
             [node removeFromParent];
         }
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.gameOver)
    {
        [self enumerateChildNodesWithName:@"bird" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
         {
             [node.physicsBody applyImpulse:CGVectorMake(0, -node.physicsBody.velocity.dy+400)];
             [self runAction:[SKAction playSoundFileNamed:@"wing.m4a" waitForCompletion:NO]];
         }];
    }
    
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
                SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:0.5];
                GameScene *game = [[GameScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
                [self.view presentScene: game transition:transition];
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