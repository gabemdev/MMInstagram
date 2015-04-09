//
//  User.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) PFFile *profileImage;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *posts;

+ (NSString *)parseClassName;

@end
