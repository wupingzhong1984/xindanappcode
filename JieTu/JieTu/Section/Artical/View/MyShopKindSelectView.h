//
//  MyShopKindSelectView.h
//  JieTu
//
//  Created by 开发者 on 15/11/4.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShopKindSelectView : UIView

@property(nonatomic, strong)NSIndexPath * selectIndexPath;
@property(nonatomic, strong)UIButton * sureBtn;
-(instancetype)initWithFrame:(CGRect)frame ShopKindModelArray:(NSMutableArray *)shopKindModelArray;
@end
