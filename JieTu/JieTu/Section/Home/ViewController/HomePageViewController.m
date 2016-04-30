//
//  HomePageViewController.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "SWTableViewCell.h"
#import "DetailViewController.h"
#import "ArticalListViewController.h"
#import "ArticalModel.h"
#import "ShopKindModel.h"
#import "HomeCollectionViewCell.h"
#import "ModifyView.h"
#import "DataBase.h"

@interface HomePageViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>
//@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)UIButton * alphaButton;
@property(nonatomic, strong)UITextField * textField;
@property(nonatomic, strong)UIView * alphaView;

//@property(nonatomic, strong)NSIndexPath * renameIndexPath;
//@property(nonatomic, strong)NSIndexPath * deleteIndexPath;


@property(nonatomic, strong)NSMutableArray * shopKindList;

//1219改版最新
@property(nonatomic, strong)UICollectionView * collectionView;
@property(nonatomic, strong)ModifyView * modifyView;
@property(nonatomic, strong)ShopKindModel * modifyShopKindModel;
@property(nonatomic, strong)NSString * cancelShopKind;
@end

@implementation HomePageViewController

//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float height = keyboardRect.size.height;

    if (CGRectGetMaxY(self.alphaView.frame) + height > CGRectGetMaxY(self.alphaButton.frame)) {
        self.alphaView.frame = CGRectMake(20, CGRectGetMaxY(self.alphaButton.frame)-height-CGRectGetHeight(self.alphaView.frame)-10, CGRectGetWidth(self.alphaView.frame), CGRectGetHeight(self.alphaView.frame));
    }
}

//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.alphaView.center = self.alphaButton.center;
}

- (void)leftBarButtonItemAction{
    LoginViewController * vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightBarButtonItemAction{
    
    if (![CherryHelper checkUserLoginOrNot]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:[DarkButton sharedManager]];
        
        MyAlertView * alert = [MyAlertView sharedManager];
        alert.alertLabel.text = @"Ops!";
        alert.alertLabel.font = [UIFont boldSystemFontOfSize:20];
        [alert.trueButton setTitle:@"一键微信登陆 即可随心所欲" forState:UIControlStateNormal];
        alert.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame), CGRectGetWidth(alert.frame), CGRectGetHeight(alert.frame));
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        [UIView animateWithDuration:Alert_animation_time animations:^{
            
            CGPoint center = [UIApplication sharedApplication].keyWindow.center;
            alert.center = CGPointMake(center.x, center.y-20);
            [self performSelector:@selector(loginAnimation) withObject:nil afterDelay:2.0];
        }];
        return;
    }
    [self modifyCollectionViewCell];
}
#pragma mark --------添加新的心愿单
- (void)addShopKind{
    
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ShopKindHandleType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:@"A" forKey:@"actionType"];
    [arguments setObject:self.textField.text forKey:@"shopKindName"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
            
            @try {
                if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                    //删除成功
                    ShopKindModel * addModel = [[ShopKindModel alloc] init];
                    addModel.shopKindName = self.textField.text;
                    addModel.shopKindId = [[json objectForKey:@"results"] objectForKey:@"shopKindId"];
                    
                    [self.shopKindList addObject:addModel];
//                    [self.tableView reloadData];
                    self.textField.text = nil;
                }
            }
            @catch (NSException *exception) {
                self.textField.text= nil;
                
                NSLog(@"%@", exception);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            @finally {
                
            }
            
        }else{
            self.textField.text= nil;
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        self.textField.text= nil;
        
        NSLog(@"%@", error);
    }];

}


#pragma mark --------删除心愿单

- (void)deleteShopKind{
    
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ShopKindHandleType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:@"D" forKey:@"actionType"];
    [arguments setObject:self.modifyShopKindModel.shopKindId forKey:@"shopKindId"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
            
            @try {
                if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                    //删除成功
                   
                    [self.shopKindList removeObject:self.modifyShopKindModel];
                    [self.collectionView reloadData];
                    
                }
                
                
            }
            @catch (NSException *exception) {

                NSLog(@"%@", exception);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            @finally {
                
            }
            
            self.modifyShopKindModel = nil;

            
        }else{
            self.modifyShopKindModel = nil;

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self modifyViewNoBtnAction];

    } failure:^(NSError *error) {
        self.modifyShopKindModel = nil;
        [self modifyViewNoBtnAction];

        NSLog(@"%@", error);
    }];

}

/*

#pragma mark --------重命名心愿单

- (void)renameShopKind{
    
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ShopKindHandleType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:@"M" forKey:@"actionType"];
    [arguments setObject:shopKindModel.shopKindId forKey:@"shopKindId"];
    [arguments setObject:self.textField.text forKey:@"shopKindName"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        if (![[json objectForKey:@"fault"] boolValue] ) {
            
            @try {
                if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                    //重命名成功
                    ShopKindModel * shopKindModel = [_shopKindList objectAtIndex:_renameIndexPath.row];
                    shopKindModel.shopKindName = self.textField.text;
                    self.textField.text = @"";
//                    [self.tableView reloadRowsAtIndexPaths:@[_renameIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    self.renameIndexPath = nil;
                }
            }
            @catch (NSException *exception) {
                self.renameIndexPath = nil;

                NSLog(@"%@", exception);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            @finally {
                self.renameIndexPath = nil;

            }
            
        }else{
            self.renameIndexPath = nil;

            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        self.renameIndexPath = nil;

        NSLog(@"%@", error);
    }];
}

*/
 
- (void)alphaButton:(UIButton *)btn{
    
    BOOL is = [self.textField resignFirstResponder];
    if (is) {
        
    }else{
        self.modifyShopKindModel = nil;
        self.textField.text = @"";
        [btn removeFromSuperview];
        [self.alphaView removeFromSuperview];
    }
}



-(NSMutableArray *)shopKindList{
    if (!_shopKindList) {
        self.shopKindList = [NSMutableArray arrayWithCapacity:1];
    }
    return _shopKindList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    label.text = @"心单";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
    
    //用户安装了微信，可以去登陆页面，没有安装，隐藏。
    if ([WXApi isWXAppInstalled]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"center.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    }
    self.cancelShopKind = @"0";
    [self creatCollection];
    [self requestData];
}

- (void)requestData{
    [self.shopKindList removeAllObjects];
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:HomePageType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
            
            @try {
                NSArray * array = [[json objectForKey:@"results"] objectForKey:@"shopKindList"];
                for (int i = 0; i < array.count; i++) {
                    ShopKindModel * model = [[ShopKindModel alloc] initWithDictionary:[array objectAtIndex:i]];
                    [self.shopKindList addObject:model];
                }
                
                [self.collectionView reloadData];

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


- (void)creatCollection{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    layout.itemSize = CGSizeMake((K_UIScreenWidth-3)/2.0, (K_UIScreenWidth-3)/2.0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, CGRectGetMinY(self.tabBarController.tabBar.frame)-CGRectGetMaxY(self.navigationController.navigationBar.frame)) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"homeCollectionCell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shopKindList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCollectionCell" forIndexPath:indexPath];
    ShopKindModel * model = self.shopKindList[indexPath.row];
    [cell setShopKindModel:model];
    cell.modifyBtn.tag = 2000+indexPath.row;
    [cell.modifyBtn addTarget:self action:@selector(collectionViewCellModifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController * detailVC = [[DetailViewController alloc] init];
    detailVC.titleString = [self.shopKindList objectAtIndex:indexPath.row];
    detailVC.shopKindModel = [self.shopKindList objectAtIndex:indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)collectionViewCellModifyBtnAction:(UIButton *)btn{
    
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
    
    self.modifyShopKindModel = [self.shopKindList objectAtIndex:btn.tag-2000];
    [self modifyCollectionViewCell];
}




- (void)modifyCollectionViewCell{
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [[DarkButton sharedManager] addTarget:self action:@selector(darkBtnAnction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:[DarkButton sharedManager]];
//    [window addSubview:[DarkButton sharedManager]];
    
    if (self.modifyView) {
        
    }else{
        self.modifyView = [[ModifyView alloc] initWithFrame:CGRectMake(20, 0, K_UIScreenWidth-40, 415)];
        [self.modifyView.addImageBtn addTarget:self action:@selector(modifyViewAddimageBtnAnction) forControlEvents:UIControlEventTouchUpInside];
        [self.modifyView.cancelBtn addTarget:self action:@selector(modifyViewCancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.modifyView.noBtn addTarget:self action:@selector(modifyViewYesBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.modifyView.yesBtn addTarget:self action:@selector(modifyViewNoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (self.modifyShopKindModel) {
        _modifyView.textField.text = self.modifyShopKindModel.shopKindName;
        NSInteger a = [self.shopKindList indexOfObject:self.modifyShopKindModel];
        NSIndexPath * index = [NSIndexPath indexPathForItem:a inSection:0];
        HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:index];
        [_modifyView.addImageBtn setImage:cell.backImageView.image forState:UIControlStateNormal];
        _modifyView.topLabel.text = @"修改心愿单";
        _modifyView.addImageLabel.text = @"修改背景图";
        _modifyView.cancelBtn.hidden = NO;
        
    }else{
        _modifyView.textField.text = @"";
        _modifyView.textField.placeholder = @"请输入名称";
        [_modifyView.addImageBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        _modifyView.topLabel.text = @"添加心愿单";
        _modifyView.addImageLabel.text = @"添加背景图";
        _modifyView.cancelBtn.hidden = YES;
    }
    
    [self.view addSubview:_modifyView];
    _modifyView.center = self.view.center;
    
//    [window addSubview:_modifyView];
//    _modifyView.center = window.center;

}

//修改心愿单背景点击
- (void)darkBtnAnction:(UIButton *)btn{
    
    BOOL is = [self.modifyView.textField resignFirstResponder];
    if (is) {
        
    }else{
        [self modifyViewNoBtnAction];

           }

}
//删除心愿单
- (void)modifyViewCancelBtnAction{
    UIColor * goldColor = UIColor_ccac58;
    if ([self.cancelShopKind isEqualToString:@"0"]) {
        
        self.modifyView.cancelBtn.backgroundColor = goldColor;
        [_modifyView.cancelBtn setTitle:@"删除心愿单" forState:UIControlStateNormal];
        [_modifyView.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelShopKind = @"1";
    }else{
        self.modifyView.cancelBtn.backgroundColor = [UIColor whiteColor];
        [_modifyView.cancelBtn setTitle:@"删除心愿单" forState:UIControlStateNormal];
        [_modifyView.cancelBtn setTitleColor:goldColor forState:UIControlStateNormal];
        self.cancelShopKind = @"0";
    }
    
  //  [self deleteShopKind];

}

//添加图片按钮事件
- (void)modifyViewAddimageBtnAnction{
    [self getImageFromCamera];
}
//确认修改心愿单
- (void)modifyViewYesBtnAction{
    NSLog(@"上传图片");
    [self upLoadButtonDoClick];
}
//取消修改心愿单
- (void)modifyViewNoBtnAction{
    
    self.modifyShopKindModel = nil;
    self.cancelShopKind = @"0";
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [[DarkButton sharedManager] removeFromSuperview];
    [self.modifyView removeFromSuperview];
}


#pragma mark 调用相机或者相册
- (void)getImageFromCamera{
    UIActionSheet *sheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:sheet];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 取消
                return;
            case 1:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        if (buttonIndex == 0) {
            
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    //调用照相机功能
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    
}




////照相机的选择图片的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //自己选择图片后的回调方法。
    [self.modifyView.addImageBtn setImage:image forState:UIControlStateNormal];
    NSLog(@"得到了image");
    
    
}
//点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"取消了image");
}



#pragma mark UpLoadButtonDoClick上传图片按钮
- (void)upLoadButtonDoClick{
    if (self.modifyShopKindModel && [self.cancelShopKind isEqualToString:@"1"]) {
        [self deleteShopKind];
        self.cancelShopKind = @"0";
        return;
    }
    
    
    if (self.modifyView.textField.text.length == 0) {
        [CherryHelper alert:@"请输入心愿单名称"];
        return;
    }
    
    
    if (!self.modifyView.addImageBtn.currentImage || [self.modifyView.addImageBtn.currentImage isEqual:[UIImage imageNamed:@"add.png"]]){
        [CherryHelper  alert:@"请先选择图片或拍照"];
        return;
    }
    
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.color = UIColor_ccac58;
    activity.frame = CGRectMake(0, 0, 200, 100);
    activity.hidesWhenStopped = YES;
    activity.tag = 666;
    [self.view addSubview:activity];
    activity.center = self.view.center;
    [activity startAnimating];
    self.view.userInteractionEnabled = NO;
    
    
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    [params setObject:ShopKindHandleType forKey:@"requestType"];
    
    [params setObject:@"APP_IOS" forKey:@"sysCode"];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
    if (dic){
        NSString * userId = [dic objectForKey:@"userId"];
        if (userId != nil){
            [params setObject:userId forKey:@"userId"];
            
        }
        
    }
    
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [params setObject:arguments forKey:@"arguments"];
    if (!self.modifyShopKindModel) {
        [arguments setObject:@"A" forKey:@"actionType"];
        
    }else{
        [arguments setObject:self.modifyShopKindModel.shopKindId forKey:@"shopKindId"];
        [arguments setObject:@"M" forKey:@"actionType"];

    }
    [arguments setObject:self.modifyView.textField.text forKey:@"shopKindName"];
    
    [networkRequest uploadImage:JieTuURL parameters:params image:self.modifyView.addImageBtn.currentImage success:^(id responseObject)
     {
         NSDictionary *json = [DataBase jsonData2NSDictionary:responseObject];
         if (![[json objectForKey:@"fault"] boolValue]) {
             NSLog(@"上传成功0000%@", json);
             
         }else{
             [CherryHelper alert:@"上传失败,请重新上传！"];
         }
         self.modifyShopKindModel = nil;
         [self requestData];
         [self modifyViewNoBtnAction];
         UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:666];
         [activity stopAnimating];
         [activity removeFromSuperview];
         self.view.userInteractionEnabled = YES;

         
     } failure:^(NSError *error)
     {
         NSLog(@"Error: %@", error.description);
         self.modifyShopKindModel = nil;

         [self modifyViewNoBtnAction];
         UIActivityIndicatorView * activity = (UIActivityIndicatorView *)[self.view viewWithTag:666];
         [activity stopAnimating];
         [activity removeFromSuperview];
         self.view.userInteractionEnabled = YES;


         
     }];
    
}













    /*
    self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, K_UIScreenWidth*2/3)];
    _topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.userInteractionEnabled = YES;
    [_topImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterIntoArticalListViewController)]];
    
    [self.view addSubview:_topImageView];
    
#pragma mark --------添加蒙层的灰色效果
    //添加蒙层的灰色效果
    UIView * grayView = [[UIView alloc] initWithFrame:_topImageView.bounds];
    grayView.backgroundColor = UIColor_25252f;
    grayView.alpha = 0.3;
    [_topImageView addSubview:grayView];
    
    self.topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImageView.frame)/2-10, K_UIScreenWidth, 20)];
    _topTitleLabel.font = [UIFont systemFontOfSize:20];
    _topTitleLabel.textColor = [UIColor whiteColor];
    _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_topImageView addSubview:_topTitleLabel];
    
    self.topTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topTitleLabel.frame)+6, K_UIScreenWidth, 16)];
    _topTimeLabel.font = [UIFont systemFontOfSize:16];
    _topTimeLabel.textColor = [UIColor whiteColor];
    _topTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_topImageView addSubview:_topTimeLabel];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _topImageView;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
     */


#pragma mark UITableViewDataSource

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _shopKindList.count;
//}
//
//#pragma mark ------选中某个cell
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    DetailViewController * detailVC = [[DetailViewController alloc] init];
//    detailVC.titleString = [self.shopKindList objectAtIndex:indexPath.row];
//    detailVC.shopKindModel = [self.shopKindList objectAtIndex:indexPath.row];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *homeCellIdentifier = @"Cell";
//    
//    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:homeCellIdentifier];
//    
//    if (cell == nil) {
//        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//        
//        [rightUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:204.0/255 green:172.0/255 blue:88.0/255 alpha:1.0]
//                                                 title:@"重命名"];
//        [rightUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:50/255 green:50/255 blue:50/255 alpha:1.0f]
//                                                 title:@"删除"];
//        
//        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                      reuseIdentifier:homeCellIdentifier
//                                  containingTableView:_tableView // Used for row height and selection
//                                   leftUtilityButtons:nil
//                                  rightUtilityButtons:rightUtilityButtons];
//        
//        
//        ((SWTableViewCell *)cell).titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 60-0.5)];
//        ((SWTableViewCell *)cell).titleLabel.backgroundColor = [UIColor whiteColor];
//        ((SWTableViewCell *)cell).titleLabel.textAlignment = NSTextAlignmentCenter;
//        ((SWTableViewCell *)cell).titleLabel.textColor = UIColorFromRGB(0x25252f);
//        ((SWTableViewCell *)cell).titleLabel.font = [UIFont systemFontOfSize:16];
//        [cell.contentView addSubview:((SWTableViewCell *)cell).titleLabel];
//        
//        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 60-0.5, K_UIScreenWidth, 0.5)];
//        line.backgroundColor = UIColorFromRGB(0xcccccc);
//        [cell.contentView addSubview:line];
//
//        cell.delegate = self;
//    }
//    
//    return cell;
//}
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    
//
//    NSLog(@"scroll view did begin dragging");
//}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Set background color of cell here if you don't want white
//    ShopKindModel * kindModel = _shopKindList[indexPath.row];
//    NSString * string = kindModel.shopKindName;
//    ((SWTableViewCell *)cell).titleLabel.text = string;
//
//}

#pragma mark - SWTableViewDelegate

- (void)loginAnimation{
    [[DarkButton sharedManager] removeFromSuperview];
    [[MyAlertView sharedManager] removeFromSuperview];
    [self leftBarButtonItemAction];
}

//- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
//    
//    
//    if (![CherryHelper checkUserLoginOrNot]) {
//        [[UIApplication sharedApplication].keyWindow addSubview:[DarkButton sharedManager]];
//        
//        MyAlertView * alert = [MyAlertView sharedManager];
//        alert.alertLabel.text = @"Ops!";
//        alert.alertLabel.font = [UIFont boldSystemFontOfSize:20];
//        [alert.trueButton setTitle:@"一键微信登陆 即可随心所欲" forState:UIControlStateNormal];
//        alert.frame = CGRectMake(20, CGRectGetMaxY(self.view.frame), CGRectGetWidth(alert.frame), CGRectGetHeight(alert.frame));
//        [[UIApplication sharedApplication].keyWindow addSubview:alert];
//        
//        [UIView animateWithDuration:Alert_animation_time animations:^{
//            alert.center = [UIApplication sharedApplication].keyWindow.center;
//            [self performSelector:@selector(loginAnimation) withObject:nil afterDelay:2.0];
//        }];
//        return;
//        
//    }
//    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//    switch (index) {
//        case 0:
//        {
//            
//            self.renameIndexPath = cellIndexPath;
//            [self rightBarButtonItemAction];
//            
//            [cell hideUtilityButtonsAnimated:YES];
//            break;
//        }
//        case 1:
//        {
//            self.deleteIndexPath = cellIndexPath;
//            [self deleteShopKind];
//
//            break;
//        }
//        default:
//            break;
//    }
//}

//
//- (void)swippableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
//    
//    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//    if (state == kCellStateRight) {
//        
//        if ((self.rightScrollIndexPath != indexPath) && self.rightScrollIndexPath) {
//            SWTableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.rightScrollIndexPath];
//            [cell hideUtilityButtonsAnimated:YES];
//
//        }
//        self.rightScrollIndexPath = indexPath;
//        
//        NSLog(@"right");
//    }else{
//
//    }
//}
//
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
