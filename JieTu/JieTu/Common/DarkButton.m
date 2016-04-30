//
//  DarkButton.m
//  JieTu
//
//  Created by 开发者 on 15/11/15.
//  Copyright © 2015年 meself. All rights reserved.
//

#import "DarkButton.h"

@implementation DarkButton

+ (DarkButton *)sharedManager{
    static DarkButton *darkButton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        darkButton = [DarkButton buttonWithType:UIButtonTypeCustom];
        darkButton.frame = [UIApplication sharedApplication].keyWindow.bounds;
        darkButton.backgroundColor = [UIColor blackColor];
        darkButton.alpha = 0.7;
    });
    return darkButton;
}

@end
