//
//  EditProfileViewController.m
//  MMInstagram
//
//  Created by andrew dahle on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "EditProfileViewController.h"
#import "User.h"
#import "Photo.h"
#import "SignUpViewController.h"
#import "ProfileViewController.h"
@import MobileCoreServices.UTCoreTypes;

@interface EditProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bioTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) UIImage *image;
@property BOOL isEditSelected;

@end
@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditSelected = NO;
    self.nameTextField.enabled = self.isEditSelected;
    self.usernameTextField.enabled = self.isEditSelected;
    [self loadFields];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPic:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImageView addGestureRecognizer:singleTap];
}


- (void)loadFields {
    self.user = [PFUser currentUser];
    if (self.user) {
        self.nameTextField.text = self.user[@"name"];
        self.usernameTextField.text = self.user[@"username"];
        PFFile *imageData = [self.user objectForKey:@"profileImage"];
        [imageData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                self.profileImageView.image = [UIImage imageWithData:data];
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
                self.profileImageView.layer.borderColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00].CGColor;
                self.profileImageView.layer.borderWidth = 3;
                self.profileImageView.layer.masksToBounds = YES;
            }
        }];

    }
}

#pragma mark - Actions
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    if (!self.isEditSelected) {
        sender.title = @"Done";
        self.user[@"username"] = self.usernameTextField.text;
        self.user[@"name"] = self.nameTextField.text;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                [self loadFields];
            }
        }];

    } else {
        sender.title = @"Edit";
    }
    self.nameTextField.enabled = !self.isEditSelected;
    self.usernameTextField.enabled = !self.isEditSelected;
     self.isEditSelected = !self.isEditSelected;
}

- (void)selectPic:(id)sender {
    if (!self.imagePicker) {
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

        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma mark - Camera
- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    controller.allowsEditing = YES;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    controller.allowsEditing = YES;
    controller.navigationBar.barTintColor = [UIColor whiteColor];
    controller.navigationBar.tintColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00];
    controller.navigationBar.translucent = NO;
    [self presentViewController:controller animated:YES completion:nil];
}

-(UIImage*)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resizedImage;
}

#pragma mark - Image Picker Controller Delegate

- (void) displayPickedMedia:(NSDictionary *)info{
    self.image = nil;
    if([info[UIImagePickerControllerMediaType]isEqualToString:(NSString *) kUTTypeImage]){
        UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
        if(!pickedImage){
            pickedImage = info[UIImagePickerControllerOriginalImage];
        }
        if(pickedImage) {
            self.image = pickedImage;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self resizeImage:pickedImage toWidth:320 andHeight:480];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.profileImageView.image = pickedImage;
                    [self.view layoutIfNeeded];
                });
            });
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info[UIImagePickerControllerMediaType]isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerEditedImage]];
        self.image = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImageView.image = image;
            [self.view layoutIfNeeded];
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleAndRotateImage:(UIImage *) image {
    int kMaxResolution = 320;

    CGImageRef imgRef = image.CGImage;

    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

@end
