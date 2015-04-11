//
//  FeedCollectionViewCell.h
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

@import UIKit;

@interface FeedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *feedImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;

@end
