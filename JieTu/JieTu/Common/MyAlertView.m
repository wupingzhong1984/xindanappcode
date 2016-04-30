//
//  MyAlertView.m
//  JieTu
//
//  Created by 开发者 on 15/11/15.
//  Copyright © 2015年 meself. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

-(instancetype)initWithAlertString:(NSString *)alertString{
    
    
    self = [super initWithFrame:CGRectMake(0, 0, K_UIScreenWidth-40, 121)];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    if (self) {
        
        self.alertLabel = [UILabel createLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 76) text:alertString textColor:UIColor_alert font:16];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_alertLabel];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_alertLabel.frame), CGRectGetWidth(self.frame)-40, 0.5)];
        line.backgroundColor = UIColor_line;
        [self addSubview:line];
        
        
        self.trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _trueButton.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(self.frame), 44);
        [_trueButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [_trueButton setTitleColor:UIColor_25252f forState:UIControlStateNormal];
        _trueButton.titleLabel.textColor = UIColor_25252f;
        _trueButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_trueButton];
        
    }
    
    return self;
}

+ (MyAlertView *)sharedManager{
    static MyAlertView *alert = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
       
        alert = [[self alloc] initWithAlertString:@""];
        
    });
    
    return alert;
}










@end
