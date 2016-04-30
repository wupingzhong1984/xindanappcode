//
//  ArticalCell.m
//  JieTu
//
//  Created by 开发者 on 15/11/2.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ArticalCell.h"
#import "ArticalHeader.h"
#import "ShopModel.h"

@implementation ArticalCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UILabel * backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 44)];
//        backLabel.backgroundColor = [UIColor blackColor];
//        backLabel.alpha = 0.7;
//        [self.contentView addSubview:backLabel];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, K_UIScreenWidth-120, 43)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        if ([WXApi isWXAppInstalled]) {
            //如果没有安装微信，肯定就没有收藏按钮
            self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _collectButton.frame = CGRectMake(K_UIScreenWidth-56, CGRectGetMinY(_titleLabel.frame)+10, 24, 24);
            _collectButton.enabled = YES;
            _collectButton.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_collectButton];
        }
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, K_UIScreenWidth-20, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setShopModel:(ShopModel *)shopModel{
    
    if (shopModel) {
        _shopModel = shopModel;
        self.titleLabel.text = shopModel.shopName;
       
        
        if ([shopModel.love isEqualToString:@"1"]) {
            
            [self.collectButton setImage:[UIImage imageNamed:@"heart_click.png"] forState:UIControlStateNormal];

        }else{
            
            [self.collectButton setImage:[UIImage imageNamed:@"heart_normal.png"] forState:UIControlStateNormal];
        }
    }
 }




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
