
//
//  ColorHeader.h
//  JieTu
//
//  Created by 开发者 on 15/11/6.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#ifndef JieTu_ColorHeader_h
#define JieTu_ColorHeader_h


#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColor_25252f (UIColorFromRGB(0x25252f))

#define UIColor_9e9e9e (UIColorFromRGB(0x9e9e9e))

#define UIColor_cccccc (UIColorFromRGB(0xcccccc))

#define UIColor_line (UIColorFromRGB(0x9e9e9e))

#define UIColor_alert (UIColorFromRGB(0x808080))

#define UIColor_ccac58 (UIColorFromRGB(0xccac58))



#define Alert_animation_time 0.5

#define Login_animation_time 0.5




