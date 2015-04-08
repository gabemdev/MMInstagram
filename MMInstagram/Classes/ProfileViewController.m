//
//  ProfileViewController.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) UIImage *selectedImage;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPic:)];
    [singleTap setNumberOfTapsRequired:1];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}


#pragma mark - UIImagePickerDelegate
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
    [self.profileImageView setImage:image];
    self.selectedImage = image;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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

//#pragma mark - Actions
//- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender {
//    Book *book = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Book class]) inManagedObjectContext:self.moc];
//
//    for (UITextField *textField in self.bookTextFieldCollection) {
//        switch (textField.tag) {
//            case 0: book.title = textField.text; break;
//            case 1: book.author = textField.text; break;
//            case 2: book.genre = textField.text; break;
//            default: break;
//        }
//    }
//
//    NSData *imageData = UIImagePNGRepresentation(self.selectedImage);
//    book.bookImage = imageData;
//
//    [self.selected addSuggestionsObject:book];
//    [self.moc save:nil];
//
//    for (UITextField *textFild in self.bookTextFieldCollection) {
//        textFild.text = @"";
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}
- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
