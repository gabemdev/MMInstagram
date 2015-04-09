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
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property PFFile *photoFile;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImageView.image = self.image;
    self.commentTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveImage:(UIButton *)sender {

    // If the user used the camera, then save the image to the photo library.
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    }

    // Upload the image to Parse.
    NSData *imageData = UIImagePNGRepresentation(self.image);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
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
                        NSLog(@"Error: %@", error);
                    } else {
                        NSLog(@"Photo save in background");
                    }
                }];
                NSLog(@"Activeity save in background");

            }];
        }
        NSLog(@"Imagefile save in background");
//        [self performSegueWithIdentifier:@"unwindFromPostPhotoVC" sender:self];
        self.tabBarController.selectedIndex = 0;
    }];


//    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
//    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
//
//    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.05f);
//    self.photoFile = [PFFile fileWithData:imageData];
//
//    [photo setObject:self.photoFile forKey:@"PhotoZ"];
//    [photo setObject:[PFUser currentUser].objectId forKey:@"PhotoPoster"];
//    [photo setObject:self.commentTextField.text forKey:@"PhotoDescription"];
//
//    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        [photo setObject:activity.objectId forKey:@"PhotoActivityId"];
//
//        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error) {
//                NSLog(@"Error: %@", error.localizedDescription);
//            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                [alert show];
//
//                double delayInSeconds = 1.0;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [alert dismissWithClickedButtonIndex:0 animated:YES];
//                });
//                [self dismissViewControllerAnimated:YES completion:^{
//                    [self.tabBarController setSelectedIndex:0];
//                }];
//            }
//        }];
//    }];
}
@end
