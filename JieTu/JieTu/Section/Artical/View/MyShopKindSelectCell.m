//
//  MyShopKindSelectCell.m
//  JieTu
//
//  Created by 开发者 on 15/11/4.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "MyShopKindSelectCell.h"
#import "ShopKindModel.h"
@implementation MyShopKindSelectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth-40, 46)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

-(void)setShopKindModel:(ShopKindModel *)shopKindModel{
    if (shopKindModel) {
        _shopKindModel = shopKindModel;
        self.titleLabel.text = shopKindModel.shopKindName;
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
