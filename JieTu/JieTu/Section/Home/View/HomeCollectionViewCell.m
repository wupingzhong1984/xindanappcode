//
//  HomeCollectionViewCell.m
//  JieTu
//
//  Created by 樊鹏举 on 15/12/19.
//  Copyright © 2015年 meself. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation HomeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_backImageView];
        
        //添加蒙层的灰色效果
        UIView * grayView = [[UIView alloc] initWithFrame:self.bounds];
        grayView.backgroundColor = UIColor_25252f;
        grayView.alpha = 0.3;
        [_backImageView addSubview:grayView];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        
        if ([WXApi isWXAppInstalled]) {
            self.modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _modifyBtn.frame = CGRectMake(frame.size.width-40, frame.size.height-40, 40, 40);
            _modifyBtn.backgroundColor = [UIColor clearColor];
            [_modifyBtn setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
            [_modifyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.contentView addSubview:_modifyBtn];
        }
        
    }
    return self;
}

-(void)setShopKindModel:(ShopKindModel *)shopKindModel{
    if (_shopKindModel != shopKindModel) {
        self.nameLabel.text = shopKindModel.shopKindName;
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:shopKindModel.img] placeholderImage:nil];
        UIImage * image;
        if ([shopKindModel.shopKindId isEqualToString:@"COFFEE"]) {
            image = [UIImage imageNamed:@"coffee.png"];
        }else if ([shopKindModel.shopKindId isEqualToString:@"JAPAN"]) {
            image = [UIImage imageNamed:@"japanse.png"];
        }else if ([shopKindModel.shopKindId isEqualToString:@"NIGHT"]) {
            image = [UIImage imageNamed:@"nightLift.png"];
        }else if ([shopKindModel.shopKindId isEqualToString:@"CHINESE"]) {
            image = [UIImage imageNamed:@"middleFood.png"];
        }else if ([shopKindModel.shopKindId isEqualToString:@"BRUNCH"]) {
            image = [UIImage imageNamed:@"lunch.png"];
        }else if ([shopKindModel.shopKindId isEqualToString:@"WESTERN"]) {
            image = [UIImage imageNamed:@"westFood.png"];
        }
        
        if (image) {
            [self.backImageView setImage:image];
        }
        
        
        
    }
}



@end
