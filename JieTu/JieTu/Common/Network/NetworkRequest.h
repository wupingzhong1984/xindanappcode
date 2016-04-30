//
//  NetworkImage.h
//  Campus Life
//
//  Created by cf-finance on 14-7-4.
//  Copyright (c) 2014年 HP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkRequest : NSObject

-(void)retrieveImageWithURLRequest:(NSString *)urlString
                           success:(void (^)(UIImage *image))success
                           failure:(void (^)(NSError *error))failure;

-(void)retrieveImageWithURLRequest:(NSString *)urlString
                           scaleToSize:(CGSize)size
                           success:(void (^)(UIImage *image))success
                           failure:(void (^)(NSError *error))failure;

- (void)uploadImage:(NSString *)urlString parameters:(NSMutableDictionary *)parameters image:(UIImage *)image success:(void (^)(NSString *json))success failure:(void (^)(NSError *error))failure;

- (id)retrieveJsonWithURLRequest:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
                         success:(void (^)(NSDictionary *json))success
                         failure:(void (^)(NSError *error))failure;

- (id)retrieveJsonWithJSONRequest:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
                         success:(void (^)(NSDictionary *json))success
                         failure:(void (^)(NSError *error))failure;

- (void)requestAppToken:(void (^)(NSString *json))success
                failure:(void (^)(NSError *error))failure;

- (void)requestUserToken:(NSString *)userName password:(NSString*)password success:(void (^)(NSString *json))success
                failure:(void (^)(NSError *error))failure;

- (long long)removeCacheFile:(NSString *)fileName;
- (float)getCacheDirSize;

@end

@interface NSString (md5)
- (NSString *) md5;
@end

#import<CommonCrypto/CommonDigest.h>
@implementation NSString (md5)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}  
@end

@interface UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size;
@end

@implementation UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
