//
//  ShopModel.m
//  JieTu
//
//  Created by 开发者 on 15/11/3.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (dic) {
        self.shopId = [dic objectForKey:@"shopId"];
        self.shopName = [dic objectForKey:@"shopName"];
        self.address = [dic objectForKey:@"address"];
        self.tel = [dic objectForKey:@"tel"];
        self.level = [dic objectForKey:@"level"];
        self.brief = [dic objectForKey:@"brief"];
        self.location = [dic objectForKey:@"location"];
        self.img = [NSArray arrayWithArray:[dic objectForKey:@"img"]];
        self.perCost = [dic objectForKey:@"perCost"];
        self.love = [dic objectForKey:@"love"];

//        if ([[dic objectForKey:@"check"] stringValue]) {
//            
//            self.love = @"0";
//        }else if ([[[dic objectForKey:@"check"] stringValue] isEqualToString:@"0"]){
//            self.love = @"1";
//        }
    }
    return self;
}

@end
