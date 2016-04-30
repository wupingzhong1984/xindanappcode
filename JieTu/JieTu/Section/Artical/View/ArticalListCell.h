//
//  ArticalListCell.h
//  JieTu
//
//  Created by 开发者 on 15/11/1.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticalModel.h"

@interface ArticalListCell : UITableViewCell

@property(nonatomic, strong)UIImageView * articalImageView;
@property(nonatomic, strong)UILabel * articalNameLabel;
@property(nonatomic, strong)UILabel * timeLabel;
@property(nonatomic, strong)ArticalModel * articalModel;
@end
