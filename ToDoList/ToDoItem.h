//
//  ToDoItem.h
//  ToDoList
//
//  Created by William Liu on 2/22/16.
//  Copyright © 2016 William Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject <NSCoding>

@property NSNumber *itemId;
@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;
@property NSDate *completionDate;
- (void)assignCreationDate;
- (void)markAsCompleted:(BOOL)isComplete;
+ (NSURL *)getArchivingPaths;

@end
