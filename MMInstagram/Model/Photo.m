//
//  Photo.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "Photo.h"


@implementation Photo

@dynamic caption;
@dynamic user;
@dynamic imageFile;
@dynamic likes;
@dynamic comments;
@dynamic imageData;
@dynamic likeCount;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Photo";
}


@end
