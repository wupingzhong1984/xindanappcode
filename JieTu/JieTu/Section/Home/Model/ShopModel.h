//
//  ShopModel.h
//  JieTu
//
//  Created by 开发者 on 15/11/3.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property(nonatomic, strong)NSString * shopId;
@property(nonatomic, strong)NSString * shopName;
@property(nonatomic, strong)NSString * tel;
@property(nonatomic, strong)NSString * address;
@property(nonatomic, strong)NSString * level;
@property(nonatomic, strong)NSString * brief;
@property(nonatomic, strong)NSString * location;
@property(nonatomic, strong)NSString * love;
@property(nonatomic, strong)NSString * perCost;

@property(nonatomic, strong)NSArray * img;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
