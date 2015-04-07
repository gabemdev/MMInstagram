//
//  InstagramPost.h
//  MMInstagram
//
//  Created by Michael Sevy on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPost : NSObject

@property (nonatomic, strong) NSString *username;//caption from username
@property (nonatomic, strong) NSString *fullName;//caption from fullname
@property (nonatomic, strong) NSString *descriptionText;////caption text
@property (nonatomic, strong) NSString *profilePic; //from profile_picture string from URL

@property (nonatomic, strong) NSDate *createdTime; //caption created_time nsdate from String
@property (nonatomic, strong) NSURL *postPicture; //caption link nsurl from String- they give string


//comments
@property (nonatomic, strong) NSString *likeCount;//likes  count  given as a NSNUmber so stringWithFormat
@property (nonatomic, strong) NSString *commentCount;// comments count given as a number
@property (nonatomic, strong) NSString *commentorUsername;// comments data item from username
@property (nonatomic, strong) NSString *commentText;//comments data item text





+ (NSArray *)postFromArray:(NSArray *)incomingArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (void)getInstagramFeedData;
+ (NSDate *) dateFromNumber:(NSNumber *)number;



@end
