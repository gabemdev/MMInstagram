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
@property (nonatomic) BOOL imagePickerLoaded;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self activateCamera];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)activateCamera {
    if (!self.imagePickerLoaded) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self promptForCamera];
        }];
        UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self promptForPhotoRoll];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.tabBarController setSelectedIndex:0];
        }];

        [alertController addAction:takePhotoAction];
        [alertController addAction:choosePhotoAction];
        [alertController addAction:cancelAction];

        [self.tabBarController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)promptForCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerLoaded = YES;
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There is no camera in this device!" preferredStyle:UIAlertControllerStyleAlert];;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)promptForPhotoRoll {
    self.imagePickerLoaded = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)resetImagePicker {
    self.imagePickerLoaded = NO;
    self.imagePicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selected = [self resizeImage:info[UIImagePickerControllerOriginalImage] toWidth:800.0 andHeight:646.0];
    self.selectedImage = selected;

    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.selectedImage, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"photoReview" sender:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
    [self resetImagePicker];
}


#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photoReview"]) {
        PostViewController *postPhotoVC = segue.destinationViewController;
        postPhotoVC.image = self.selectedImage;
        postPhotoVC.imagePicker = self.imagePicker;
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)unwindFromPostPhotoVC:(UIStoryboardSegue *)segue {
    [self resetImagePicker];
    self.tabBarController.selectedIndex = 0;
}


#pragma mark - Accessor methods
-(UIImage*)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resizedImage;
}

#pragma mark - Actions
- (IBAction)onCameraButtonPressed:(id)sender {
    [self resetImagePicker];
    [self activateCamera];
}

@end
