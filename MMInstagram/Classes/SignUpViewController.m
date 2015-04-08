//
//  SignUpViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "SignUpViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

#define PHOTO_LIBRART_BUTTON_TITLE @"Photo Library"
#define PHOTO_ALBUM_BUTTON_TITLE @"Camera Roll"
#define CAMERA_BUTTON_TITLE @"Camera"
#define CANCEL_BUTTON_TITLE @"Cancel"

@interface SignUpViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>
@property (nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic, assign) id currentResponder;
@property (nonatomic) UIActionSheet *actionSheet;

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;
- (void)uploadImage:(NSData *)imageData;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPic:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.profileImageView addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
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
    [self dismissViewControllerAnimated:YES completion:^{
        [self displayPickedMedia:info];
    }];
}

#pragma mark - Action Sheet
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.actionSheet = nil;

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
    controller.navigationBar.barTintColor = [UIColor colorWithRed:0.92 green:0.38 blue:0.38 alpha:1.00];
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

#pragma mark - Accessor Methods
- (void)uploadImage:(NSData *)imageData {
    PFFile *imageFIle = [PFFile fileWithName:@"profile.jpg" data:imageData];

    [imageFIle saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFObject *userPhoto = [PFObject objectWithClassName:@"profilePhoto"];
        [userPhoto setObject:imageFIle forKey:@"imageFile"];

        userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

        PFUser *user = [PFUser currentUser];
        [userPhoto setObject:user forKey:@"user"];

        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

- (void)selectPic:(id)sender {
    if(!self.actionSheet){
        self.actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];

        // only add avaliable source to actionsheet
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [self.actionSheet addButtonWithTitle:PHOTO_LIBRART_BUTTON_TITLE];
        }
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [self.actionSheet addButtonWithTitle:CAMERA_BUTTON_TITLE];
        }

        [self.actionSheet addButtonWithTitle:CANCEL_BUTTON_TITLE];
        [self.actionSheet setCancelButtonIndex:_actionSheet.numberOfButtons-1];
        [self.actionSheet showFromBarButtonItem:sender animated:YES];
    }

}

#pragma mark - Helper Methods
- (void)loadUI {
    self.signUpButton.layer.cornerRadius = 3;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderColor = [UIColor colorWithRed:0.59 green:0.60 blue:0.62 alpha:1.00].CGColor;
    self.profileImageView.layer.borderWidth = 4;
}

- (void)updateProfilePic {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;

    UIImage *new = self.image;
    fileData = UIImagePNGRepresentation(new);
    fileName = @"image.png";
    fileType = @"image";
    [self.profileImageView setImage:new];
}


#pragma mark - Actions
- (IBAction)onSignUpButtonPressed:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([name length] == 0 || [username length] == 0 || [email length] == 0 || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Make sure all fields not empty!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        newUser[@"name"] = name;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                message:[error.userInfo objectForKey:@"error"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                NSLog(@"New User!");
                [self.navigationController popToRootViewControllerAnimated:YES];
                NSData *imageData = UIImageJPEGRepresentation(self.profileImageView.image, 0.05f);
                [self uploadImage:imageData];
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
        }];
    }
    
}

- (IBAction)onDismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
