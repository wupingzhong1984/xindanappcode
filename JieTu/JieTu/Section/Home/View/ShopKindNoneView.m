//
//  ShopKindNoneView.m
//  JieTu
//
//  Created by 开发者 on 15/11/16.
//  Copyright © 2015年 meself. All rights reserved.
//

#import "ShopKindNoneView.h"

@implementation ShopKindNoneView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-30, 0, 60, 60)];
        imageView.image = [UIImage imageNamed:@"shopkindNone.png"];
        [self addSubview:imageView];
        
        self.midLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+16, frame.size.width, 16)];
        _midLabel.textAlignment = NSTextAlignmentCenter;
        _midLabel.textColor = UIColorFromRGB(0x808080);
        _midLabel.font = [UIFont systemFontOfSize:16];
        _midLabel.text = @"心愿单空空如也";
        [self addSubview:_midLabel];
        
        self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(frame.size.width/2-50, CGRectGetMaxY(_midLabel.frame)+80, 100, 44);
        [_bottomButton setTitle:@"去添加" forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:16];

        [_bottomButton setTitleColor:UIColor_25252f forState:UIControlStateNormal];
        _bottomButton.layer.cornerRadius = 3;
        _bottomButton.layer.borderWidth = 0.5;
        _bottomButton.layer.borderColor = UIColorFromRGB(0x9e9e9e).CGColor;
        [self addSubview:_bottomButton];
    
    }
    return self;
}

@end
