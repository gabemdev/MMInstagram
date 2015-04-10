//
//  CommentViewController.h
//  MMInstagram
//
//  Created by Michael Sevy on 4/8/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface CommentViewController : UIViewController

@property UIImage *image;
@property PFObject *userImage;
@property PFObject *username;
@property Photo *photo;

@end
