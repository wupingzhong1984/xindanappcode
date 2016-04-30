//
//  ShareView.m
//  JieTu
//
//  Created by 开发者 on 15/11/4.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.shareLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareLeftButton.frame = CGRectMake(frame.size.width/4-25, 35, 50, 40);
        _shareLeftButton.backgroundColor = [UIColor clearColor];
        [_shareLeftButton setBackgroundImage:[UIImage imageNamed:@"wechat_share.png"] forState:UIControlStateNormal];
        [self addSubview:_shareLeftButton];
        UILabel * leftLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMidX(_shareLeftButton.frame)-40, CGRectGetMaxY(_shareLeftButton.frame)+25, 80, 25) text:@"分享给朋友" textColor:UIColorFromRGB(0x25252f) font:14];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leftLabel];
        
        
        
        self.shareRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareRightButton.frame = CGRectMake(frame.size.width*3/4-25, 30, 50, 50);
        _shareRightButton.backgroundColor = [UIColor clearColor];
//        [_shareRightButton setImage:[UIImage imageNamed:@"friends-circle_share.png"] forState:UIControlStateNormal];
        [_shareRightButton setBackgroundImage:[UIImage imageNamed:@"friends-circle_share.png"] forState:UIControlStateNormal];
        [self addSubview:_shareRightButton];
        UILabel * rightLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMidX(_shareRightButton.frame)-45, CGRectGetMaxY(_shareRightButton.frame)+20, 90, 25) text:@"分享到朋友圈" textColor:UIColorFromRGB(0x25252f) font:14];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:rightLabel];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
