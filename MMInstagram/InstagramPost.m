//
//  InstagramPost.m
//  MMInstagram
//
//  Created by Michael Sevy on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "InstagramPost.h"

@implementation InstagramPost

- (instancetype)initWithDictionary:(NSDictionary *)dictionary   {

    self = [super init];
    if (self) {
        self.username = dictionary[@"username"];
        //self.fullName = dictionary[@]
//        self.descriptionText =
//        self.profilePic =
//        self.postPicture =
//        self.likeCount =
//        self.commentCount =
//        self.commentorUsername =
//        self.commentText =



    }
    return self;
}


+ (void)getInstagramFeedData{

    NSURL *url = [NSURL URLWithString:@"https://intutvp.herokuapp.com/v1.0/search/facebook/p%5C!nk"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {

            NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]objectForKey:data];

            NSArray *dataArray = [InstagramPost postFromArray:jsonArray];

            NSLog(@"%@", dataArray);
            //complete(dataArray);
        }
    }];

}


+ (NSArray *)postFromArray:(NSArray *)incomingArray{
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:incomingArray.count];


    for (NSDictionary *d in incomingArray) {
        InstagramPost *ig = [[InstagramPost alloc]initWithDictionary:d];
        [newArray addObject:ig];
    }
    return newArray;
}



+ (NSDate *) dateFromNumber:(NSNumber *)number
{
    NSNumber *time = [NSNumber numberWithDouble:([number doubleValue] )];
    NSTimeInterval interval = [time doubleValue];
    return  [NSDate dateWithTimeIntervalSince1970:interval];

}

@end
