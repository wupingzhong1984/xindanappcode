//
//  DetailViewController.h
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopKindModel;
@interface DetailViewController : UIViewController
@property(nonatomic, strong)NSString * titleString;
@property(nonatomic, strong)ShopKindModel * shopKindModel;
@end
