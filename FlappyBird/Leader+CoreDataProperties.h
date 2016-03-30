//
//  Leader+CoreDataProperties.h
//  FlappyBird
//
//  Created by Alexandr on 24.03.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Leader.h"

NS_ASSUME_NONNULL_BEGIN

@interface Leader (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSNumber *score;

@end

NS_ASSUME_NONNULL_END
