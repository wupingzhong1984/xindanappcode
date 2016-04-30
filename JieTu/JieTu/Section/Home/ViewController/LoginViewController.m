//
//  LoginViewController.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "LoginViewController.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "HomePageViewController.h"

@interface LoginViewController ()


@property(nonatomic, strong)UIImageView * imageView;
@property(nonatomic, strong)UILabel * userNameLabel;
@property(nonatomic, strong)UIButton * loginButton;
@property(nonatomic, strong)UILabel * line;
@property(nonatomic, strong)UIButton * outButton;



@property(nonatomic, strong)NSString * userId;
@property(nonatomic, strong)NSString * userName;
@property(nonatomic, strong)NSString * userGender;
@property(nonatomic, strong)NSString * userIcon;
@end

@implementation LoginViewController


- (void)leftBarButtonItemAction{
    
    UINavigationController * nav = (UINavigationController *)[[self.tabBarController viewControllers] lastObject];
    HomePageViewController * vc = (HomePageViewController *)[[nav viewControllers] firstObject];
    
    if ([vc respondsToSelector:@selector(requestData)]) {
        [vc performSelector:@selector(requestData)];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    label.text = @"个人中心";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    
    [self creatSubViews];
    [self creatAfterLoginSubViews];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"]) {
        [self userhaveLogin];
    }
}

- (void)creatSubViews{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((K_UIScreenWidth-65)/2, CGRectGetMaxY(self.navigationController.navigationBar.frame)+30, 65, 65)];
    _imageView.image = [UIImage imageNamed:@"photo.png"];
    _imageView.layer.cornerRadius = 65/2;
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
    
    self.loginButton = [UIButton createButtonWithFrame:CGRectMake((K_UIScreenWidth-260)/2, CGRectGetMaxY(_imageView.frame)+30, 260, 44) title:@"微信账号登陆" titleColor:UIColor_25252f font:16];
    _loginButton.backgroundColor = [UIColor clearColor];
    
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];

    [_loginButton setImage:[UIImage imageNamed:@"wechat_normal.png"] forState:UIControlStateNormal];
    [_loginButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 20)];
    [_loginButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 5)];
    _loginButton.layer.cornerRadius = 3;
    _loginButton.clipsToBounds = YES;
    _loginButton.layer.borderWidth = 0.5;
    _loginButton.layer.borderColor = UIColor_9e9e9e.CGColor;
    
    [_loginButton addTarget:self action:@selector(enterIntoLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton addTarget:self action:@selector(loginButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_loginButton];

}

- (void)creatAfterLoginSubViews{
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)+15, K_UIScreenWidth, 30)];
    _userNameLabel.font = [UIFont systemFontOfSize:16];
    _userNameLabel.textColor = UIColor_25252f;
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_userNameLabel];
    
    self.line = [UILabel createLabelWithFrame:CGRectMake(30, CGRectGetMaxY(_userNameLabel.frame)+30, K_UIScreenWidth-60, 0.5) text:nil textColor:nil font:0];
    _line.backgroundColor = UIColor_line;
    [self.view addSubview:_line];
    
    self.outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _outButton.frame = CGRectMake(30, CGRectGetMaxY(_line.frame)+20, K_UIScreenWidth-60, 44);
    _outButton.backgroundColor = [UIColor whiteColor];
    [_outButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [_outButton setTitleColor:UIColor_25252f forState:UIControlStateNormal];
    _outButton.titleLabel.font = [UIFont systemFontOfSize:16];

    _outButton.layer.cornerRadius = 3;
    _outButton.clipsToBounds = YES;
    _outButton.layer.borderWidth = 0.5;
    _outButton.layer.borderColor = UIColor_9e9e9e.CGColor;
    
    
    [_outButton addTarget:self action:@selector(outButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_outButton addTarget:self action:@selector(outButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_outButton];
    
    self.userNameLabel.hidden = YES;
    self.line.hidden = YES;
    self.outButton.hidden = YES;
   }
- (void)outButtonTouchDown{
    _outButton.backgroundColor = UIColor_ccac58;
    
}


- (void)outButtonAction{
    
    _outButton.backgroundColor = [UIColor clearColor];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfoDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.line.hidden = YES;
    self.userNameLabel.hidden = YES;
    self.outButton.hidden = YES;
  
    self.loginButton.hidden = NO;
    self.imageView.image = [UIImage imageNamed:@"photo.png"];
    UINavigationController * nav = (UINavigationController *)[[self.tabBarController viewControllers] lastObject];
    HomePageViewController * vc = (HomePageViewController *)[[nav viewControllers] firstObject];
    
    if ([vc respondsToSelector:@selector(requestData)]) {
        [vc performSelector:@selector(requestData)];
    }

}

- (void)loginButtonTouchDown{
    
    [_loginButton setImage:[UIImage imageNamed:@"wechat_white.png"] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = UIColor_ccac58;
    
}



- (void)enterIntoLogin{
    _loginButton.backgroundColor = [UIColor clearColor];
    [_loginButton setTitleColor:UIColor_25252f forState:UIControlStateNormal];
    [_loginButton setImage:[UIImage imageNamed:@"wechat_normal.png"] forState:UIControlStateNormal];

    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self uploadUserInfos:snsAccount];
            
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆失败，请重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    });
    
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        
        NSLog(@"SnsInformation is %@",response.data);
        NSLog(@" openid = %@", [response.data objectForKey:@"openid"]);
        NSLog(@" gender = %@", [response.data objectForKey:@"gender"]);
        NSLog(@" name = %@", [response.data objectForKey:@"screen_name"]);
    }];
}

- (void)uploadUserInfos:(UMSocialAccountEntity*)snsAccount{
    
    self.userIcon = snsAccount.iconURL;
    self.userName = snsAccount.userName;
    if (snsAccount.openId) {
        self.userId = snsAccount.openId;
    }
    
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:LoginUploadUserInfoType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:self.userId forKey:@"userId"];
    [arguments setObject:self.userName forKey:@"userName"];
    [arguments setObject:self.userIcon forKey:@"image"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"===登陆==%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
            
            @try {
                
                if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                    [self handleWithUserInfoLocal];
                    
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
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
}






- (void)handleWithUserInfoLocal{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userInfoDic = [NSMutableDictionary dictionary];
    [userInfoDic setObject:self.userIcon forKey:@"userIcon"];
    [userInfoDic setObject:self.userName forKey:@"userName"];
    [userInfoDic setObject:self.userId forKey:@"userId"];
    [defaults setObject:userInfoDic forKey:@"userInfoDic"];
    [defaults synchronize];
    
    self.loginButton.hidden = YES;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.userIcon] placeholderImage:nil];
    self.userNameLabel.text = self.userName;
    [_userNameLabel sizeToFit];
    _userNameLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame)+15, K_UIScreenWidth, CGRectGetHeight(_userNameLabel.frame));
    _userNameLabel.backgroundColor = [UIColor whiteColor];
    self.line.frame = CGRectMake(30, CGRectGetMaxY(_userNameLabel.frame)+30, K_UIScreenWidth-60, 0.5);
    self.outButton.frame = CGRectMake(30, CGRectGetMaxY(_line.frame)+20, K_UIScreenWidth-60, 44);
    self.userNameLabel.hidden = NO;
    self.line.hidden = NO;
    self.outButton.hidden = NO;
#pragma mark -------微信登陆之后跳转到首页
    [self leftBarButtonItemAction];

}


- (void)userhaveLogin{
    
    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
    self.userId = [dic objectForKey:@"userId"];
    self.userName = [dic objectForKey:@"userName"];
    self.userIcon = [dic objectForKey:@"userIcon"];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.userIcon] placeholderImage:nil];
    
    _userNameLabel.text = self.userName;
    [_userNameLabel sizeToFit];
    _userNameLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame)+15, K_UIScreenWidth, CGRectGetHeight(_userNameLabel.frame));
    _userNameLabel.backgroundColor = [UIColor whiteColor];
    self.line.frame = CGRectMake(30, CGRectGetMaxY(_userNameLabel.frame)+30, K_UIScreenWidth-60, 0.5);
    self.outButton.frame = CGRectMake(30, CGRectGetMaxY(_line.frame)+20, K_UIScreenWidth-60, 44);
    
    self.loginButton.hidden = YES;
    self.userNameLabel.hidden = NO;
    self.line.hidden = NO;
    self.outButton.hidden = NO;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
