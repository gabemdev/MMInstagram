//
//  User.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithPFObject:(PFObject *)object {
    if (self = [super init]) {
        self.username = object[@"username"];
        self.objectID = object.objectId;
    }
    return self;
}

@end
