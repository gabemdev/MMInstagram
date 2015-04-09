//
//  PhotoDetailTableViewCell.m
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "PhotoDetailTableViewCell.h"

@implementation PhotoDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.likeButton.layer.cornerRadius = 3;
    self.commentButton.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init {
    if (self = [super init]) {
        self.likeButton.layer.cornerRadius = 3;
        self.commentButton.layer.cornerRadius = 3;
    }
    return self;
}
@end
