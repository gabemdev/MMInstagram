//
//  Comment.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface Comment : NSObject

@property (nonatomic) NSString *commentID;
@property (nonatomic) NSNumber *time;
@property (nonatomic) NSString *commentString;
@property (nonatomic) User *user;

@end
