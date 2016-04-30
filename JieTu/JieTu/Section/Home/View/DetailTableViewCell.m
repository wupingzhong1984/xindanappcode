//
//  DetailTableViewCell.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "ShopModel.h"
@implementation DetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 61.5, 61.5)];
        self.detailLeftImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_detailLeftImageView];
        self.detailNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_detailLeftImageView.frame)+15, 16, K_UIScreenWidth-CGRectGetMaxX(_detailLeftImageView.frame)-25, 16)];
        _detailNameLabel.textAlignment = NSTextAlignmentLeft;
        _detailNameLabel.font = [UIFont systemFontOfSize:16];
        _detailNameLabel.textColor = UIColorFromRGB(0x25252f);
        _detailNameLabel.alpha = 0.7;
        
        [self.contentView addSubview:_detailNameLabel];
        
        UIImageView * addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.detailNameLabel.frame), CGRectGetMaxY(self.detailNameLabel.frame)+10, 13, 13)];
        addImageView.image = [UIImage imageNamed:@"address_line.png"];
        [self.contentView addSubview:addImageView];
        
        self.detailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_detailNameLabel.frame)+17, CGRectGetMaxY(_detailNameLabel.frame)+10, K_UIScreenWidth-CGRectGetMinX(_detailNameLabel.frame)-17, 12)];
        _detailAddressLabel.textAlignment = NSTextAlignmentLeft;
        _detailAddressLabel.font = [UIFont systemFontOfSize:12];
        _detailAddressLabel.textColor = UIColorFromRGB(0x25252f);
        _detailAddressLabel.alpha = 0.7;
        [self.contentView addSubview:_detailAddressLabel];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, K_UIScreenWidth, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xcccccc);
        [self.contentView addSubview:line];

    }
    
    return self;
    
    
}

-(void)setShopModel:(ShopModel *)shopModel{
    if (_shopModel != shopModel) {
        _shopModel = shopModel;
        NSString * url = [[shopModel.img firstObject] objectForKey:@"imgUrl"];
        [self.detailLeftImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"detailDefault.png"]];
        self.detailNameLabel.text = shopModel.shopName;
        self.detailAddressLabel.text = shopModel.address;
        
    }
    
}

- (void)clearInfos{
    self.detailLeftImageView.image = nil;
    self.detailNameLabel.text = @"";
    self.detailAddressLabel.text = @"";
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
