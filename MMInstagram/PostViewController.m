//
//  PostViewController.m
//  MMInstagram
//
//  Created by andrew dahle on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "PostViewController.h"
@import Parse;
#import "Photo.h"
#import "User.h"
#import "Comment.h"
@import QuartzCore;

@interface PostViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property PFFile *photoFile;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImageView.image = self.image;
    self.commentTextField.delegate = self;
    self.commentTextField.layer.cornerRadius = 3;
    self.commentTextField.layer.borderColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00].CGColor;
    self.commentTextField.layer.borderWidth = 1;
    self.commentTextField.layer.masksToBounds = YES;
//    self.uploadButton.layer.cornerRadius = 3;
}


- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        self.tabBarController.selectedIndex = 0;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Actions
- (IBAction)saveImage:(UIButton *)sender {

    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    }

    NSData *imageData = UIImagePNGRepresentation(self.image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            Photo *photo = [Photo object];
            photo.caption = self.commentTextField.text;
            photo.imageFile = imageFile;
            photo.user = [PFUser currentUser];
            PFObject *activity = [PFObject objectWithClassName:@"Activity"];
            [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [photo setObject:activity.objectId forKey:@"PhotoActivityId"];
                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:cancelAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }];
        }
        if (succeeded) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            self.tabBarController.selectedIndex = 0;
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];

}
@end
