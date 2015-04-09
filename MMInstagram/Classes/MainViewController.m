//
//  MainViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoDetailTableViewCell.h"
#import "CommentViewController.h"
#import "Photo.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property NSArray *photos;
@property NSMutableArray *likes;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkUser];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(retrievePhotos) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self retrievePhotos];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //Image
    PFObject *photo = self.photos[indexPath.section];
    PFFile *file = [photo objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            cell.detailImageView.image = [UIImage imageWithData:data];
        }
    }];


    NSString *activity = [photo objectForKey:@"PhotoActivityId"];
//    [self getLikeCountwithObject:activity];

    cell.likesLabel.text = [NSString stringWithFormat:@"%lu likes", (unsigned long)self.likes.count];
    cell.commentButton.tag = indexPath.section;

    cell.likeButton.tag = indexPath.section;
    cell.commentLabel.text = [NSString stringWithFormat:@"#%@", [photo objectForKey:@"caption"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 420;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photos.count;
}

#pragma mark - Accessor Methods
- (void)retrievePhotos {
    NSMutableArray *posts = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            for (Photo *photo in objects) {
                [posts addObject:photo];
            }
            self.photos = posts.mutableCopy;
            [self.tableView reloadData];

        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)getLikeCountwithObject:(NSString *)activity {
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"ActivityId" equalTo:activity];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likes = objects.mutableCopy;
    }];
}

#pragma mark - Helper Methods
- (void)checkUser {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser[@"name"]);
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }    else if ([segue.identifier isEqualToString:@"showComments"]){

        CommentViewController *cvc = segue.destinationViewController;
        cvc.photo = self.photos[sender.tag];
    }
}

- (IBAction)onLogoutButtonTapped:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];

}

- (IBAction)tapComments:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showComments" sender:self];
}

- (IBAction)likeButtonTapped:(id)sender {
    NSInteger section;
    if (self.likes.count == 0) {
        PFObject *photo = self.photos[section];
        NSString *activityId = [photo objectForKey:@"PhotoActivityId"];
        //created a new class: Like
        PFObject *like = [PFObject objectWithClassName:@"Like"];

        [like setValue:[PFUser currentUser].objectId forKey:@"LikingUserId"];
        [like setValue:activityId forKey:@"ActivityId"];
        [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                [self.likes addObject:like];
                [self.tableView reloadData];
            }
        }];
    }
}

@end
