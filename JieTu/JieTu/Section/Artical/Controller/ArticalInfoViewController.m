//
//  ArticalInfoViewController.m
//  JieTu
//
//  Created by 开发者 on 15/11/1.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ArticalInfoViewController.h"
#import "ArticalCell.h"
#import "ArticalHeader.h"
#import "MyShopKindSelectView.h"
#import "ShareView.h"
#import "ShopModel.h"
#import "ShopKindModel.h"
#import "PersonalCentreViewController.h"
#import "UMSocial.h"
#import "HomePageViewController.h"

@interface ArticalInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView * alphaView;
@property(nonatomic, strong)MyShopKindSelectView * selectView;
@property(nonatomic, strong)ShareView * shareView;
@property(nonatomic, strong)UIImage * shareImage;
@property(nonatomic, strong)NSString * articleLink;
@property(nonatomic, strong)NSMutableArray * shopList;
//收藏的时候用户自己的心愿单model 数组
@property(nonatomic, strong)NSMutableArray * shopKindArray;

// 1219
@property(nonatomic, strong)UIView * BottomView;
@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)ShopModel * collecShopModel;
@property(nonatomic, strong)UIActivityIndicatorView * activity;
@property(nonatomic, strong)UIButton * recommendBtn2;
@end

@implementation ArticalInfoViewController

-(NSMutableArray *)shopKindArray{
    if (!_shopKindArray) {
        self.shopKindArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _shopKindArray;
}
-(NSMutableArray *)shopList{
    if (!_shopList) {
        self.shopList = [NSMutableArray arrayWithCapacity:1];
    }
    return _shopList;
}

- (void)leftBarButtonItemAction{
    [self.alphaView removeFromSuperview];
    [self.selectView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonItemAction{
    
    UIWindow * w = [UIApplication sharedApplication].keyWindow;
    if (self.alphaView) {
        [w addSubview:_alphaView];
    }else{
        self.alphaView = [[UIView alloc] initWithFrame:w.bounds];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.7;
        [_alphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaViewAction)]];
        [w addSubview:_alphaView];
    }
    
    if (self.shareView) {
        
    }else{
        
        self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(20, 0, K_UIScreenWidth-40, 160)];
        [_shareView.shareLeftButton addTarget:self action:@selector(shareLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_shareView.shareRightButton addTarget:self action:@selector(shareRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    _shareView.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame), K_UIScreenWidth-40, 160);
    [w addSubview:_shareView];
    
    [UIView animateWithDuration:Alert_animation_time animations:^{
        _shareView.center = w.center;
    }];
    
    
    
}

- (void)shareLeftButtonAction{
    [self.alphaView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
    if (!self.shareImage) {
        
        self.shareImage = [UIImage imageNamed:@"JieTuShare.png"];
    }

    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"你要的腔调生活，都在这里";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.articleLink;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"心单 App:腔调生活心愿单" image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
- (void)shareRightButtonAction{
    [self.alphaView removeFromSuperview];
    [self.shareView removeFromSuperview];
    if (!self.shareImage) {
        self.shareImage = [UIImage imageNamed:@"JieTuShare.png"];
    }
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.articleLink;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"心单 App:腔调生活心愿单" image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"111");
            
            NSLog(@"分享成功！");
        }
    }];
    
}

- (void)alphaViewAction{
    [self.shareView removeFromSuperview];
    [self.selectView removeFromSuperview];
    [self.alphaView removeFromSuperview];
   
}

- (void)addIntoMyself{
    
    if (!self.selectView.selectIndexPath) {
        return;
    }
    
    [self.shareView removeFromSuperview];
    [self.selectView removeFromSuperview];
    [self.alphaView removeFromSuperview];
    [[DarkButton sharedManager] removeFromSuperview];
    
    if (self.selectView.selectIndexPath) {
        ShopKindModel * shopKindModel = [self.shopKindArray objectAtIndex:self.selectView.selectIndexPath.row];
#pragma mark -------- 得到相应的心愿单， 提交收藏
        NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [params setObject:ShopGoneDeleteAdd forKey:@"requestType"];
        NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
        [arguments setObject:shopKindModel.shopKindId forKey:@"shopKindId"];
        [arguments setObject:self.collecShopModel.shopId forKey:@"shopId"];
        [arguments setObject:@"L" forKey:@"actionType"];
        [params setObject:arguments forKey:@"arguments"];
        
        //封装好的方法数据请求， 带有回调block
        [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
            NSLog(@"===收藏==%@", json);
            
            if (![[json objectForKey:@"fault"] boolValue] ) {
                
                @try {
                    
                    DarkButton * btn = [DarkButton sharedManager];
                    UIWindow * window = [UIApplication sharedApplication].keyWindow;
                    [window addSubview:btn];
                    
                    UILabel * successLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(window.frame), K_UIScreenWidth-40, 76)];
                    successLabel.backgroundColor = [UIColor whiteColor];
                    successLabel.textColor = UIColor_25252f;
                    successLabel.textAlignment = NSTextAlignmentCenter;
                    successLabel.layer.cornerRadius = 3;
                    successLabel.clipsToBounds = YES;
                    successLabel.layer.borderWidth = 0.5;
                    successLabel.layer.borderColor = UIColor_9e9e9e.CGColor;
                    [window addSubview:successLabel];
                    
                    
                    
                    if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                        successLabel.text = @"心愿单添加成功";
                        [UIView animateWithDuration:Alert_animation_time animations:^{
                            successLabel.center = window.center;
                        } completion:^(BOOL finished) {
                            
                            [NSThread sleepForTimeInterval:2.0];
                            [successLabel removeFromSuperview];
                            [btn removeFromSuperview];
                        }];
                        
                        
                        self.collecShopModel.love = @"1";
                        [self.tableView reloadData];
                    }else{
                        
                        successLabel.text = @"心愿单添加失败";
                        [UIView animateWithDuration:Alert_animation_time animations:^{
                            successLabel.center = window.center;
                        } completion:^(BOOL finished) {
                            [NSThread sleepForTimeInterval:2.0];
                            [successLabel removeFromSuperview];
                            [btn removeFromSuperview];
                        }];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                @finally {
                    
                }
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            self.collecShopModel = nil;
            
        } failure:^(NSError *error) {
            self.collecShopModel = nil;
            NSLog(@"%@", error);
        }];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    label.text = @"推荐详情";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    if ([WXApi isWXAppInstalled]) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    }
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activity startAnimating];
    _activity.color = [UIColor grayColor];
    _activity.frame = CGRectMake(100, 100, 200, 100);
    [self.view addSubview:_activity];
    _activity.center = self.view.center;
    [self requestData];
}

- (void)requestData{

    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ArticalInfosType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:self.articleId forKey:@"articleId"];
    [params setObject:arguments forKey:@"arguments"];
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        NSLog(@"=== 文章信息接口==%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
            @try {
                self.articleLink = [[[json objectForKey:@"results"] objectForKey:@"articleInfo"] objectForKey:@"articleLink"];
                if (!self.articleLink.length) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [_activity stopAnimating];
                    [_activity removeFromSuperview];
//
                }
//                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self creatSubViews];
                });
                return ;
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
//                [_activity stopAnimating];
//                [_activity removeFromSuperview];

//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
            }
            @finally {
//                [_activity stopAnimating];
//                [_activity removeFromSuperview];

            }
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [_activity stopAnimating];
            [_activity removeFromSuperview];

        }
        
    } failure:^(NSError *error) {
        [_activity stopAnimating];
        [_activity removeFromSuperview];

        NSLog(@"%@", error);
    }];
    
}


- (void)creatSubViews{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, K_UIScreenHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-44)];
    webView.delegate = self;
    NSURL * url = [NSURL URLWithString:self.articleLink];
    NSURLRequest * request = [NSURLRequest  requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [self.view bringSubviewToFront:_activity];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewDidTapAction)];
    tap.delegate = self;
    [webView addGestureRecognizer:tap];
    
    
}

- (void)webViewDidTapAction{
    
    if (self.tableView) {
        [self recommendBtnAction];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [_activity stopAnimating];
    [_activity removeFromSuperview];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIScreenHeight-44, K_UIScreenWidth, 44)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.9;
    [self.view addSubview:view];
    
    UIButton * recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendBtn.frame = CGRectMake(0, 0, 150, 44);
    recommendBtn.backgroundColor = [UIColor clearColor];
    [recommendBtn setTitle:@"相关推荐" forState:UIControlStateNormal];
    
    recommendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    recommendBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 26, 0, 0);
    [recommendBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [recommendBtn addTarget:self action:@selector(recommendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:recommendBtn];
    
    self.recommendBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _recommendBtn2.frame = CGRectMake( K_UIScreenWidth -45, 14, 21, 16);
    _recommendBtn2.backgroundColor = [UIColor clearColor];
    UIImage * image = [UIImage imageNamed:@"moreShop.png"];
    [_recommendBtn2 setBackgroundImage:image forState:UIControlStateNormal];
    [_recommendBtn2 addTarget:self action:@selector(recommendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_recommendBtn2];
}

- (void)recommendBtnAction{
    
    if (!self.tableView) {
        [self requestAllShopModels];
        return;
    }
    
    if (self.tableView.frame.size.height >50) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-44, K_UIScreenWidth, 0);
            self.BottomView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-44, K_UIScreenWidth, 0);
            UIImage * image = [UIImage imageNamed:@"moreShop.png"];
            [_recommendBtn2 setBackgroundImage:image forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];

        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-44-200 , K_UIScreenWidth, 200);
        self.BottomView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-44-200, K_UIScreenWidth, 200);
        UIImage * image = [UIImage imageNamed:@"cancle.png"];
        [_recommendBtn2 setBackgroundImage:image forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)requestAllShopModels{
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ArticalInfoGetAllShopType forKey:@"requestType"];
    
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:self.articleId forKey:@"articleId"];
    [params setObject:arguments forKey:@"arguments"];
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        NSLog(@"=== 文章信息接口==%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
            @try {
                [self.shopList removeAllObjects];
                NSArray * array = [[json objectForKey:@"results"] objectForKey:@"shopList"];
                for (NSDictionary * dic in array) {
                    ShopModel * shopModel = [[ShopModel alloc] initWithDictionary:dic];
                    [self.shopList addObject:shopModel];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self creatTableView];
                });
                return ;
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
                UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:666];
                [activity stopAnimating];
                [activity removeFromSuperview];
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            @finally {
                UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:666];
                [activity stopAnimating];
                [activity removeFromSuperview];
                
            }
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:666];
            [activity stopAnimating];
            [activity removeFromSuperview];
            
        }
        
    } failure:^(NSError *error) {
        UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:666];
        [activity stopAnimating];
        [activity removeFromSuperview];
        
        NSLog(@"%@", error);
    }];
    

}

- (void)creatTableView{
    
    self.BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, K_UIScreenHeight-44-200, K_UIScreenWidth, 200)];
    _BottomView.backgroundColor = [UIColor blackColor];
    _BottomView.alpha = 0.7;
    [self.view addSubview:_BottomView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, K_UIScreenHeight-44-200, K_UIScreenWidth, 200) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[ArticalCell class] forCellReuseIdentifier:@"articalCell"];
    [self.view addSubview:_tableView];
    UIImage * image = [UIImage imageNamed:@"cancle.png"];
    [_recommendBtn2 setBackgroundImage:image forState:UIControlStateNormal];

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"articalCell"];
    ShopModel * shopModel = [self.shopList objectAtIndex:indexPath.row];
    cell.collectButton.tag = 500+indexPath.row;
    [cell.collectButton addTarget:self action:@selector(cellCollectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.shopModel =  shopModel;
    return cell;
}

- (void)loginAnimation{
    [[DarkButton sharedManager] removeFromSuperview];
    [[MyAlertView sharedManager] removeFromSuperview];
    PersonalCentreViewController * vc = [[PersonalCentreViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cellCollectButtonAction:(UIButton *)btn{
    
    NSInteger row = btn.tag - 500;
    ShopModel * shopModel = (ShopModel *)[self.shopList objectAtIndex:row];
    if ([shopModel.love isEqualToString:@"1"]) {
        
        return;
    }
    
    if (![CherryHelper checkUserLoginOrNot]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:[DarkButton sharedManager]];
        
        MyAlertView * alert = [MyAlertView sharedManager];
        alert.alertLabel.text = @"Ops!";
        alert.alertLabel.font = [UIFont boldSystemFontOfSize:20];
        [alert.trueButton setTitle:@"一键微信登陆 即可随心所欲" forState:UIControlStateNormal];
        alert.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame), CGRectGetWidth(alert.frame), CGRectGetHeight(alert.frame));
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        
        [UIView animateWithDuration:Alert_animation_time animations:^{
            alert.center = [UIApplication sharedApplication].keyWindow.center;
            [self performSelector:@selector(loginAnimation) withObject:nil afterDelay:2.0];
            
        }];
        
        return;
    }

    UIWindow * w = [UIApplication sharedApplication].keyWindow;
    if (self.alphaView) {
        [w addSubview:_alphaView];
    }else{
        self.alphaView = [[UIView alloc] initWithFrame:w.bounds];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.7;
        [_alphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaViewAction)]];
        [w addSubview:_alphaView];
    }
    self.collecShopModel = shopModel;
    [self requestShopKindId];
}
- (void)requestShopKindId{
    
    if (self.selectView && self.shopKindArray) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:_selectView];
        return;
    }
    NSString * userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"] objectForKey:@"userId"];
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:PersonShopKindSearchType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:userId forKey:@"userId"];
    [params setObject:arguments forKey:@"arguments"];
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        if (![[json objectForKey:@"fault"] boolValue] ) {
            @try {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIWindow * w = [UIApplication sharedApplication].keyWindow;
                    NSArray * array = [[json objectForKey:@"results"] objectForKey:@"shopKindList"];
                    for (int i = 0; i < array.count; i++) {
                        ShopKindModel * shopKindModel = [[ShopKindModel alloc] initWithDictionary:[array objectAtIndex:i]];
                        [self.shopKindArray addObject:shopKindModel];
                    }
                    
                    float height;
                    if (CGRectGetHeight(self.view.frame)<500) {
                        height = 320;
                    }else{
                        height = 400;
                    }
                    
                    
                    self.selectView = [[MyShopKindSelectView alloc] initWithFrame:CGRectMake(20, 100, K_UIScreenWidth-40, height) ShopKindModelArray:self.shopKindArray];
                    _selectView.backgroundColor = [UIColor whiteColor];
                    _selectView.layer.cornerRadius = 3;
                    _selectView.clipsToBounds = YES;
                    _selectView.layer.borderWidth = 0.5;
                    _selectView.layer.borderColor = UIColor_9e9e9e.CGColor;
                    _selectView.center = [UIApplication sharedApplication].keyWindow.center;
                    [w addSubview:_selectView];
                    
                    [_selectView.sureBtn addTarget:self action:@selector(addIntoMyself) forControlEvents:UIControlEventTouchUpInside];
                });
                
 
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            @finally {
                
            }
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
