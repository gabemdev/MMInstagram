//
//  PostViewController.m
//  MMInstagram
//
//  Created by andrew dahle on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "PostViewController.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "User.h"
#import "Comment.h"

@interface PostViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;





@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.thumbImage;
}
//
//- (IBAction)onPostButtonPressed:(id)sender
//{
//    Post *post = [Post createPostWithPhoto:self.imageToPost];
//    Comment *comment = nil;
//}

@end
