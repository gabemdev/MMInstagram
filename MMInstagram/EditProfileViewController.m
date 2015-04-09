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

@interface EditProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bioTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
//@property (nonatomic) UIImage *selectedImage;
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
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self saveData];
//    return YES;
//}
//
//

- (void)loadFields {
    PFUser *current = [PFUser currentUser];
        self.nameTextField.text = current[@"name"];
        self.usernameTextField.text = current[@"username"];
//        PFFile *imageData = [current objectForKey:@"profileImage"];
//        [imageData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        self.profileImageView.image = [UIImage imageWithData:data];
}


- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
//    if (!self.isEditSelected) {
//        sender.title = @"Done";
//        [self.selectedCharacter setValue:self.nameTextField.text forKey:@"name"];
//        [self.selectedCharacter setValue:self.actorTextField.text forKey:@"actor"];
//        [self.selectedCharacter setValue:self.genderTextField.text forKey:@"gender"];
//
//        NSNumber *seat = [NSNumber numberWithInt:(int)self.seatTextField.text.integerValue];
//        [self.selectedCharacter setValue:seat forKey:@"seat"];
//
//        [self.moc save:nil];
//    } else {
//        sender.title = @"Edit";
//    }
//
//    self.nameTextField.enabled = !self.isEditSelected;
//    self.actorTextField.enabled = !self.isEditSelected;
//    self.seatTextField.enabled = !self.isEditSelected;
//    self.isEditSelected = !self.isEditSelected;

}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == self.nameTextField)
//    {
//        [self.selectedCharacter setValue:self.nameTextField.text forKey:@"name"];
//    }
//    if (textField == self.actorTextField) {
//        [self.selectedCharacter setValue:self.actorTextField.text forKey:@"actor"];
//    }
//    if (textField == self.seatTextField) {
//
//        NSNumber *seat = [NSNumber numberWithInt:(int)self.seatTextField.text.integerValue];
//        [self.selectedCharacter setValue:seat forKey:@"seat"];
//    }
//    if (textField == self.genderTextField) {
//        [self.selectedCharacter setValue:self.genderTextField.text forKey:@"gender"];
//    }
//
//    [self.moc save:nil];
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
//- (void)saveData
//{
//    [self.nameTextField resignFirstResponder];
//    [self.usernameTextField resignFirstResponder];
//
//    if ([self.nameTextField.text length] > 0 && [self.usernameTextField.text length] > 0) {
//        self.name = self.nameLabel.text = self.nameTextField.text;
//        self.city.stateOrProvince = self.stateOrProvinceLabel.text = self.stateOrProvinceTextField.text;
//    }
//}
//
//
//



//
//#pragma mark - UItextField
//
//- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
//    if (!self.isEditSelected) {
//        sender.title = @"Done";
//        [self.selectedCharacter setValue:self.nameTextField.text forKey:@"name"];
//        [self.selectedCharacter setValue:self.actorTextField.text forKey:@"actor"];
//        [self.selectedCharacter setValue:self.genderTextField.text forKey:@"gender"];
//
//        NSNumber *seat = [NSNumber numberWithInt:(int)self.seatTextField.text.integerValue];
//        [self.selectedCharacter setValue:seat forKey:@"seat"];
//
//        [self.moc save:nil];
//    } else {
//        sender.title = @"Edit";
//    }
//
//    self.nameTextField.enabled = !self.isEditSelected;
//    self.actorTextField.enabled = !self.isEditSelected;
//    self.seatTextField.enabled = !self.isEditSelected;
//    self.genderTextField.enabled = !self.isEditSelected;
//    self.isEditSelected = !self.isEditSelected;
//
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == self.nameTextField)
//    {
//        [self.selectedCharacter setValue:self.nameTextField.text forKey:@"name"];
//    }
//    if (textField == self.actorTextField) {
//        [self.selectedCharacter setValue:self.actorTextField.text forKey:@"actor"];
//    }
//    if (textField == self.seatTextField) {
//
//        NSNumber *seat = [NSNumber numberWithInt:(int)self.seatTextField.text.integerValue];
//        [self.selectedCharacter setValue:seat forKey:@"seat"];
//    }
//    if (textField == self.genderTextField) {
//        [self.selectedCharacter setValue:self.genderTextField.text forKey:@"gender"];
//    }
//
//    [self.moc save:nil];

@end
