//
//  UILabel+MyLabel.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "UILabel+MyLabel.h"

@implementation UILabel (MyLabel)

+ (instancetype)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(int)font{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    return label;
    
}

//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        self.font = [UIFont fontWithName:@"FZLanTingHei-EL-GBK" size:5];
//    }
//    return self;
//}


@end
