//
//  MMCropView.m
//  MMInstagram
//
//  Created by Rockstar. on 4/6/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "MMCropView.h"

@interface MMCropView ()
@property (nonatomic) NSArray *horizontalLines;
@property (nonatomic) NSArray *verticalLines;

@end

@implementation MMCropView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;

        NSArray *lines = [self.horizontalLines arrayByAddingObjectsFromArray:self.verticalLines];
        for (UIView *linesView in lines) {
            [self addSubview:linesView];
        }
    }
    return self;
}

- (NSArray *)horizontalLines {
    if (!_horizontalLines) {
        _horizontalLines = [self newArrayOfFour];
    }
    return _horizontalLines;
}

- (NSArray *)verticalLines {
    if (!_verticalLines) {
        _verticalLines = [self newArrayOfFour];
    }
    return _verticalLines;
}

- (NSArray *)newArrayOfFour {
    NSMutableArray *array = [NSMutableArray new];

    for (int i  = 0; i < 4; i++) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [array addObject:view];
    }
    return array;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat thirdOfWidth = width / 3;

    for (int i = 0; i < 4; i++) {
        UIView *horizontalLine = self.horizontalLines[i];
        UIView *verticalLine = self.verticalLines[i];

        horizontalLine.frame = CGRectMake(0, (i * thirdOfWidth), width, 0.5);

        CGRect verticatlFrame = CGRectMake(i * thirdOfWidth, 0, 0.5, width);

        if (i == 3) {
            verticatlFrame.origin.x -= 0.5;
        }
        verticalLine.frame = verticatlFrame;

    }
}


@end
