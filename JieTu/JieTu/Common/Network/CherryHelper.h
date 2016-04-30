//
//  CherryHelper.h
//  Campus Life
//
//  Created by cf-finance on 14-7-2.
//  Copyright (c) 2014年 HP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CherryConstants.h"
#import "NetworkRequest.h"


@interface CherryHelper : NSObject

@property (strong, nonatomic) NSString  *appToken;
@property (strong, nonatomic) NSString  *userToken;

@property (strong, nonatomic) NetworkRequest *networkRequest;

+ (UIViewController *) viewControllerWith:(UIView *)uiView;
+ (UIView*)findFirstResponderBeneathView:(UIView*)view;
+ (CherryHelper *)getInstance;
+ (NSArray *)getMenuItems;
+ (NSArray *)getServices;
+ (NSString *)getDeviceId;
+ (NSArray *)getNoCacheURLs;
+ (UIColor *)getRandomColor;
+ (NSArray *)getBBSColors;
+ (UIImage *)anonymousImage;
+ (UIImage *)maleImage;
+ (UIImage *)femaleImage;
+ (NSString *)getDisplayTime:(NSString *)dateTime;
+ (void)alert:(NSString *)message;
+ (BOOL)checkUserLogin:(BOOL)promptAlert delegate:(id /*<UIAlertViewDelegate>*/)delegate;
+ (BOOL)checkUserLoginOrNot;
+ (UIImage *)takeScreenShot;
+ (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size;
+ (UIImage *)clipImage:(UIImage *)original clipRect:(CGRect)clipRect;
+ (UIImage *)scaleImage:(UIImage *)original scaleRect:(CGRect) scaleRect;
+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (void)checkVersion:(void (^)(NSString * appId, NSString *updateURL))update;
+ (void)checkCacheSize;

#pragma mark - 进入时判断当前网络状态   0 - 无网络; 1 - 2G; 2 - 3G; 3 - 4G; 5 - WIFI
+(NSString *)getLocalNetWorkType;

+(BOOL)isNull:(NSString*)string;

+ (BOOL)validateInvalidChar:(NSString *)str2validate;
+ (BOOL)validateEmail:(NSString *)str2validate;
+ (BOOL)validateNumeric:(NSString *)str2validate;
+ (BOOL)validatePhone:(NSString *)str2validate;

+ (UIView *)myAlertView:(NSString *)string;

@end
