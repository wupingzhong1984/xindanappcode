
//
//  MerchantViewController.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "MerchantViewController.h"
#import "MerchantCollectionViewCell.h"
#import "CWStarRateView.h"
#import "MerchantMapViewController.h"
#import "UMSocial.h"
#import "ShareView.h"
#import "ShopModel.h"


@interface MerchantViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView * collectionView;
@property(nonatomic, strong)UILabel * nameLabel;
@property(nonatomic, strong)UILabel * addressLabel;
@property(nonatomic, strong)UILabel * phoneNumberLabel;
@property(nonatomic, strong)UILabel * moneyLabel;
@property(nonatomic, strong)CWStarRateView * starView;
@property(nonatomic, strong)UILabel * merchantInfoLabel;
@property(nonatomic, strong)UIScrollView * backScrollView;
@property(nonatomic, strong)UIView * callView;
//分享
@property(nonatomic, strong)NSString * shareUrl;
@property(nonatomic, strong)UIImage * shareImage;
@property(nonatomic, strong)ShareView * shareView;
@property(nonatomic, strong)UIView * alphaView;
@property(nonatomic, strong)UIPageControl * pageController;
@end

@implementation MerchantViewController

- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonItemAction{
    
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ShopInfoShareType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:self.shopModel.shopId forKey:@"shopId"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
#pragma mark ---
            @try {
                self.shareUrl = [[json objectForKey:@"results"] objectForKey:@"url"];
                UIWindow * w = [UIApplication sharedApplication].keyWindow;
                if (self.alphaView) {
                    
                }else{
                    self.alphaView = [[UIView alloc] initWithFrame:w.bounds];
                    _alphaView.backgroundColor = [UIColor blackColor];
                    _alphaView.alpha = 0.7;
                    [_alphaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaViewAction)]];
                }
                
                [w addSubview:_alphaView];
                
                if (self.shareView) {
                    
                }else{
                    self.shareView = [[ShareView alloc] initWithFrame:CGRectMake(20, 0, K_UIScreenWidth-40, 160)];
                    _shareView.backgroundColor = [UIColor whiteColor];
                    [_shareView.shareLeftButton addTarget:self action:@selector(shareLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    [_shareView.shareRightButton addTarget:self action:@selector(shareRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
                }
                _shareView.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame), K_UIScreenWidth-40, 160);
                [w addSubview:_shareView];
                
                [UIView animateWithDuration:Alert_animation_time animations:^{
                    _shareView.center = w.center;
                }];
                
                return ;
                
                
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

- (void)alphaViewAction{
    [self.shareView removeFromSuperview];
    [self.alphaView removeFromSuperview];
}

- (void)shareLeftButtonAction{
    
    [self alphaViewAction];
    if (!self.shareImage) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.shopModel.img objectAtIndex:1] objectForKey:@"imgUrl"]]];
        self.shareImage = [UIImage imageWithData:data];
    }
    

    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shopModel.shopName;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shopModel.address image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
- (void)shareRightButtonAction{
    [self alphaViewAction];
    
    if (!self.shareImage) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.shopModel.img objectAtIndex:1] objectForKey:@"imgUrl"]]];
        self.shareImage = [UIImage imageWithData:data];
    }
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shopModel.shopName;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shopModel.address image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"分享成功！");

        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = self.shopModel.shopName;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    if ([WXApi isWXAppInstalled]) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    }
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    _backScrollView.backgroundColor = [UIColor whiteColor];
    self.view = _backScrollView;
    [self createSubViews];
    [self createMerchantDetailInfos];

}

- (void)createSubViews{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, K_UIScreenWidth*2/3)collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(K_UIScreenWidth, K_UIScreenWidth*2/3);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[MerchantCollectionViewCell class] forCellWithReuseIdentifier:@"merchantCell"];
    [self.view addSubview:_collectionView];
    
    self.pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_collectionView.frame)-30, K_UIScreenWidth-60, 20)];
    _pageController.numberOfPages = self.shopModel.img.count-1;
    _pageController.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:_pageController];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        double pageDouble = self.collectionView.contentOffset.x/K_UIScreenWidth;
        int pageInt = (int)(pageDouble + 0.5);
        self.pageController.currentPage = pageInt;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        self.pageController.currentPage = self.collectionView.contentOffset.x/K_UIScreenWidth;
    }
}



- (void)createMerchantDetailInfos{
    self.nameLabel = [UILabel createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(_collectionView.frame)+30, K_UIScreenWidth-32, 30) text:nil textColor:UIColorFromRGB(0x25252f) font:16];
    _nameLabel.text = self.shopModel.shopName;
    [self.view addSubview:_nameLabel];
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(16, CGRectGetMaxY(_collectionView.frame)+30, K_UIScreenWidth-32, CGRectGetHeight(_nameLabel.frame));
    
    UILabel * address = [UILabel createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(_nameLabel.frame)+12, 30, 20) text:@"地址:" textColor:UIColorFromRGB(0x25252f) font:12];
    address.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:address];
    [address sizeToFit];
    address.frame = CGRectMake(16, CGRectGetMaxY(_nameLabel.frame)+12, CGRectGetWidth(address.frame), CGRectGetHeight(address.frame));

    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(address.frame)+10, CGRectGetMinY(address.frame), K_UIScreenWidth-CGRectGetMaxX(address.frame)-10-16, CGRectGetHeight(address.frame))];
    _addressLabel.font = [UIFont systemFontOfSize:12];
    _addressLabel.textColor = UIColor_25252f;
    _addressLabel.numberOfLines = 0;
    _addressLabel.text = self.shopModel.address;
    [self.view addSubview:_addressLabel];
    [_addressLabel sizeToFit];
    _addressLabel.frame = CGRectMake(CGRectGetMaxX(address.frame)+10, CGRectGetMinY(address.frame), K_UIScreenWidth-CGRectGetMaxX(address.frame)-10-16, CGRectGetHeight(_addressLabel.frame));

    
    float nowY = CGRectGetMaxY(_addressLabel.frame);
    
    if ([self.shopModel.tel isEqualToString:@""]||!self.shopModel.tel || self.shopModel.tel.length < 3) {
        //这时候没有商户电话
    }else{
        
        UILabel * phone = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMinX(address.frame), nowY+9, CGRectGetWidth(address.frame), CGRectGetHeight(address.frame)) text:@"电话:" textColor:UIColorFromRGB(0x25252f) font:12];
        [self.view addSubview:phone];
        self.phoneNumberLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(phone.frame)+10, CGRectGetMinY(phone.frame), CGRectGetWidth(_addressLabel.frame), CGRectGetHeight(address.frame)) text:self.shopModel.tel textColor:UIColorFromRGB(0x25252f) font:12];
        [self.view addSubview:_phoneNumberLabel];
        
        nowY = CGRectGetMaxY(_phoneNumberLabel.frame);
    }
    
    if ([self.shopModel.perCost isEqualToString:@""]|| !self.shopModel.perCost) {
        //没有商户的人均消费水平
    }else{
        
        UILabel * money = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMinX(address.frame), nowY+9, CGRectGetWidth(address.frame), CGRectGetHeight(address.frame)) text:@"人均:" textColor:UIColorFromRGB(0x25252f) font:12];
        [self.view addSubview:money];
        self.moneyLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(money.frame)+10, CGRectGetMinY(money.frame), CGRectGetWidth(_addressLabel.frame), CGRectGetHeight(address.frame)) text:nil textColor:UIColorFromRGB(0x25252f) font:12];
        _moneyLabel.text = [NSString stringWithFormat:@"%@ 元/人", self.shopModel.perCost];
        [self.view addSubview:_moneyLabel];
        
        nowY = CGRectGetMaxY(money.frame);
    }
    
    UILabel * star = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMinX(address.frame), nowY+9, CGRectGetWidth(address.frame), CGRectGetHeight(address.frame)) text:@"评分:" textColor:UIColorFromRGB(0x25252f) font:12];
    [self.view addSubview:star];
    self.starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(star.frame)+10, CGRectGetMinY(star.frame), 100, CGRectGetHeight(address.frame)) numberOfStars:5];
    self.starView.scorePercent = [self.shopModel.level floatValue]/5.0;
    self.starView.allowIncompleteStar = YES;
    self.starView.hasAnimation = NO;
    self.starView.userInteractionEnabled = NO;
    [self.view addSubview:_starView];
    
    if ([self.shopModel.tel isEqualToString:@""] || !self.shopModel.tel || self.shopModel.tel.length < 3) {
        //没有电话号码， 就不能拨打电话
    }else{
        UIButton * callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float height = CGRectGetHeight(_starView.frame)*2+9;
        callButton.frame = CGRectMake(K_UIScreenWidth-20-height, CGRectGetMaxY(star.frame)-height, height, height);
        [callButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
        callButton.backgroundColor = [UIColor clearColor];
        [callButton addTarget:self action:@selector(callButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:callButton];
        
    }
    
    self.merchantInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(address.frame), CGRectGetMaxY(_starView.frame)+20, K_UIScreenWidth-2*CGRectGetMinX(address.frame), 20)];
    _merchantInfoLabel.font = [UIFont systemFontOfSize:12];
    _merchantInfoLabel.textColor = [UIColor grayColor];
    _merchantInfoLabel.numberOfLines = 0;
    
    
    NSString * brief = [self.shopModel.brief stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:brief];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [brief length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
    
    [_merchantInfoLabel setAttributedText:attributedString];

    [_merchantInfoLabel sizeToFit];
    [self.view addSubview:_merchantInfoLabel];
    
    UIImageView * mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_merchantInfoLabel.frame)+20, K_UIScreenWidth, K_UIScreenWidth/5)];
    mapView.userInteractionEnabled = YES;
    mapView.image = [UIImage imageNamed:@"map.png"];
    [mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterIntoMapViewController)]];
    [self.view addSubview:mapView];
    self.backScrollView.contentSize = CGSizeMake(K_UIScreenWidth, CGRectGetMaxY(mapView.frame));
    
    UIImageView * mapAddressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    mapAddressImageView.image = [UIImage imageNamed:@"address.png"];
    [mapView addSubview:mapAddressImageView];
    UILabel * mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    mapLabel.font = [UIFont systemFontOfSize:14];
    mapLabel.textAlignment = NSTextAlignmentCenter;
    mapLabel.text = self.shopModel.shopName;
    [mapView addSubview:mapLabel];
    [mapLabel sizeToFit];
    mapAddressImageView.frame = CGRectMake(CGRectGetMidX(self.view.frame)-CGRectGetWidth(mapLabel.frame)/2-7.5-4, CGRectGetHeight(mapView.frame)/2-7.5, 15, 15);
    mapLabel.frame = CGRectMake(CGRectGetMaxX(mapAddressImageView.frame)+4, CGRectGetHeight(mapView.frame)/2-CGRectGetHeight(mapLabel.frame)/2, CGRectGetWidth(mapLabel.frame), CGRectGetHeight(mapLabel.frame));
}

- (void)callButtonAction{
    
    [[UIApplication sharedApplication].keyWindow addSubview:[DarkButton sharedManager]];
    [[DarkButton sharedManager] addTarget:self action:@selector(cancleCallPhone) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.callView) {
        
    }else{
        self.callView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, K_UIScreenWidth-40, 121)];
        _callView.backgroundColor = [UIColor whiteColor];
        _callView.layer.cornerRadius = 3;
        _callView.clipsToBounds = YES;
        UILabel * callLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_callView.frame), 76)];
        callLabel.font = [UIFont systemFontOfSize:16];
        callLabel.textAlignment = NSTextAlignmentCenter;
        NSString * string = [NSString stringWithFormat:@"您将呼叫 %@", self.shopModel.tel];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:string];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, att.length)];
        [att addAttribute:NSForegroundColorAttributeName value:UIColor_ccac58 range:NSMakeRange(0, att.length)];
        callLabel.attributedText = att;
        [self.callView addSubview:callLabel];
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(callLabel.frame), CGRectGetWidth(_callView.frame)-40, 0.5)];
        line.backgroundColor = UIColor_cccccc;
        [self.callView addSubview:line];
        
        UIButton * yesButotn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesButotn.frame = CGRectMake(20, CGRectGetMaxY(line.frame), CGRectGetWidth(line.frame)/2, 44);
        [yesButotn setBackgroundColor:[UIColor clearColor]];
        [yesButotn setTitle:@"取消" forState:UIControlStateNormal];
        [yesButotn setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [yesButotn addTarget:self action:@selector(cancleCallPhone) forControlEvents:UIControlEventTouchUpInside];
        [self.callView addSubview:yesButotn];
        
        UILabel * bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(line.frame), CGRectGetMinY(yesButotn.frame)+10, 1, 24)];
        bottomLine.backgroundColor = UIColor_cccccc;
        [self.callView addSubview:bottomLine];
        
        
        UIButton * cancelButotn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButotn.frame = CGRectMake(CGRectGetMaxX(bottomLine.frame), CGRectGetMinY(yesButotn.frame), CGRectGetWidth(line.frame)/2, 44);
        [cancelButotn setBackgroundColor:[UIColor clearColor]];
        [cancelButotn setTitle:@"确定" forState:UIControlStateNormal];
        [cancelButotn setTitleColor:UIColor_ccac58 forState:UIControlStateNormal];
        [cancelButotn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        [self.callView addSubview:cancelButotn];
        
    }
    
    self.callView.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame), CGRectGetWidth(_callView.frame), CGRectGetHeight(_callView.frame));
    [[UIApplication sharedApplication].keyWindow addSubview:_callView];
    
    [UIView animateWithDuration:Alert_animation_time animations:^{
        _callView.center = [UIApplication sharedApplication].keyWindow.center;
        
    }];

    
}

- (void)callPhone{
    [self cancleCallPhone];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneNumberLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)cancleCallPhone{
    [[DarkButton sharedManager] removeFromSuperview];
    [self.callView removeFromSuperview];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shopModel.img.count-1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MerchantCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"merchantCell" forIndexPath:indexPath];
    NSURL * url = [NSURL URLWithString:[[_shopModel.img objectAtIndex:indexPath.row+1] objectForKey:@"imgUrl"]];
    [cell.merchantImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"111.png"]];
    return cell;
    
}

- (void)enterIntoMapViewController{
 
    MerchantMapViewController * vc = [[MerchantMapViewController alloc] init];
    vc.shopModel = self.shopModel;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
