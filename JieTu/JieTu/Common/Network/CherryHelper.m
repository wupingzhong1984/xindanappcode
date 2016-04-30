//
//  CherryHelper.m
//  Campus Life
//
//  Created by cf-finance on 14-7-2.
//  Copyright (c) 2014年 HP. All rights reserved.
//

#import "CherryHelper.h"
#import "UIDevice+IdentifierAddition.h"
#import "AFNetworking.h"
#import "DataBase.h"
#import "NetworkRequest.h"

static CherryHelper *instance;

@interface CherryHelper()

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSArray *services;
@property (strong, nonatomic) NSString  *deviceId;
@property (strong, nonatomic) NSArray *randomColors;
@property (strong, nonatomic) NSArray *anonymousImages;
@property (strong, nonatomic) NSArray *maleImages;
@property (strong, nonatomic) NSArray *femaleImages;
@property (strong, nonatomic) NSArray *nocacheURLs;
@property (strong, nonatomic) NSArray *bbsColors;

//@property(nonatomic) dispatch_queue_t queue_activity_background;

@end

@implementation CherryHelper

- (id)init
{
    self = [super init];
    
    [self initDeviceId];
    [self initNoCacheURLs];
    
    _networkRequest = [[NetworkRequest alloc] init];
    
    
    return self;
}



- (void)initDeviceId
{
    self.deviceId = @"";
}




- (void)initNoCacheURLs
{
    
    self.nocacheURLs = [NSArray array];
//    self.nocacheURLs = @[GetCellphonePasswordType,LoginType,UpdateUserInfoType,UpdateUserCreditInfoType,SubscribeOrder];
}

+ (UIViewController*)viewControllerWith:(UIView *) uiView{
    for (UIView* next = [uiView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    for (UIView *childView in view.subviews)
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
            return childView;
        
        UIView *result = [self findFirstResponderBeneathView:childView];
        if (result)
            return result;
    }
    
    return nil;
}

+ (CherryHelper *)getInstance
{
    if (instance)
        return instance;
    
    static dispatch_once_t predict;
    
    dispatch_once(&predict,^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (NSArray *)getMenuItems
{
    return [CherryHelper getInstance].menuItems;
}

+ (NSArray *)getServices
{
    return [CherryHelper getInstance].services;
}

+ (NSString *)getDeviceId
{
    return [CherryHelper getInstance].deviceId;

}

+ (NSArray *)getNoCacheURLs
{
    return [CherryHelper getInstance].nocacheURLs;
}

+ (UIImage *)anonymousImage
{
    NSArray *images = [CherryHelper getInstance].anonymousImages;
    int index = (arc4random() % images.count);
   
    return [images objectAtIndex:index];
}

+ (UIImage *)maleImage
{
    NSArray *images = [CherryHelper getInstance].maleImages;
    int index = (arc4random() % images.count);
    
    return [images objectAtIndex:index];
}

+ (UIImage *)femaleImage
{
    NSArray *images = [CherryHelper getInstance].femaleImages;
    int index = (arc4random() % images.count);
    
    return [images objectAtIndex:index];
}

+ (UIColor *)getRandomColor
{
    NSArray *colors = [CherryHelper getInstance].randomColors;
    NSInteger count = colors.count;
    
    int random = arc4random() % count;
    
    return [colors objectAtIndex:random];
}

+ (NSArray *)getBBSColors
{
    return [CherryHelper getInstance].bbsColors;
}

+ (NSString *)getDisplayTime:(NSString *)dateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:dateTime];
    
    NSTimeInterval interval = [date timeIntervalSinceNow];
    interval = -interval;
    
    long value;
    if (interval < 60)
        return @"刚刚";
    else if ((value = (interval / 60)) < 60)
        return [NSString stringWithFormat:@"%ld分钟前", value];
    else if ((value = (interval / 3600)) < 24)
        return [NSString stringWithFormat:@"%ld小时前", value];
    else
        return [NSString stringWithFormat:@"%ld天前", (long)interval / 86400];
}

+ (void)alert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

+ (BOOL)checkUserLogin:(BOOL)promptAlert delegate:(id /*<UIAlertViewDelegate>*/)delegate
{
    NSObject *dict =[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        

    //NSString *userToken = [CherryHelper getInstance].userToken;
    
    if (dict != nil)
        return true;
    
    if (promptAlert){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录后才能使用该功能！\r\n现在是否登录？" delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        
        [alert show];
    }

    
    return false;
}

+ (BOOL)checkUserLoginOrNot{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"userInfoDic"]) {
        return YES;
    }
    return NO;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        LoginAndRegisterViewController *loginController = [[LoginAndRegisterViewController alloc] init];
//        
//        [[NavigationDelegate sharedNavigationDelegate] displayController:loginController];
//    }
//}


+ (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGFloat originalAspect = original.size.width / original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    
    if (originalAspect > targetAspect)
    {
        // original is wider than target
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5;
    }
    else if (originalAspect < targetAspect)
    {
        // original is narrower than target
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0;
    } else
    {
        // original and target have same aspect ratio
        targetRect = CGRectMake(0, 0, size.width, size.height);
    }
    
    [original drawInRect:targetRect];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}

+ (UIImage *)clipImage:(UIImage *)original clipRect:(CGRect)clipRect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], clipRect);
    
    UIImage *clipImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return clipImage;
}

+ (UIImage *)scaleImage:(UIImage *)original scaleRect:(CGRect) scaleRect
{
    UIGraphicsBeginImageContext(scaleRect.size);
    
    [original drawInRect:scaleRect];
    
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)checkVersion:(void (^)(NSString * appId, NSString *updateURL))update
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *displayName = [infoDict objectForKey:@"CFBundleDisplayName"];
    NSString *bundleId = [infoDict objectForKey:@"CFBundleIdentifier"];
    
    // Need delete before publish to app store
    //displayName = @"Angry Bird";
    //bundleId = @"com.lettugames.spacebird";
    //////////////
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:displayName, @"term", @"software", @"entity",nil];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:@"/search" parameters:parameters
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSData *data = (NSData *)responseObject;
         
         id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         NSArray *arr = [res objectForKey:@"results"];
         
         for (id config in arr)
         {
             NSString *bundle_id = [config valueForKey:@"bundleId"];
             
             if ([bundle_id isEqualToString:bundleId])
             {
                 NSString *appId  = [config valueForKey:@"trackId"];
                 NSString *updateURL = [config valueForKey:@"trackViewUrl"];
                 NSString *appName = [config valueForKey:@"trackName"];
                 NSString *version = [config valueForKey:@"version"];
                 NSLog(@"app_id == %@,app_Name == %@,version == %@",appId,appName,version);
                 
                 NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
                 if (![version isEqualToString:nowVersion])
                 {
                     if (update)
                         update(appId, updateURL);
                 }
             }
         }
     }
    failure:nil];
}

+ (void)checkCacheSize
{
    [[DataBase getDatabase] constraintDBSize];
    
    NSInteger cacheMaxSize = [[NSUserDefaults standardUserDefaults] integerForKey:CACHE_MAX_SIZE];
    
    if (cacheMaxSize <= 0)
        cacheMaxSize = CACHE_MAX_SIZE_DEFAULT;
    
    NetworkRequest *networkRequest = [[NetworkRequest alloc] init];
    float cacheDirSize = [networkRequest getCacheDirSize];
    
    if (cacheDirSize <= cacheMaxSize)
        return;
    
    float reducedSize = (cacheDirSize - cacheMaxSize / 3.0 * 2.0) * 1024 * 1024;
    
    //while (true)
    {
        NSMutableArray *cacheItems = [[DataBase getDatabase] queryOldestCacheItems:CACHE_QUERY_LIMIT cacheType:CACHE_IMAGE_TYPE];
        
        if (cacheItems.count == 0)
            return;
        
        for (NSDictionary *cacheItem in cacheItems)
        {
            NSString *fileName = cacheItem[@"REQUEST_KEY"];
            
            reducedSize -= [networkRequest removeCacheFile:fileName];
            
            [[DataBase getDatabase] removeFromCache:fileName];
            
            if (reducedSize <= 0)
                return;
        }
    }
}

+(UIImage *)takeScreenShot
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShotImage;
}

#pragma mark - 进入时判断当前网络状态   0 - 无网络; 1 - 2G; 2 - 3G; 3 - 4G; 5 - WIFI
+(NSString *)getLocalNetWorkType
{
    NSString *netType = [NSString string];
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            // type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            netType = [child valueForKeyPath:@"dataNetworkType"];
        }
    }
    NSLog(@"type = ----%@", netType);
    return netType;
}

+(BOOL)isNull:(NSString*)string
{
    // 判断是否为空串
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (string==nil){
        return YES;
    }else if ([string length] == 0){
        return  YES;
    }
    return NO;
}

+ (BOOL)validateInvalidChar:(NSString *)str2validate
{
//    NSString *invalidRegex = @"[^0-9A-Za-z\\_\\-]+";
//    NSPredicate *invalidPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", invalidRegex];
//    
//    BOOL ret = [invalidPredicate evaluateWithObject:str2validate];
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_-"] invertedSet];
    NSRange range = [str2validate rangeOfCharacterFromSet:charSet];
    return (range.location == NSNotFound) ? YES : NO;
}

+ (BOOL)validateEmail:(NSString *)str2validate
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:str2validate];
}

+ (BOOL)validatePhone:(NSString *)str2validate
{
    NSString *phoneRegex = @"1[3|5|7|8][0-9]{9}";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phonePredicate evaluateWithObject:str2validate];
}

+ (BOOL)validateNumeric:(NSString *)str2validate
{
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSRange range = [str2validate rangeOfCharacterFromSet:charSet];
    return (range.location == NSNotFound) ? YES : NO;
}






















@end
