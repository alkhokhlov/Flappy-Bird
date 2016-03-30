#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Leader.h"

@interface DataManager : NSObject

+ (void)fetchDataWithCompletionHander:(void (^)(id data))handler;

+ (void)saveObject:(NSDictionary *)dict;

@end
