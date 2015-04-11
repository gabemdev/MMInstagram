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
@property NSMutableArray *photos;
@property NSMutableArray *likes;
@property Photo *photo;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkUser];
    self.photos = [NSMutableArray new];
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
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PhotoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Photo *photo = self.photos[indexPath.row];
    cell.commentButton.tag = indexPath.row;
    cell.likeButton.tag = indexPath.row;
    PFFile *file = [photo objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            cell.detailImageView.image = [UIImage imageWithData:data];
            cell.likesLabel.text = [NSString stringWithFormat:@"%lu likes", (unsigned long)self.likes.count];
        }
    }];

    NSString *activity = [photo objectForKey:@"PhotoActivityId"];
    [self getLikeCountwithObject:activity];


    cell.commentLabel.text = [NSString stringWithFormat:@"#%@", [photo objectForKey:@"caption"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 420;
}


#pragma mark - Accessor Methods
- (void)retrievePhotos {
    self.photos = [NSMutableArray new];
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (Photo *photo in objects) {
                [self.photos addObject:photo];
            }
            [self.tableView reloadData];
        }];
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }
}

- (void)getLikeCountwithObject:(NSString *)activity {
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [PFQuery queryWithClassName:@"Like"];
        [query whereKey:@"ActivityId" equalTo:activity];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.likes = objects.mutableCopy;
        }];
    }
}

- (void)checkUser {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {

    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }    else if ([segue.identifier isEqualToString:@"showComments"]){

        UIButton *selected = sender;
        CommentViewController *cvc = segue.destinationViewController;
        cvc.photo = self.photos[selected.tag];
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
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
    NSInteger section = 0;
    if (self.likes.count == 0) {
        PFObject *photo = self.photos[section];
        NSString *activityId = [photo objectForKey:@"PhotoActivityId"];
        PFObject *like = [PFObject objectWithClassName:@"Like"];
        [like setValue:[PFUser currentUser].objectId forKey:@"LikingUserId"];
        [like setValue:activityId forKey:@"ActivityId"];
        [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [self.likes addObject:like];
                [self.tableView reloadData];
            }
        }];
    }


}

@end
