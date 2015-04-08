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

@property UIImage *imageToPost;
@property UIImage *thumbImage;

@end

@implementation CameraViewController




- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showCameraController
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == NO)
    {
        return;
    }

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = NO;
    cameraUI.cameraOverlayView = nil;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}




#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];

    [self.tabBarController.delegate tabBarController:self.tabBarController shouldSelectViewController:[[self.tabBarController viewControllers] objectAtIndex:0]];
    [self.tabBarController setSelectedIndex:0];
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
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageToPost = image;
    self.thumbImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)selectPic:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = nil;
    actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                             delegate:self cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil];

    // only add avaliable source to actionsheet
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        [actionSheet addButtonWithTitle:@"Photo Library"];
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addButtonWithTitle:@"Camera Roll"];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showInView:self.navigationController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
            [self promptForPhotoRoll];
        } else {
            [self promptForCamera];
        }
    }
}






//
//---------------
//
//
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImageWriteToSavedPhotosAlbum (originalImage, nil, nil , nil);
//
//    self.imageToPost = [originalImage thumbImage:750
//                                   transparentBorder:0
//                                        cornerRadius:0
//                                interpolationQuality:kCGInterpolationHigh];
//
//    self.thumbImage = [originalImage thumbImage:100
//                                      transparentBorder:0
//                                           cornerRadius:6
//                                   interpolationQuality:kCGInterpolationDefault];
//
//    [self performSegueWithIdentifier:@"ToPostPhotoVC" sender:self];
//
//    [self dismissViewControllerAnimated:NO completion:nil]; // If user comes back from PostPhotoVC this VC will be empty
//}
//
//
#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PostToVC"])
    {
        PostViewController *postPhotoVC = segue.destinationViewController;
        postPhotoVC.imageToPost = self.imageToPost;
        postPhotoVC.thumbImage = self.thumbImage;
    }
}

- (IBAction)unwindFromPostPhotoVC:(UIStoryboardSegue *)segue
{
    //
}


@end
