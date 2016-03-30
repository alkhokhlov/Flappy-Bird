#import <SpriteKit/SpriteKit.h>

typedef enum {
    UpperPipe,
    BottomPipe
}PipeOption;

typedef enum {
    BeginingOfScreen,
    EndOfScreen
}BottomOption;

@interface SpriteFactory : NSObject

+ (SKSpriteNode *)newBird;

+ (SKSpriteNode *)newBackButton;

+ (SKSpriteNode *)newStart;

+ (SKSpriteNode *)newLeader;

+ (SKSpriteNode *)newGetReady;

+ (SKSpriteNode *)newGameOverSprite;

+ (SKSpriteNode *)newMenu;

+ (SKSpriteNode *)newBackround;

+ (SKSpriteNode *)newBottom;

+ (SKSpriteNode *)newPipeWithOption:(PipeOption)option;

+ (SKSpriteNode *)newInfo;

+ (SKSpriteNode *)newReleaseMenu;

+ (SKSpriteNode *)newMedalWithBestScore:(NSUInteger)score;

+ (SKSpriteNode *)newFlappyBird;

@end
