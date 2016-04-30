//
//  HomeCollectionViewCell.h
//  JieTu
//
//  Created by 樊鹏举 on 15/12/19.
//  Copyright © 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopKindModel.h"
@interface HomeCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView * backImageView;
@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UIButton * modifyBtn;

@property(nonatomic, strong)ShopKindModel * shopKindModel;
@end
