//
//  LoginViewController.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;



- (IBAction)onLoginButtonTapped:(id)sender;
@end
