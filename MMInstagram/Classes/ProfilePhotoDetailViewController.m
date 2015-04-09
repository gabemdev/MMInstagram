//
//  ProfilePhotoDetailViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/9/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ProfilePhotoDetailViewController.h"

@interface ProfilePhotoDetailViewController ()<UIGestureRecognizerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation ProfilePhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPic:)];
    tap.numberOfTapsRequired = 2;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

    PFFile *file = [self.photo objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            self.selectedImageView.image = [UIImage imageWithData:data];
        }
    }];
}



#pragma mark - Actions
- (IBAction)onEmailButtonTapped:(id)sender {
}

- (IBAction)onShareButtonTapped:(id)sender {
}

- (IBAction)selectPic:(UITapGestureRecognizer *)sender {
    NSLog(@"Tap Selected");

//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will delete your image from your feed!" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        Photo *selected = self.photo;
//        [selected deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error) {
//                NSLog(@"Error: %@", error.localizedDescription);
//            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                [alert show];
//            }
//        }];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:delete];
//        [alertController addAction:cancel];
//        [self.tabBarController presentViewController:alertController animated:YES completion:nil];
//    }];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete Photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        Photo *selected = self.photo;
        [selected deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleted" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertController addAction:delete];
    [alertController addAction:cancelAction];

    [self.tabBarController presentViewController:alertController animated:YES completion:nil];

//    UIActionSheet *actionSheet = nil;
//    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete From Favorites", @"Share", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet showInView:self.navigationController.view];
}


@end
