//
//  PhotoDetailViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "PhotoDetailTableViewCell.h"

@interface PhotoDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property PFObject *photo;
@property NSMutableArray *photoArray;
@property PFFile *photoFile;
@property PFQuery *query;
@property NSMutableArray *likes;
@property NSArray *tempLikeArray;
@property NSArray *userArray;
@property PFUser *searchedUser;


@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate


@end
