//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "ArticalListViewController.h"
//#import "HomePageViewController.h"
#import "PersonalCentreViewController.h"
#import "ShopKindModel.h"
#import "DetailViewController.h"

@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

//user view's subviews
@property(nonatomic, strong)UIImageView * userFaceImgV;
@property(nonatomic, strong)UILabel * userNameLbl;
@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property (nonatomic,assign) BOOL didLogin;
@property (nonatomic,strong) NSString *userId;
@property(nonatomic, strong)NSMutableArray * shopKindList;
@end

@implementation LeftMenuViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 189.0f)];
        self.userFaceImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_userFaceImgV setCenter:CGPointMake(view.frame.size.width/2, 40+_userFaceImgV.frame.size.height/2)];
        _userFaceImgV.image = [UIImage imageNamed:@"photo.png"]; //wechat
        _userFaceImgV.layer.masksToBounds = YES;
        _userFaceImgV.layer.cornerRadius = 50.0;
        _userFaceImgV.layer.borderColor = [UIColor whiteColor].CGColor;
        _userFaceImgV.layer.borderWidth = 3.0f;
        _userFaceImgV.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _userFaceImgV.layer.shouldRasterize = YES;
        _userFaceImgV.clipsToBounds = YES;
        
        self.userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 160, 30)];
        _userNameLbl.text = @"游客";  //wechat
        _userNameLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _userNameLbl.backgroundColor = [UIColor whiteColor];
        _userNameLbl.textColor = UIColor_alert;
        _userNameLbl.textAlignment = NSTextAlignmentCenter;
//        [_userNameLbl sizeToFit];
//        _userNameLbl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:_userFaceImgV];
        [view addSubview:_userNameLbl];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = CGRectMake(0, 0, 200, 184.0f);
        [touchBtn addTarget:self action:@selector(touchUserView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:touchBtn];
        
        view;
    });
    self.tableView.tableFooterView = [UIView new];
    
    [self initShopKindList];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateIndexPath" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentIndexPath:) name:@"updateIndexPath" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self userDidLogin] && _didLogin) {
        
        NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        NSString *curUserId = [dic objectForKey:@"userId"];
        if (![curUserId isEqualToString:_userId]) {
            NSString *userName = [dic objectForKey:@"userName"];
            NSString *userIcon = [dic objectForKey:@"userIcon"];
            if (userIcon.length > 0)
                [self.userFaceImgV sd_setImageWithURL:[NSURL URLWithString:userIcon] placeholderImage:nil];
            if (userName.length > 0)
                self.userNameLbl.text = userName;
            
            self.userId = curUserId;
        }
    }
    
    if ([self userDidLogin] && !_didLogin) {
        //update tableheaderview
        NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        NSString *userName = [dic objectForKey:@"userName"];
        NSString *userIcon = [dic objectForKey:@"userIcon"];
        self.userId = [dic objectForKey:@"userId"];
        if (userIcon.length > 0)
            [self.userFaceImgV sd_setImageWithURL:[NSURL URLWithString:userIcon] placeholderImage:nil];
        if (userName.length > 0)
            self.userNameLbl.text = userName;
        
        _didLogin = YES;
    }
    
    if (![self userDidLogin] && _didLogin) {
        //update tableheaderview
        self.userFaceImgV.image = [UIImage imageNamed:@"photo.png"];;
        self.userNameLbl.text = @"游客";
        self.userId = @"";
        _didLogin = NO;
    }
}

-(void)viewDidLayoutSubviews
{
    //分割线顶到最左
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (BOOL)userDidLogin {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
}

- (void)touchUserView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)initShopKindList {
    
    if (!_shopKindList) {
        self.shopKindList = [NSMutableArray arrayWithCapacity:1];
    }
    NSArray *shopKindNames = [NSArray arrayWithObjects:ShopKindNames];
    ShopKindModel *coffee = [[ShopKindModel alloc] init];
    coffee.shopKindId = @"COFFEE";
    coffee.shopKindName = shopKindNames[0];
    coffee.img = @"coffee.png";
    [_shopKindList addObject:coffee];
    
    ShopKindModel *japan = [[ShopKindModel alloc] init];
    japan.shopKindId = @"JAPAN";
    japan.shopKindName = shopKindNames[1];
    japan.img = @"japanse.png";
    [_shopKindList addObject:japan];
    
    ShopKindModel *night = [[ShopKindModel alloc] init];
    night.shopKindId = @"NIGHT";
    night.shopKindName = shopKindNames[2];
    night.img = @"nightLift.png";
    [_shopKindList addObject:night];
    
    ShopKindModel *chinese = [[ShopKindModel alloc] init];
    chinese.shopKindId = @"CHINESE";
    chinese.shopKindName = shopKindNames[3];
    chinese.img = @"middleFood.png";
    [_shopKindList addObject:chinese];
    
    ShopKindModel *brunch = [[ShopKindModel alloc] init];
    brunch.shopKindId = @"BRUNCH";
    brunch.shopKindName = shopKindNames[4];
    brunch.img = @"lunch.png";
    [_shopKindList addObject:brunch];
    
    ShopKindModel *western = [[ShopKindModel alloc] init];
    western.shopKindId = @"WESTERN";
    western.shopKindName = shopKindNames[5];
    western.img = @"westFood.png";
    [_shopKindList addObject:western];
}

- (void)updateCurrentIndexPath:(NSNotification *)aNotification {
    
    NSDictionary *userInfo = aNotification.userInfo;
    self.selectedIndex = [userInfo objectForKey:@"indexpath"];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = UIColor_alert;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    
    //分割线顶到最左
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return (sectionIndex > 0)?10:0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && ![WXApi isWXAppInstalled]) {
    
        [self.frostedViewController hideMenuViewController];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您还未安装微信，请先安装。"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"安装", nil];
        [alert show];
        return;
        
    }
    
    if ([_selectedIndex isEqual:indexPath]) {
        [self.frostedViewController hideMenuViewController];
        return;
    }
    
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    if (indexPath.section == 0) { //artical
        
        ArticalListViewController *articalVC = [[ArticalListViewController alloc] init];
        navigationController.viewControllers = @[articalVC];

    } else if (indexPath.section == 2) { //personcentre
        
        PersonalCentreViewController *personVC = [[PersonalCentreViewController alloc] init];
        navigationController.viewControllers = @[personVC];

    } else if (indexPath.section == 1) {
        
        ShopKindModel *kind = [self.shopKindList objectAtIndex:indexPath.row];
        DetailViewController * detailVC = [[DetailViewController alloc] init];
        detailVC.shopKindModel = kind;
        detailVC.hidesBottomBarWhenPushed = YES;
        navigationController.viewControllers = @[detailVC];
    }
    self.selectedIndex = indexPath;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3; //artical + food type + person centre
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    switch (sectionIndex) {
        case 0:
            return 1;//artical
        case 1:
            return 6;//food type 6
        default:
            return 1;//person centre
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"每日推荐";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"个人中心";
    } else {
        NSArray *titles = [NSArray arrayWithObjects:ShopKindNames];
        cell.textLabel.text = [NSString stringWithFormat:@"#%@",titles[indexPath.row]];
    }
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
    }
}

@end
