//
//  UILabel+MyLabel.h
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MyLabel)

+ (instancetype)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(int)font;
@end
