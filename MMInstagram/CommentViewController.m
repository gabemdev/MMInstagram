//
//  CommentViewController.m
//  MMInstagram
//
//  Created by Michael Sevy on 4/8/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
#import "MainViewController.h"
#import "Photo.h"

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property NSMutableArray *commentArray;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentArray = [NSMutableArray new];

    [self getImage];
    [self loadComments];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)getImage {
    PFFile *file = [self.photo objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.selectedImageView.image = [UIImage imageWithData:data];
        }
    }];
}

- (IBAction)onAddCommentButtonTapped:(id)sender
{
    if (![self.commentTextField.text isEqual:@""])
    {
        Comment *comment = [Comment object];
        comment.comment = self.commentTextField.text;
        comment.photo = self.photo;
        comment.user = [PFUser currentUser];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadComments];
        }];
        self.commentTextField.text = @"";
    }
}

- (void)loadComments {
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [Comment query];
        [query includeKey:@"user"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (Comment *comments in objects) {
                [self.commentArray addObject:comments];
            }
            [self.commentTableView reloadData];
        }];
    }
}

- (void)getComments {
    PFUser *user = [PFUser currentUser];
    if (user) {
        PFQuery *query = [Comment query];
        [query includeKey:@"user"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (Comment *comments in objects) {
                [self.commentArray addObject:comments];
            }
            [self.commentTableView reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];

    Comment *comment = self.commentArray[indexPath.row];
    cell.textLabel.text = comment.comment;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"By: %@", comment.user[@"name"]];
    return cell;
}


@end
