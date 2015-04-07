//
//  Photo.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject<NSCoding>

@property NSString *photosID;
@property BOOL isFavorite;
@property UIImage *image;
@property CLLocationCoordinate2D coordinate;
@property NSURL *imageURL;
@property NSDate *imageData;
@property NSString *user;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (UIImage *)favoriteIndicator;

@end
