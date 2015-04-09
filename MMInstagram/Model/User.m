//
//  User.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username;
@dynamic user;
@dynamic posts;
@dynamic email;
@dynamic profileImage;
@dynamic name;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Person";
}

@end
