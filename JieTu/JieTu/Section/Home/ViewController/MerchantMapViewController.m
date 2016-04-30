//
//  MerchantMapViewController.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "MerchantMapViewController.h"
#import <MapKit/MapKit.h>
#import "ShopModel.h"

@interface MerchantMapViewController ()<MKMapViewDelegate>
@property(nonatomic, strong)MKMapView * mapView;
@end

@implementation MerchantMapViewController

- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.color = [UIColor grayColor];
    activity.frame = CGRectMake(0, 0, 200, 100);
    activity.center = self.view.center;
    activity.hidesWhenStopped = YES;
    activity.tag = 555;
    [self.view addSubview:activity];
    [activity startAnimating];

    
    [self createMapView];
    
}

- (void)createMapView{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.rotateEnabled = NO;
    _mapView.pitchEnabled = NO;
    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
    //如果后台给的有经纬度
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.shopModel.address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLLocation * location = ((CLPlacemark *)[placemarks firstObject]).location;
        NSLog(@"%g ------ %g", location.coordinate.latitude, location.coordinate.longitude);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
        [_mapView setRegion:region animated:true];
        //初始化一个大头针类
        MKPointAnnotation * ann = [[MKPointAnnotation alloc]init];
        //设置大头针坐标
        ann.coordinate=location.coordinate;
        ann.title = self.shopModel.shopName;
        [_mapView addAnnotation:ann];
        
        [self.view addSubview:_mapView];
        UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:555];
        [activity stopAnimating];
        [activity removeFromSuperview];

        
        
        
        }];
//    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //创建一个系统大头针对象
    MKPinAnnotationView * view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    view.pinColor=MKPinAnnotationColorRed;//设置颜色为绿色
    view.canShowCallout = YES;
    
    return view;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
