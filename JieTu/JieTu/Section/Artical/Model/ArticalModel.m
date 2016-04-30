//
//  ArticalModel.m
//  JieTu
//
//  Created by 开发者 on 15/11/3.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ArticalModel.h"

@implementation ArticalModel


-(instancetype)initWithDictionary:(NSDictionary *)dic{
    if (dic) {
        self.articleId = [dic objectForKey:@"articleId"];
        self.title = [dic objectForKey:@"title"];
        self.createDate = [dic objectForKey:@"createDate"];
        self.imgUrl = [dic objectForKey:@"imgUrl"];
        
    }
    return self;
    
}





@end
