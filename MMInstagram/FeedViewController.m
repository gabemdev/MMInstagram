//
//  FeedViewController.m
//  MMInstagram
//
//  Created by Michael Sevy on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "FeedViewController.h"
#import "InstagramPost.h"

@interface FeedViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;


@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getInstagramFeedData];


}


- (void)getInstagramFeedData{

    NSURL *url = [NSURL URLWithString:@"https://intutvp.herokuapp.com/v1.0/search/facebook/p%5C!nk"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {

            self.dataArray = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]objectForKey:@"data"];
            //NSLog(@"%@", self.dataArray);//this works but cannot get a piece of data to print out by itself

            NSDictionary *item = [self.dataArray objectAtIndex:0];
            NSDictionary *caption = item[@"caption"];
            NSLog(@"%@", caption[@"text"]);
//            NSArray *dataArray = [InstagramPost postFromArray:jsonArray];
//            NSDictionary *dict = dataArray[0];
//            NSDictionary *comments = dict[@"comments"];
//            NSDictionary *created = comments[@"created_time"];
//
//            NSLog(@"%@", created);
            //NSLog(@"%@", dataArray);
            //complete(dataArray);
        }
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];

    //NSDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
            //NSLog(@"%@", item);
    //NSDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
    //NSLog(@"%@", item);
    NSDictionary *caption = item[@"caption"];
    NSDictionary *from = caption[@"caption"];

    //InstagramPost *name =
    cell.textLabel.text = from[@"username"];
    return cell;
}

- (NSArray *)postFromArray:(NSArray *)incomingArray{
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:incomingArray.count];


    for (NSDictionary *d in incomingArray) {
        InstagramPost *ig = [[InstagramPost alloc]initWithDictionary:d];
        [newArray addObject:ig];
    }
    return newArray;
}



- (NSDate *) dateFromNumber:(NSNumber *)number
{
    NSNumber *time = [NSNumber numberWithDouble:([number doubleValue] )];
    NSTimeInterval interval = [time doubleValue];
    return  [NSDate dateWithTimeIntervalSince1970:interval];
    
}



@end
