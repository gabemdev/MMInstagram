//
//  EditProfileViewController.m
//  MMInstagram
//
//  Created by andrew dahle on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;
@property (weak, nonatomic) IBOutlet UITextField *bioTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

//@property (weak, nonatomic) IBOutlet UIImageView *characterImageView;
//@property (nonatomic) UIImage *selectedImage;
@property BOOL isEditSelected;

@end
@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditSelected = NO;
    self.nameTextField.enabled = self.isEditSelected;
    self.usernameTextField.enabled = self.isEditSelected;
    self.websiteTextField.enabled = self.isEditSelected;
    self.bioTextField.enabled = self.isEditSelected;
    self.phoneTextField.enabled = self.isEditSelected;
}

//- (void)loadFields {
//    self.nameTextField.text = [self.selectedCharacter valueForKey:@"name"];
//    self.actorTextField.text = [self.selectedCharacter valueForKey:@"actor"];
//    self.seatTextField.text = [NSString stringWithFormat:@"%@",[self.selectedCharacter valueForKey:@"seat"]];
//    self.genderTextField.text = [self.selectedCharacter valueForKey:@"gender"];
//    self.characterImageView.image = [UIImage imageWithData:[self.selectedCharacter valueForKey:@"image"]];
//}



@end
