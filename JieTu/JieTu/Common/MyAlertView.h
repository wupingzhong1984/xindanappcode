//
//  MyAlertView.h
//  JieTu
//
//  Created by 开发者 on 15/11/15.
//  Copyright © 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIView

@property(nonatomic, strong)UIButton * trueButton;
@property(nonatomic, strong)UILabel * alertLabel;
-(instancetype)initWithAlertString:(NSString *)alertString;
+ (MyAlertView *)sharedManager;
@end
