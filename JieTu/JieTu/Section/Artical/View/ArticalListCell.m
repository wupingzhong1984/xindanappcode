//
//  ArticalListCell.m
//  JieTu
//
//  Created by 开发者 on 15/11/1.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ArticalListCell.h"

@implementation ArticalListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.articalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenWidth*2/3)];
        _articalImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_articalImageView];
        
        //添加蒙层的灰色效果
        UIView * grayView = [[UIView alloc] initWithFrame:_articalImageView.bounds];
        grayView.backgroundColor = UIColor_25252f;
        grayView.alpha = 0.3;
        [_articalImageView addSubview:grayView];
        
        
        self.articalNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, K_UIScreenWidth/3-20, K_UIScreenWidth, 30)];
        _articalNameLabel.font = [UIFont systemFontOfSize:20];
        _articalNameLabel.textAlignment = NSTextAlignmentCenter;
        _articalNameLabel.textColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:_articalNameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_articalNameLabel.frame)+6, K_UIScreenWidth, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setArticalModel:(ArticalModel *)articalModel{
    if (articalModel) {
        _articalModel = articalModel;
        [self.articalImageView sd_setImageWithURL:[NSURL URLWithString:articalModel.imgUrl] placeholderImage:[UIImage imageNamed:@"111.png"]];
        self.articalNameLabel.text = articalModel.title;
        self.timeLabel.text = articalModel.createDate;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
