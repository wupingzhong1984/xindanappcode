//
//  DetailTableViewCell.h
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;
@interface DetailTableViewCell : UITableViewCell
@property(nonatomic, strong)UIImageView * detailLeftImageView;
@property(nonatomic, strong)UILabel * detailNameLabel;
@property(nonatomic, strong)UILabel * detailAddressLabel;
@property(nonatomic, strong)ShopModel * shopModel;
- (void)clearInfos;
@end
