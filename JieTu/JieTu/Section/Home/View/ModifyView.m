//
//  ModifyView.m
//  JieTu
//
//  Created by 樊鹏举 on 15/12/19.
//  Copyright © 2015年 meself. All rights reserved.
//

#import "ModifyView.h"

@implementation ModifyView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.topLabel = [UILabel createLabelWithFrame:CGRectMake(10, 0, frame.size.width-20, 44) text:@"修改心愿单" textColor:UIColor_alert font:12];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_topLabel];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLabel.frame), frame.size.width, 1)];
        line.backgroundColor = UIColor_cccccc;
        [self addSubview:line];
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/2-100, CGRectGetMaxY(line.frame)+13, 200, 36)];
        _textField.clearsOnBeginEditing = YES;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.text  =@"";
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self addSubview:_textField];
        UILabel * middleLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textField.frame), CGRectGetMaxY(_textField.frame), CGRectGetWidth(_textField.frame), 1)];
        middleLine.backgroundColor = UIColor_cccccc;
        [self addSubview:middleLine];
        
        self.addImageLabel = [UILabel createLabelWithFrame:CGRectMake(frame.size.width/2-100, CGRectGetMaxY(middleLine.frame)+10, 200, 44) text:@"添加背景图" textColor:UIColor_alert font:12];
        _addImageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_addImageLabel];
        
        self.addImageBtn = [UIButton createButtonWithFrame:CGRectMake(frame.size.width/2-75, CGRectGetMaxY(_addImageLabel.frame), 150, 150) title:@"" titleColor:[UIColor clearColor] font:0];
        _addImageBtn.backgroundColor = [UIColor whiteColor];
        _addImageBtn.layer.borderWidth = 0.5;
        _addImageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_addImageBtn];
        
        self.cancelBtn = [UIButton createButtonWithFrame:CGRectMake(frame.size.width/2-70, CGRectGetMaxY(_addImageBtn.frame)+10, 140, 44) title:@"删除心愿单" titleColor:UIColor_ccac58 font:14];
        _cancelBtn.layer.borderColor = UIColor_ccac58.CGColor;
        _cancelBtn.layer.borderWidth = 0.5;
        
        
        [self addSubview:_cancelBtn];
        
        UILabel * bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cancelBtn.frame)+20, frame.size.width, 1)];
        bottomLine.backgroundColor = UIColor_cccccc;
        [self addSubview:bottomLine];
        
        self.yesBtn = [UIButton createButtonWithFrame:CGRectMake(20, CGRectGetMaxY(bottomLine.frame), frame.size.width/2-20, 44) title:@"取消" titleColor:[UIColor grayColor] font:16];
        [self addSubview:_yesBtn];
        
        UILabel * minLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, CGRectGetMinY(_yesBtn.frame)+10, 1, 24)];
        minLabel.backgroundColor = UIColor_cccccc;
        [self addSubview:minLabel];
        
        
        self.noBtn = [UIButton createButtonWithFrame:CGRectMake(frame.size.width/2, CGRectGetMinY(_yesBtn.frame), CGRectGetWidth(_yesBtn.frame), CGRectGetHeight(_yesBtn.frame)) title:@"确定" titleColor:[UIColor grayColor] font:16];
        [self addSubview:_noBtn];
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}







@end
