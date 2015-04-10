//
//  Comment.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) NSString *objectId;


+ (NSString *)parseClassName;


@end
