//
//  BottomItem.m
//  222
//
//  Created by 开发者 on 15/8/12.
//  Copyright (c) 2015年 开发者. All rights reserved.
//

#import "BottomItem.h"

@implementation BottomItem

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backgroundImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backgroundImageView];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-15)];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeCenter;
        _imageView.backgroundColor = [UIColor clearColor];
     //   [self addSubview:_imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.font = [UIFont boldSystemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = UIColor_25252f;
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}

@end
