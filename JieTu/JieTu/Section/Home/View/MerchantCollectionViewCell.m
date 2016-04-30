//
//  MerchantCollectionViewCell.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "MerchantCollectionViewCell.h"

@implementation MerchantCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.merchantImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenWidth*2/3)];
        [self.contentView addSubview:_merchantImageView];
        _merchantImageView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
