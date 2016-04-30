//
//  ShopKindModel.h
//  JieTu
//
//  Created by 开发者 on 15/11/3.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopKindModel : NSObject

@property(nonatomic, strong)NSString * shopKindId;
@property(nonatomic, strong)NSString * shopKindName;
@property(nonatomic, strong)NSString * img;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
