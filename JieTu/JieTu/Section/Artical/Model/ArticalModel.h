//
//  ArticalModel.h
//  JieTu
//
//  Created by 开发者 on 15/11/3.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ArticalModel : NSObject

@property(nonatomic, strong)NSString * articleId;
@property(nonatomic, strong)NSString * title;
@property(nonatomic, strong)NSString * imgUrl;
@property(nonatomic, strong)NSString * createDate;
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
