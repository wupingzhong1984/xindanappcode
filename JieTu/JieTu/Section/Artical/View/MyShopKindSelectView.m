//
//  MyShopKindSelectView.m
//  JieTu
//
//  Created by 开发者 on 15/11/4.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "MyShopKindSelectView.h"
#import "MyShopKindSelectCell.h"

@interface MyShopKindSelectView ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,  strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * shopKindModelArray;
@end


@implementation MyShopKindSelectView

-(instancetype)initWithFrame:(CGRect)frame ShopKindModelArray:(NSMutableArray *)shopKindModelArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.shopKindModelArray = shopKindModelArray;
        UILabel * topLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, frame.size.width, 44) text:@"选择心愿单" textColor:UIColor_25252f font:12];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:topLabel];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(topLabel.frame), frame.size.width-40, 0.5)];
        line.backgroundColor = UIColor_cccccc;
        [self addSubview:line];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+15, frame.size.width, frame.size.height-44-44-1-30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 46;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_tableView.frame)+15, CGRectGetWidth(frame)-40, 0.5)];
        line2.backgroundColor = UIColor_cccccc;
        [self addSubview:line2];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, CGRectGetMaxY(line2.frame), CGRectGetWidth(frame), 44);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn setTitleColor:UIColor_ccac58 forState:UIControlStateNormal];
        _sureBtn.titleLabel.textColor = UIColor_ccac58;
        [self addSubview:_sureBtn];
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopKindModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyShopKindSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (!cell) {
        cell = [[MyShopKindSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ShopKindModel * shopKindModel = [self.shopKindModelArray objectAtIndex:indexPath.row];
    cell.shopKindModel = shopKindModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.selectIndexPath isEqual:indexPath]) {
        ((MyShopKindSelectCell * )cell).titleLabel.textColor = UIColorFromRGB(0x808080);
        ((MyShopKindSelectCell * )cell).titleLabel.font = [UIFont systemFontOfSize:16];

    }else{
        ((MyShopKindSelectCell * )cell).titleLabel.textColor = UIColor_25252f;
        self.selectIndexPath = indexPath;
        ((MyShopKindSelectCell * )cell).titleLabel.font = [UIFont systemFontOfSize:18];


    }
}



-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyShopKindSelectCell * cell = (MyShopKindSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = UIColorFromRGB(0x808080);
    cell.titleLabel.font = [UIFont systemFontOfSize:16];


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    MyShopKindSelectCell * cell = (MyShopKindSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = UIColor_25252f;
    cell.titleLabel.font = [UIFont systemFontOfSize:18];
    
}

/*
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
