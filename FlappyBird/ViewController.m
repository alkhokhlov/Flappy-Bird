#import "ViewController.h"
#import "MenuScene.h"
#import "DataManager.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLeadersBoard)
                                                 name:@"leader-board"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    MenuScene *menu = [[MenuScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    SKView *spriteView = (SKView *)self.view;
    [spriteView presentScene: menu];
}

- (BOOL)prefersStatusBarHidden
{
    return  YES;
}

- (void)showLeadersBoard
{
    [DataManager fetchDataWithCompletionHander:^(id data)
     {
         NSUInteger i = 0;
         NSMutableString *leaders = [NSMutableString new];
         for (Leader *leader in data)
         {
             i++;
             NSString *text;
             if (i == 1)
             {
                 text = [NSString stringWithFormat:@"%lu. %@ = %@", (unsigned long)i, leader.nickname, leader.score];
             }
             else
             {
                 text = [NSString stringWithFormat:@"\n%lu. %@ = %@", (unsigned long)i, leader.nickname, leader.score];
             }
             [leaders appendString:text];
         }
         if (i == 0)
         {
             [leaders appendString:@"Поиграйте чтобы поставить новый рекорд"];
         }
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Зал славы"
                                                                        message:leaders
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
         [alert addAction:ok];
         [(ViewController *)self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
     }];
}

@end
