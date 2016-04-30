//
//  UIButton+MyButton.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "UIButton+MyButton.h"

@implementation UIButton (MyButton)

+ (instancetype)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(int)font{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    if (titleColor) {
        
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    return btn;
    
}






@end
