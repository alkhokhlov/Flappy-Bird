#import "DataManager.h"
#import "AppDelegate.h"

@implementation DataManager

+ (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.dataController.managedObjectContext;
    return context;
}

+ (void)fetchDataWithCompletionHander:(void (^)(id data))handler
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Leader"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:nil];
    
    handler(objects);
}

+ (void)saveObject:(NSDictionary *)dict
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Leader *leader = [NSEntityDescription insertNewObjectForEntityForName:@"Leader" inManagedObjectContext:context];
    leader.nickname = [dict objectForKey:@"nickname"];
    leader.score = [dict objectForKey:@"score"];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}

@end
