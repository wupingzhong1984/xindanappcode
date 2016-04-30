//
//  MyShopKindSelectCell.h
//  JieTu
//
//  Created by 开发者 on 15/11/4.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopKindModel;
@interface MyShopKindSelectCell : UITableViewCell
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)ShopKindModel * shopKindModel;
@end
