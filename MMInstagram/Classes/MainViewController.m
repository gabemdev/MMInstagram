//
//  MainViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:NO];
}




#pragma mark - Accessor Methods



#pragma mark - Helper Methods
- (void)checkUser {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}
- (IBAction)onLogoutButtonTapped:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];

}

@end
