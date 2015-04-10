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

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    PFObject *photo = self.photo;
//    PFFile *file = [photo objectForKey:@"imageFile"];

    //self.commentImage.image = self.photo; //image passed from main VC
    self.commentArray = [NSMutableArray new];
    NSLog(@"Comment Page");

    [self checkUser];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.commentTableView addSubview:self.refreshControl];
    //[self.refreshControl addTarget:self action:@selector(retrieveComments) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    //[self retrieveComments];
}


//adds to the array
- (IBAction)onAddCommentButtonTapped:(UIButton *)sender {

    if ([self.commentTextField.text length] > 0) {
        [self.commentArray addObject:self.commentTextField.text];
        [self.commentTableView reloadData];
        self.commentTextField.text = nil;
        [self.commentTextField resignFirstResponder];
        NSLog(@"%@", self.commentArray);
    } else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Text" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

        //alertView.tag = indexPath.row;
        [alertView show];
    }
}

- (void)checkUser {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser[@"name"]);

    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];

    cell.textLabel.text = [self.commentArray objectAtIndex:indexPath.row];
    //cell.imageView.image = //user picture
    return cell;
}


@end
