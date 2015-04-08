//
//  Photo.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Photo : PFObject

@property NSString *caption;
@property PFFile *imageFile;
@property User *user;
@property NSString *username;
@property NSString *comment;
@property PFRelation *userWhoLike;
@property PFRelation *comments;
@property PFRelation *hasthags;

//+ (NSString *)parseClassName;
//
//- (void)savePhotoWithImage:(UIImage *)image caption:(NSString *)caption withUser:(User *)user withCompletion:(void(^)(NSError *error))complete;
//- (UIImage *)getImage;
//- (void)getImageWithCompletion:(void(^)(UIImage *image))completion;

@end
