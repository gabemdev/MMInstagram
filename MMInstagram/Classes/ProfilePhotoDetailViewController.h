//
//  ProfilePhotoDetailViewController.h
//  MMInstagram
//
//  Created by Rockstar. on 4/9/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

@import UIKit;
#import "Photo.h"

@interface ProfilePhotoDetailViewController : UIViewController

@property Photo *photo;
@property PFObject *selected;


@end
