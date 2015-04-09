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

+ (instancetype)createPostWIthPhoto:(UIImage *)image {
    Photo *photo = [Photo object];
    if (photo) {
        NSData *photoData = UIImagePNGRepresentation(image);
        photo.imageFile = [PFFile fileWithData:photoData];
        photo.user = [PFUser currentUser];
        [photo saveInBackground];
    }
    return photo;
}

- (UIImage *)convertToImage {
    return [UIImage imageWithData:[self.imageFile getData]];
}

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Post";
}


@end
