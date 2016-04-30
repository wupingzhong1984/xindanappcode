//
//  AppDelegate.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "APService.h"
#import "CustomTabbarController.h"
#import "ArticalListViewController.h"


@interface AppDelegate ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIPageControl * page;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [NSThread sleepForTimeInterval:2.0];
    //test
    //test2
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService clearAllLocalNotifications];

    [self.window makeKeyAndVisible];
    
    [UMSocialData setAppKey:@"5630dfe267e58e25200005a7"];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialWechatHandler setWXAppId:@"wxef9e3f5b987e2d88" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"https://itunes.apple.com/cn/genre/ios/id36?mt=8"];
    
    
    
    //推送测试
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
    //测试结束
    
    [self getIntoHomePageController];
     [self initFirstComeIn];
    return YES;
}

- (void)initFirstComeIn{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstComeIn"]) {
        
        NSArray * imageArray;
        
        if (K_UIScreenHeight < 500) {
            imageArray = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", nil];
        }else{
            imageArray = [NSArray arrayWithObjects:@"001", @"002", @"003", @"004", nil];

        }
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstComeIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIScrollView  * firstScrollView = [[UIScrollView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        firstScrollView.bounces = NO;
        firstScrollView.tag = 250;
        firstScrollView.delegate = self;
        firstScrollView.showsHorizontalScrollIndicator = NO;
        firstScrollView.showsVerticalScrollIndicator = NO;
        firstScrollView.backgroundColor = [UIColor orangeColor];
        firstScrollView.contentSize = CGSizeMake(CGRectGetWidth(firstScrollView.frame)*imageArray.count,CGRectGetHeight(firstScrollView.frame));
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(K_UIScreenWidth*i, 0, K_UIScreenWidth, CGRectGetHeight(firstScrollView.frame))];
            NSString * str = [NSString stringWithFormat:@"%@.png", [imageArray objectAtIndex:i]];
            imageView.image = [UIImage imageNamed:str];
            imageView.backgroundColor = [UIColor whiteColor];
            
            if (i == imageArray.count-1) {
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOnTheWindow)]];
            }
            
            [firstScrollView addSubview:imageView];
        }
        
        firstScrollView.pagingEnabled = YES;
        [self.window addSubview:firstScrollView];
        
        self.page = [[UIPageControl alloc] initWithFrame:CGRectMake(100, K_UIScreenHeight-50, K_UIScreenWidth-200, 30)];
        _page.numberOfPages = 4;
        _page.pageIndicatorTintColor = [UIColor lightGrayColor];
        _page.currentPageIndicatorTintColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_page];
        
        
        NSLog(@"123");
    }else{

        
        }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger a = scrollView.contentOffset.x/K_UIScreenWidth;
    self.page.currentPage = a;
    
}


- (void)dismissOnTheWindow{

//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
//    if (K_UIScreenHeight < 500) {
//        imageView.image = [UIImage imageNamed:@"04.png"];
//
//    }else{
//        
//        imageView.image = [UIImage imageNamed:@"004.png"];
//    }
//    [self.window addSubview:imageView];
    UIScrollView * scrollView = (UIScrollView *)[self.window viewWithTag:250];
    
    
        [UIView animateWithDuration:1.0 animations:^{
            scrollView.frame = CGRectMake(-K_UIScreenWidth, 0, K_UIScreenWidth, CGRectGetHeight(scrollView.frame));
            self.page.frame = CGRectMake(100-K_UIScreenWidth, K_UIScreenHeight-50, K_UIScreenWidth-200, 30);
        } completion:^(BOOL finished) {
            
            [scrollView removeFromSuperview];
            [self.page removeFromSuperview];

        }];

    
    
    
}

- (void)getIntoHomePageController{

    HomePageViewController * homeVC = [[HomePageViewController alloc] init];
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    ArticalListViewController * articalListVC = [[ArticalListViewController alloc] init];
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:articalListVC];

    CustomTabbarController * tabbar = [[CustomTabbarController alloc] init];
    tabbar.viewControllers = @[nav2, nav1];
    self.window.rootViewController = tabbar;
    
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService clearAllLocalNotifications];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

}


@end
