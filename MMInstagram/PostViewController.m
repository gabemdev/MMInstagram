//
//  PostViewController.m
//  MMInstagram
//
//  Created by andrew dahle on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "PostViewController.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "User.h"
#import "Comment.h"

@interface PostViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property PFFile *photoFile;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImageView.image = self.imageToPost;
    self.commentTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveImage:(UIButton *)sender {
    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];

    NSData *imageData = UIImagePNGRepresentation(self.imageToPost);
    self.photoFile = [PFFile fileWithData:imageData];

    [photo setObject:self.photoFile forKey:@"PhotoZ"];
    [photo setObject:[PFUser currentUser].objectId forKey:@"PhotoPoster"];
    [photo setObject:self.commentTextField.text forKey:@"PhotoDescription"];

    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [photo setObject:activity.objectId forKey:@"PhotoActivityId"];

        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];

            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
            [self dismissViewControllerAnimated:YES completion:^{
                [self.tabBarController setSelectedIndex:0];
            }];
        }];
    }];
}
@end
