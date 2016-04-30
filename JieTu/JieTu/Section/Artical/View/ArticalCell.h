//
//  ArticalCell.h
//  JieTu
//
//  Created by 开发者 on 15/11/2.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;
@interface ArticalCell : UITableViewCell

@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UIButton * collectButton;
@property(nonatomic, strong)ShopModel * shopModel;


@end
