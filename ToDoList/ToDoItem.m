//
//  ToDoItem.m
//  ToDoList
//
//  Created by William Liu on 2/22/16.
//  Copyright © 2016 William Liu. All rights reserved.
//

#import "ToDoItem.h"

@interface ToDoItem ()

@property (readwrite) NSDate *creationDate;

@end

@implementation ToDoItem

- (void)assignCreationDate {
    self.creationDate = [NSDate date];
}

- (void)markAsCompleted:(BOOL)isComplete {
    self.completed = isComplete;
    [self setCompletionDate];
}

- (void)setCompletionDate {
    if (self.completed) {
        self.completionDate = [NSDate date];
    } else {
        self.completionDate = nil;
    }
}

+ (NSURL *)getArchivingPaths {
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    return [documentsDirectory URLByAppendingPathComponent:@"toDoItems"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemId forKey:@"itemId"];
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeBool:self.completed forKey:@"completed"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.completionDate forKey:@"completionDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.itemId = [aDecoder decodeObjectForKey:@"itemId"];
    self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
    self.completed = [aDecoder decodeBoolForKey:@"completed"];
    self.creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
    self.completionDate = [aDecoder decodeObjectForKey:@"completionDate"];
    return self;
}

@end
