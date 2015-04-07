//
//  Photo.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary objectForKey:@"location"] != [NSNull null]) {
            CLLocationDegrees lat = [(NSNumber *)[[dictionary objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
            CLLocationDegrees lon = [(NSNumber *)[[dictionary objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
            self.coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
        self.photosID = dictionary[@"id"];
        self.imageURL = [NSURL URLWithString:[[[dictionary objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
        self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
        self.user = dictionary[@"user"][@"username"];
        self.isFavorite = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        CLLocationDegrees lat = [aDecoder decodeDoubleForKey:@"kLat"];
        CLLocationDegrees lon = [aDecoder decodeDoubleForKey:@"kLon"];
        self.coordinate = CLLocationCoordinate2DMake(lat, lon);
        self.photosID = [aDecoder decodeObjectForKey:@"kPostID"];
        self.imageURL = [aDecoder decodeObjectForKey:@"kImageURL"];
        self.image = [aDecoder decodeObjectForKey:@"kImage"];
        self.imageData = [aDecoder decodeObjectForKey:@"photoData"];
        self.user = [aDecoder decodeObjectForKey:@"username"];
        self.isFavorite = YES;

        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.coordinate.latitude forKey:@"kLat"];
    [aCoder encodeDouble:self.coordinate.longitude forKey:@"kLon"];
    [aCoder encodeObject:self.photosID forKey:@"kPostID"];
    [aCoder encodeObject:self.imageURL forKey:@"kImageURL"];
    [aCoder encodeObject:self.image forKey:@"kImage"];
    [aCoder encodeObject:self.imageData forKey:@"photoData"];
    [aCoder encodeObject:self.user forKey:@"username"];
}

- (UIImage *)favoriteIndicator {
    if (self.isFavorite) {
        return [UIImage imageNamed:@"feed_like_icon_pressed"];
    }
    else {
        return [UIImage imageNamed:@"feed_like_icon"];
    }
}

@end
