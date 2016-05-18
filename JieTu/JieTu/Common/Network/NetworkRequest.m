//
//  NetworkImage.m
//  Campus Life
//
//  Created by cf-finance on 14-7-4.
//  Copyright (c) 2014年 HP. All rights reserved.
//

#import <objc/runtime.h>
#import "NetworkRequest.h"
#import "AFNetworking.h"
#import "CherryHelper.h"
#import "Reachability.h"
#import "DataBase.h"

static BOOL networkReachable = YES;
static char kAFImageRequestOperationObjectKey;

@interface NetworkRequest()
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@property (strong, nonatomic) AFHTTPClient *httpClient;
@property (strong, nonatomic) AFHTTPClient *httpPostClient;

@end

@implementation NetworkRequest
@dynamic af_imageRequestOperation;

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return _af_imageRequestOperationQueue;
}

- (UIImage *) scaledImage:(UIImage *)image scaleToSize:(CGSize)size
{
    CGSize imageSize = image.size;
    
    if (CGSizeEqualToSize(size, CGSizeZero) ||
        CGSizeEqualToSize(size, imageSize))
        return image;
    
    if (size.height == 0)
        size.height =  size.width/ image.size.width * image.size.height;
    
    float scale = 1.0f;
    if (size.width / size.height < imageSize.width / imageSize.height)
        scale = size.height / imageSize.height;
    else
        scale = size.width / imageSize.width;
        
    imageSize.width *= scale;
    imageSize.height *= scale;
    
    CGRect scaleRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIImage *scaledImage = [CherryHelper scaleImage:image scaleRect:scaleRect];
    
    CGRect clipRect = CGRectMake(0, 0, size.width, size.height);
    UIImage *clipImage = [CherryHelper clipImage:scaledImage clipRect:clipRect];
        
    return clipImage;
}

-(void)retrieveImageWithURLRequest:(NSString *)urlString
                       scaleToSize:(CGSize)size
                           success:(void (^)(UIImage *image))success
                           failure:(void (^)(NSError *error))failure
{
    if (urlString == nil)
        return;
    
    [self cancelImageRequestOperation];
    
    if (![[urlString lowercaseString] hasPrefix:@"http://"])
        urlString = [SERVER_IMG_URL stringByAppendingString:urlString];
    
    NSData *data = [self loadImageData:urlString];
    if (data)
    {
        UIImage *image = [UIImage imageWithData:data];
        
        if (success)
        {
            success([self scaledImage:image scaleToSize:size]);
        }
        
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSLog(@"Retrieve Image from %@", urlString);
    AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc]initWithRequest:urlRequest];
    
    [requestOperation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]])
             self.af_imageRequestOperation = nil;
         
         //图片本地缓存
         [self saveImageToCacheDir:urlString image:responseObject];
         
         if (success)
         {
             success([self scaledImage:responseObject scaleToSize:size]);
         }
     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]])
             self.af_imageRequestOperation = nil;
         
         NSLog(@"ERROR: Retrieve from %@", urlString);
         if (failure)
             failure(error);
     }
     ];
    
    self.af_imageRequestOperation = requestOperation;
    
    [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
}

-(void)retrieveImageWithURLRequest:(NSString *)urlString
            success:(void (^)(UIImage *image))success
            failure:(void (^)(NSError *error))failure
{
    [self retrieveImageWithURLRequest:urlString scaleToSize:CGSizeZero success:success failure:failure];
}

-(NSString* )pathInCacheDirectory
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    
    return [cachePath stringByAppendingPathComponent:CACHE_FILE_PATH];
}
 //创建缓存文件夹
-(BOOL) createDirInCache
{
    NSString *cacheDir = [self pathInCacheDirectory];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:cacheDir isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES))
        isCreated = [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    if (existed)
        isCreated = YES;
    return isCreated;
}

// 删除图片缓存
- (BOOL) deleteDirInCache
{
    NSString *imageDir = [self pathInCacheDirectory];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isDeleted = false;
    if (isDir == YES && existed == YES)
        isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
    
    return isDeleted;
}

- (BOOL)saveImageToCacheDir:(NSString *)urlString image:(UIImage *)image
{
    if ([self createDirInCache])
    {
        return [self saveImageToCacheDir:[self pathInCacheDirectory] image: image imageName:[urlString md5]];
    }
    
    return false;
}

// 图片本地缓存
- (BOOL) saveImageToCacheDir:(NSString *)directoryPath  image:(UIImage *)image imageName:(NSString *)imageName
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    if (isDir == YES && existed == YES)
    {
        NSString *fileName = [directoryPath stringByAppendingPathComponent:imageName];
        
        isSaved = [UIImagePNGRepresentation(image) writeToFile:fileName options:NSAtomicWrite error:nil];
        
        if (isSaved)
            [[DataBase getDatabase] putToCache:imageName cacheStr:imageName cacheType:CACHE_IMAGE_TYPE];
    }
    
    return isSaved;
}

// 获取缓存图片
-(NSData*) loadImageData:(NSString *)urlString
{
    NSString *directoryPath = [self pathInCacheDirectory];
    NSString *imageName = [urlString md5];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if (isDir == YES && dirExisted == YES)
    {
        
        NSString *fileName = [directoryPath stringByAppendingPathComponent:imageName];
        
        BOOL fileExisted = [fileManager fileExistsAtPath:fileName];
        if (!fileExisted)
            return NULL;
        
        //NSLog(@"Cache Read File :%@", fileName);
        
        NSData *imageData = [NSData dataWithContentsOfFile : fileName];
        
        [[DataBase getDatabase] refreshLastUseTime:imageName];
        
        return imageData;
    }
    else
    {
        return NULL;
    }
}

- (long long) fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath])
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    
    return 0;
}

- (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *files = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    
    while ((fileName = [files nextObject]) != nil)
    {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize / (1024.0 * 1024.0);
}

- (float)getCacheDirSize
{
    NSString *cacheDir = [self pathInCacheDirectory];
    
    return [self folderSizeAtPath:cacheDir];
}

- (long long)removeCacheFile:(NSString *)fileName
{
    NSString *cacheDir = [self pathInCacheDirectory];
    NSString *fileAbsolutePath = [cacheDir stringByAppendingPathComponent:fileName];
    
    long long fileSize = [self fileSizeAtPath:fileAbsolutePath];
    
    if (fileSize > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        [fileManager removeItemAtPath:fileAbsolutePath error:nil];
    }
    
    return fileSize;
}

- (BOOL)checkNetworkReachability
{
    Reachability *reachability = [Reachability reachabilityWithHostName:NETWORK_CONNECT_TEST_URL];
    
    if ([reachability currentReachabilityStatus] == NotReachable)
    {
        if (networkReachable)
            [CherryHelper alert:@"请检查网络连接"];
        
        return false;
    }
    
    return true;
}

+ (NSString *)generateRequestKey:(NSString *)requestUrl parameters:(NSDictionary *)parameters
{
    NSArray *paramNames = [parameters allKeys];
    NSArray *sortedParamNames = [paramNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                 {
                                     return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
                                 }];
    
    requestUrl = [requestUrl stringByAppendingString:@"="];
    for (NSString *paramName in sortedParamNames)
    {
        requestUrl = [requestUrl stringByAppendingFormat:@"%@=%@", paramName, [parameters objectForKey:paramName]];
    }
    
    return [requestUrl md5];
}

- (NSMutableDictionary *)retrieveJsonWithURLRequest:(NSString *)urlString
                                         parameters:(NSMutableDictionary *)parameters
                                            success:(void (^)(NSDictionary *json))success
                                            failure:(void (^)(NSError *error))failure
{
    NSArray *noCacheURLs = [CherryHelper getNoCacheURLs];
    BOOL needCache = ![noCacheURLs containsObject:urlString];
    
    return [self retrieveJsonWithURLRequest:urlString parameters:parameters needCache:needCache success:success failure:failure];
}

- (NSMutableDictionary *)retrieveJsonWithURLRequest:(NSString *)urlString
                                         parameters:(NSMutableDictionary *)parameters
                                          needCache:(BOOL)needCache
                         success:(void (^)(NSDictionary *json))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *requestKey = nil;
    NSMutableDictionary *json = nil;
    
    if (needCache)
    {
        requestKey = [NetworkRequest generateRequestKey:urlString parameters:parameters];
        json = [[DataBase getDatabase] getFromCache:requestKey];
    }
    
//    if (![urlString isEqualToString:API_TOKEN_URL] && ![urlString isEqualToString:USER_LOGIN_URL])
//        [self appendParameters:parameters];
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    if (!_httpClient)
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSLog(@"%@,%@,%@",url,urlString,parameters);
    [_httpClient postPath:urlString parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject)
                {
                    networkReachable = YES;
                    
                    NSDictionary *json = [DataBase jsonData2NSDictionary:responseObject];
                    
                    if (json && needCache)
                        [[DataBase getDatabase] putToCache:requestKey jsonData:responseObject];
                    
                    if (success)
                        success(json);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
                {
                    NSLog(@"Error: %@", error.description);
                    
                    if ([self checkNetworkReachability])
                    {
                        if (networkReachable)
                            
                            
                            [CherryHelper alert:@"无法连接服务器"];
                    }
                    
//                    networkReachable = NO;
                    
                    if (failure)
//                        success(json);
                        
                        failure(error);
                }];
    
    return json;
}

- (NSMutableDictionary *)retrieveJsonWithJSONRequest:(NSString *)urlString
                                          parameters:(NSMutableDictionary *)parameters
                                             success:(void (^)(NSDictionary *json))success
                                             failure:(void (^)(NSError *error))failure
{

    
    NSArray *noCacheURLs = [CherryHelper getNoCacheURLs];
    
    BOOL needCache = [noCacheURLs containsObject:parameters[@"requestType"]];
    
    return [self retrieveJsonWithJSONRequest:urlString parameters:parameters needCache:needCache success:success failure:failure];
}


- (NSMutableDictionary *)retrieveJsonWithJSONRequest:(NSString *)urlString parameters:(NSMutableDictionary *)parameters
                                            needCache:(BOOL)needCache
                                            success:(void (^)(NSDictionary *json))success
                                            failure:(void (^)(NSError *error))failure
{
    
    [self appendParameters:parameters];
    
    NSString *requestKey = nil;
    NSMutableDictionary *json = nil;
    if (needCache)
    {
        requestKey = [NetworkRequest generateRequestKey:urlString parameters:parameters];
        json = [[DataBase getDatabase] getFromCache:requestKey];
    }

    if (!_httpPostClient)
        _httpPostClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    
    _httpPostClient.parameterEncoding = AFJSONParameterEncoding;
    [_httpPostClient setDefaultHeader:@"Accept" value:@"text/json"];
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    NSLog(@"\n%@\n%@\n%@",_httpPostClient,urlString,parameters);
    [_httpPostClient postPath:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         
         networkReachable = YES;
         NSDictionary *json = [DataBase jsonData2NSDictionary:responseObject];
         
         
         if(json == nil){
             
             success(responseObject);
         }else{
             if (json && needCache)
                 [[DataBase getDatabase] putToCache:requestKey jsonData:responseObject];
             
             //NSLog(@"Success: %@", json);
             
             if (success)
                 success(json);
         }

     }
     
                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error.description);
         
         if ([self checkNetworkReachability])
         {
             if (networkReachable)
                 [CherryHelper alert:@"无法连接服务器"];
         }
         
//         networkReachable = NO;
         
         if (failure){
//             if ([[parameters objectForKey:@"requestType"] isEqualToString:HomePageGetImageListType]||[[parameters objectForKey:@"requestType"] isEqualToString:AidingApplyedListType] ||[[parameters objectForKey:@"requestType"] isEqualToString:GetProductDetailInfo]||[[parameters objectForKey:@"requestType"] isEqualToString:MyCarInfoType]) {
//                 
//                 success(json);
//             }else{
//                 failure(error);
//             }
         }
     }];
    
    return json;

   }

- (void)uploadImage:(NSString *)urlString parameters:(NSMutableDictionary *)parameters image:(UIImage *)image success:(void (^)(NSString *json))success failure:(void (^)(NSError *error))failure
{
    [self appendParameters:parameters];
    
//    NSURL *url = [NSURL URLWithString:SERVER_URL];
    if (!_httpClient)
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    
    NSMutableURLRequest *request = [_httpClient multipartFormRequestWithMethod:@"POST" path:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:nil];
        NSDate * date = [NSDate date];
        double time = [date timeIntervalSince1970];
        NSString * fileName = [NSString stringWithFormat:@"%f.png", time];
        
        [formData appendPartWithFileData:imageData name:@"name" fileName:fileName mimeType:@"image/jpeg"];
        [formData appendPartWithFormData:jsonData name:@"jsonParam" ];

    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Upload %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
            failure(error);
    }];
    
    [operation start];
}

- (void)appendParameters:(NSMutableDictionary *)params
{
    NSString * deviceId = [CherryHelper getDeviceId];
    [params setObject:deviceId forKey:@"deviceId"];
    [params setObject:@"APP_IOS" forKey:@"sysCode"];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
    if (dic){
        NSString * userId = [dic objectForKey:@"userId"];
        
        if (userId != nil){
            [params setObject:userId forKey:@"userId"];

        }

    }
}

//- (void)requestAppToken:(void (^)(NSString *json))success
//                   failure:(void (^)(NSError *error))failure
//{
//    CherryHelper *instance = [CherryHelper getInstance];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    instance.appToken = [defaults stringForKey:JSON_APP_TOKEN];
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios", @"user", @"123", @"pwd", [CherryHelper getDeviceId], @"deviceid", nil];
//            
////    [self retrieveJsonWithURLRequest:API_TOKEN_URL parameters:parameters
//        success:^(NSDictionary *json)
//        {
//            instance.appToken = json[@"token"];
//                                     
//            [defaults setObject:instance.appToken forKey:JSON_APP_TOKEN];
//            [defaults synchronize];
//                                     
//            if (success)
//                success(instance.appToken);
//        }
//        failure:^(NSError *error)
//        {
//            if (failure)
//                failure(error);
//        }];
//}

- (void)requestUserToken:(NSString *)userName password:(NSString*)password success:(void (^)(NSString *json))success
                failure:(void (^)(NSError *error))failure
{
    CherryHelper *instance = [CherryHelper getInstance];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:instance.appToken,JSON_APP_TOKEN, userName, JSON_USER_NAME, password, JSON_USER_PASSWORD, nil];
            
    [self retrieveJsonWithURLRequest:USER_LOGIN_URL parameters:parameters
        success:^(NSDictionary *json)
        {
            NSString *userToken = [json objectForKey:JSON_USER_LOIN_RET];
                 
            if (![userToken isEqualToString:@"fail"])
                instance.userToken = userToken;
                     
            if (success)
                success(instance.userToken);
        }
        failure:^(NSError *error)
        {
            if (failure)
            {
                NSLog(@"ERROR: retreive userToken");
                failure(error);
            }
        }];
}

@end
