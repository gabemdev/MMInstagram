//
//  CameraViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "CameraViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "PostViewController.h"

@interface CameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic)UIImage *selectedImage;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.selectedImage == nil) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self promptForCamera];
        }
        else {
            [self promptForPhotoRoll];
        }

        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {

}

#pragma mark - UIImagePickerControllerDelegate

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selected = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.selectedImage = selected;

    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.selectedImage, nil, nil, nil);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"photoReview" sender:self];
}


#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoReview"])
    {
        PostViewController *postPhotoVC = segue.destinationViewController;
        postPhotoVC.imageToPost = self.selectedImage;
        postPhotoVC.selectedImageView.image = self.selectedImage;
    }
}

- (IBAction)unwindFromPostPhotoVC:(UIStoryboardSegue *)segue
{
    //
}


@end
