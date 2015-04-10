//
//  Comment.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@dynamic  comment;
@dynamic user;
@dynamic photo;
@dynamic objectId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Comment";
}

@end
