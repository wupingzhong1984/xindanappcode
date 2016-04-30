//
//  ShopKindModel.m
//  JieTu
//
//  Created by 开发者 on 15/11/3.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ShopKindModel.h"

@implementation ShopKindModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (dic) {
        self.shopKindId = [dic objectForKey:@"shopKindId"];
        self.shopKindName = [dic objectForKey:@"shopKindName"];
        self.img = [dic objectForKey:@"img"];

    }
    return self;
}
@end
