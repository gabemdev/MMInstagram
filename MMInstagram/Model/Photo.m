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
@dynamic imageFile;
@dynamic user;
@dynamic userWhoLike;
@dynamic comments;
@dynamic hasthags;
@dynamic comment;
@dynamic username;

//
//- (void)savePhotoWithImage:(UIImage *)image caption:(NSString *)caption withUser:(User *)user withCompletion:(void (^)(NSError *))complete {
//    NSData *imageData = UIImagePNGRepresentation(image);
//    PFFile *file = [PFFile fileWithData:imageData];
//    self.imageFile = file;
//    self.caption = caption;
//    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        PFRelation *relation = [[PFUser currentUser] relationForKey:@"photos"];
//        [relation addObject:self];
//        [[PFUser currentUser] saveEventually];
//    }];
//}
//
//+ (void)getCommentsFromPhoto:(Photo *)photo withCompletion:(void(^)(NSArray *photosArray))completion {
//    PFRelation *relation = [photo relationForKey:@"comments"];
//    [relation.query addAscendingOrder:@"timeStamp"];
//    [relation.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            completion(objects);
//        } else {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];
//}



@end
