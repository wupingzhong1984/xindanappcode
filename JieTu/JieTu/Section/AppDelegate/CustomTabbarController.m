//
//  CustomTabbarController.m
//  1111
//
//  Created by 开发者 on 15/8/12.
//  Copyright (c) 2015年 开发者. All rights reserved.
//

#import "CustomTabbarController.h"
#import "BottomItem.h"



@interface CustomTabbarController ()<UITabBarControllerDelegate>
@end

@implementation CustomTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    CGRect rect = self.tabBar.bounds;
    self.bottomView = [[UIView alloc] initWithFrame:rect];
    _bottomView.backgroundColor = [UIColor orangeColor];
    _bottomView.userInteractionEnabled = NO;
    [self.tabBar addSubview:_bottomView];
    
    self.tabBarItem = nil ;
    BottomItem * btn1 = [[BottomItem alloc] initWithFrame:CGRectMake(0, 0, rect.size.width/2, rect.size.height)];
    btn1.label.text = @"每日推荐";
    btn1.imageView.image = [[UIImage imageNamed:@"botldar-icon-normal-home-adc.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btn1.backgroundImageView.image = [UIImage imageNamed:@"botldar-bg-down-adc.png"];
    btn1.tag = 300;
    [_bottomView addSubview:btn1];
    
    BottomItem * btn2 = [[BottomItem alloc] initWithFrame:CGRectMake(rect.size.width/2, 0, rect.size.width/2, rect.size.height)];
    btn2.label.text = @"心愿单";
    btn2.label.textColor = UIColor_alert;
    btn2.imageView.image = [[UIImage imageNamed:@"botldar-icon-normal-like-adc.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    btn2.tag = 301;
    [_bottomView addSubview:btn2];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(K_UIScreenWidth/2, 10, 1, 24)];
    label.backgroundColor = UIColor_cccccc;
    [_bottomView addSubview:label];
    self.delegate = self;
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
  
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    [self changeColor];
    if ([[change objectForKey:@"new"] floatValue] == 0) {
        BottomItem * btn = (BottomItem *)[_bottomView viewWithTag:300];
        btn.label.textColor = UIColor_alert;
    }else{
        BottomItem * btn = (BottomItem *)[_bottomView viewWithTag:301];
        btn.label.textColor = UIColor_alert;
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [self changeColor];
    NSInteger a = [self.viewControllers indexOfObject:viewController];
    BottomItem * btn = (BottomItem *)[_bottomView viewWithTag:a+300];
    btn.label.textColor = UIColor_alert;
}


- (void)changeColor{
    
    for (int i = 0; i < 4; i++) {
        BottomItem * btn = (BottomItem *)[_bottomView viewWithTag:i+300];
        btn.label.textColor = UIColor_cccccc;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
