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
//    if (self.selectedImage == nil) {
//        self.imagePicker = [[UIImagePickerController alloc] init];
//        self.imagePicker.delegate = self;
//        self.imagePicker.allowsEditing = YES;
//
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            [self promptForCamera];
//        }
//        else {
//            [self promptForPhotoRoll];
//        }
//
//        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
//        [self presentViewController:self.imagePicker animated:YES completion:nil];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.imagePickerLoaded) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self promptForCamera];
        }];
        UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self promptForPhotoRoll];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:takePhotoAction];
        [alertController addAction:choosePhotoAction];
        [alertController addAction:cancelAction];

        [self.tabBarController presentViewController:alertController animated:YES completion:nil];
    }

//    if (self.selectedImage == nil) {
//        self.imagePicker = [[UIImagePickerController alloc] init];
//        self.imagePicker.delegate = self;
//        self.imagePicker.allowsEditing = YES;
//
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            [self promptForCamera];
//        }
//        else {
//            [self promptForPhotoRoll];
//        }
//
//        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
//        [self presentViewController:self.imagePicker animated:YES completion:nil];
//    }

}

#pragma mark - UIImagePickerControllerDelegate

- (void)promptForCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerLoaded = YES;
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = NO;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"There is no camera on this device.");
    }
}

- (void)promptForPhotoRoll {
    self.imagePickerLoaded = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = NO;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)resetImagePicker {
    self.imagePickerLoaded = NO;
    self.imagePicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selected = [self resizeImage:info[UIImagePickerControllerOriginalImage] toWidth:320.0 andHeight:480.0];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoReview"])
    {
        PostViewController *postPhotoVC = segue.destinationViewController;
        postPhotoVC.image = self.selectedImage;
        postPhotoVC.imagePicker = self.imagePicker;
    }
}

- (IBAction)unwindFromPostPhotoVC:(UIStoryboardSegue *)segue
{
    [self resetImagePicker];
    self.tabBarController.selectedIndex = 0;
}

-(UIImage*)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resizedImage;
}

@end
