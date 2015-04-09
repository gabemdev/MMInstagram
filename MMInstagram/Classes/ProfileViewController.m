//
//  ProfileViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProfile];
}

- (void)getProfile {
    PFUser *current = [PFUser currentUser];
    if (current) {
        self.nameLabel.text = current[@"name"];
        PFFile *imageData = [current objectForKey:@"profileImage"];
        [imageData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                self.profileImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
}

#pragma mark - UIImagePickerDelegate
//- (void)promptForCamera {
//    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
//}
//
//- (void)promptForPhotoRoll {
//    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    [self.profileImageView setImage:image];
//    self.selectedImage = image;
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}
//
//- (IBAction)selectPic:(UITapGestureRecognizer *)sender {
//    UIActionSheet *actionSheet = nil;
//    actionSheet = [[UIActionSheet alloc]initWithTitle:nil
//                                             delegate:self cancelButtonTitle:nil
//                               destructiveButtonTitle:nil
//                                    otherButtonTitles:nil];
//
//    // only add avaliable source to actionsheet
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
//        [actionSheet addButtonWithTitle:@"Photo Library"];
//    }
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//        [actionSheet addButtonWithTitle:@"Camera Roll"];
//    }
//
//    [actionSheet addButtonWithTitle:@"Cancel"];
//    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
//
//    [actionSheet showInView:self.navigationController.view];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex != actionSheet.cancelButtonIndex) {
//        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
//            [self promptForPhotoRoll];
//        } else {
//            [self promptForCamera];
//        }
//    }
//}
//
//
//- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
