//
//  Photo.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

@import Foundation;

@interface Photo : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSArray *likes;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSNumber *likeCount;

+ (NSString *)parseClassName;


@end
