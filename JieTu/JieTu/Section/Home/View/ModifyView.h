//
//  ModifyView.h
//  JieTu
//
//  Created by 樊鹏举 on 15/12/19.
//  Copyright © 2015年 meself. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyView : UIView<UITextFieldDelegate>

@property(nonatomic, strong)UITextField * textField;
@property(nonatomic, strong)UIButton * addImageBtn;
@property(nonatomic, strong)UIButton * cancelBtn;
@property(nonatomic, strong)UIButton * yesBtn;
@property(nonatomic, strong)UIButton * noBtn;
@property(nonatomic, strong)UIImage * image;

@property(nonatomic, strong)UILabel * addImageLabel;
@property(nonatomic, strong)UILabel * topLabel;
@end
