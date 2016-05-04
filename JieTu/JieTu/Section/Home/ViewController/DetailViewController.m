//
//  DetailViewController.m
//  JieTu
//
//  Created by 开发者 on 15/10/25.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "DetailViewController.h"
#import "SWTableViewCell.h"
#import "MerchantViewController.h"
#import "DetailTableViewCell.h"
#import "ShopModel.h"
#import "ShopKindModel.h"
#import "PersonalCentreViewController.h"
#import "ShopKindNoneView.h"
#import "ArticalListViewController.h"
#import "MainNavigationController.h"



@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)UILabel * leftLabel;
@property(nonatomic, strong)UILabel * rightLabel;
@property(nonatomic, strong)UILabel * leftLine;
@property(nonatomic, strong)UILabel * rightLine;

@property(nonatomic, strong)NSMutableArray * dataLeftArray;
@property(nonatomic, strong)NSMutableArray * dataRightArray;
@property(nonatomic, strong)NSString * leftOrRight;

//@property(nonatomic, strong)UIImageView * loginImageView;
@property(nonatomic, strong)ShopKindNoneView * noneView;
@end

@implementation DetailViewController

-(ShopKindNoneView *)noneView{
    if (!_noneView) {
        self.noneView = [[ShopKindNoneView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 217)];
        self.noneView.center = self.view.center;
        [self.noneView.bottomButton addTarget:self action:@selector(toAdd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noneView;
}
- (void)toAdd{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateIndexPath" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], @"indexpath", nil]];
    ArticalListViewController *articalVC = [[ArticalListViewController alloc] init];
    self.navigationController.viewControllers = @[articalVC];
}

-(NSMutableArray *)dataLeftArray{
    if (!_dataLeftArray) {
        self.dataLeftArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataLeftArray;
}

-(NSMutableArray *)dataRightArray{
    if (!_dataRightArray) {
        self.dataRightArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataRightArray;
}

- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = self.shopKindModel.shopKindName;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Menu"
                                             style:UIBarButtonItemStylePlain
                                             target:(MainNavigationController *)self.navigationController
                                             action:@selector(showMenu)];
    self.leftOrRight = @"left";
    [self createTopButtons];
    [self createTableView];
    [self requestData];
}

- (void)requestData{
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:DetailShopKindShopsType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:self.shopKindModel.shopKindId forKey:@"shopKindId"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
#pragma mark ---
            @try {
                NSArray * shopGetList = [[json objectForKey:@"results"] objectForKey:@"shopGetList"];
                NSArray * shopNoGetList = [[json objectForKey:@"results"] objectForKey:@"shopNoGetList"];
                for (int i = 0; i < shopGetList.count; i++) {//去过
                    ShopModel * model = [[ShopModel alloc] initWithDictionary:[shopGetList objectAtIndex:i]];
                    [self.dataRightArray addObject:model];
                }
                for (int i = 0; i < shopNoGetList.count; i++) {//没去过
                    ShopModel * model = [[ShopModel alloc] initWithDictionary:[shopNoGetList objectAtIndex:i]];
                    [self.dataLeftArray addObject:model];
                }
                
                [self handleDataAfterRequest];
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

- (void)handleDataAfterRequest{
    if ([self.leftOrRight isEqualToString:@"left"]) {
        [self.tableView reloadData];
        if (self.dataLeftArray.count != 0) {
        }else{
            [self.view addSubview:self.noneView];
            [self.view bringSubviewToFront:self.noneView];

        }
    }else{
    
        [self.tableView reloadData];
        if (self.dataRightArray.count != 0) {
            
        }else{
            [self.view addSubview:self.noneView];
            [self.view bringSubviewToFront:self.noneView];

        }
    }
}

- (void)createTopButtons{
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, 0.5)];
    line.backgroundColor = UIColor_line;
    [self.view addSubview:line];
    
    self.leftLabel = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), 20, 14) text:@"心愿单" textColor:UIColor_ccac58 font:14];
    [self.view addSubview:_leftLabel];
    [_leftLabel sizeToFit];
    _leftLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame)-50-CGRectGetWidth(_leftLabel.frame)/2, CGRectGetMaxY(self.navigationController.navigationBar.frame)+14, CGRectGetWidth(_leftLabel.frame), CGRectGetHeight(_leftLabel.frame));
    
    self.rightLabel = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetMinY(self.leftLabel.frame), 20, 14) text:@"去过" textColor:UIColorFromRGB(0x25252f) font:14];
    [self.view addSubview:_rightLabel];
    [_rightLabel sizeToFit];
    _rightLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame)+50-CGRectGetWidth(_rightLabel.frame)/2, CGRectGetMinY(self.leftLabel.frame), CGRectGetWidth(_rightLabel.frame), CGRectGetHeight(_rightLabel.frame));

    self.leftLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_leftLabel.frame), CGRectGetMaxY(_leftLabel.frame)+7, CGRectGetWidth(_leftLabel.frame), 2)];
    _leftLine.backgroundColor = UIColor_ccac58;
    [self.view addSubview:_leftLine];
    
    self.rightLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_rightLabel.frame), CGRectGetMaxY(_rightLabel.frame)+7, CGRectGetWidth(_rightLabel.frame), 2)];
    _rightLine.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rightLine];

    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_leftLabel.frame)-20, CGRectGetMidY(_leftLabel.frame)-10, CGRectGetWidth(_leftLabel.frame)+40, CGRectGetHeight(_leftLabel.frame)+20)];
    leftView.backgroundColor = [UIColor clearColor];
    [leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftbuttonAction)]];
    [self.view addSubview:leftView];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_rightLabel.frame)-20, CGRectGetMidY(_rightLabel.frame)-10, CGRectGetWidth(_rightLabel.frame)+40, CGRectGetHeight(_rightLabel.frame)+20)];
    rightView.backgroundColor = [UIColor clearColor];
    [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonAction)]];
    [self.view addSubview:rightView];
}

- (void)leftbuttonAction{
    
    [self.noneView removeFromSuperview];
    
    self.leftLine.backgroundColor = UIColor_ccac58;
    self.leftLabel.textColor = UIColor_ccac58;
    
    self.rightLine.backgroundColor = [UIColor clearColor];
    self.rightLabel.textColor = UIColor_25252f;
    self.leftOrRight = @"left";
    [self handleDataAfterRequest];
}
- (void)rightButtonAction{
    [self.noneView removeFromSuperview];

    self.leftLine.backgroundColor = [UIColor clearColor];
    self.leftLabel.textColor = UIColor_25252f;
    
    self.rightLine.backgroundColor = UIColor_ccac58;
    self.rightLabel.textColor = UIColor_ccac58;
    self.leftOrRight = @"right";
    [self handleDataAfterRequest];

}


- (void)createTableView{
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftLine.frame)+7, K_UIScreenWidth, 0.5)];
    line.backgroundColor = UIColor_line;
    [self.view addSubview:line];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), K_UIScreenWidth, CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(line.frame)) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([self.leftOrRight isEqualToString:@"left"]) ? self.dataLeftArray.count : self.dataRightArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.leftOrRight isEqualToString:@"right"]) {
        static NSString * detailRightCell = @"detailRightCell";
        DetailTableViewCell * cell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:detailRightCell];
        if (!cell) {
            cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailRightCell];
        }
        
        ShopModel * model = [self.dataRightArray objectAtIndex:indexPath.row];
        [cell setShopModel:model];
        
        return cell;
        
    }
    
    
    
    static NSString *detailLeftCell = @"detailLeftCell";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:detailLeftCell];
    if (cell == nil) {
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:204.0/255 green:172.0/255 blue:88.0/255 alpha:1.0]
                                                 title:@"去过"];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1.0f]
                                                 title:@"删除"];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:detailLeftCell
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
        
        cell.detailLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 61.5, 61.5)];
 //       cell.detailLeftImageView.backgroundColor = [UIColor orangeColor];
        cell.detailLeftImageView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:((SWTableViewCell *)cell).detailLeftImageView];
        
        cell.detailNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(((SWTableViewCell *)cell).detailLeftImageView.frame)+16, 16, K_UIScreenWidth-CGRectGetMaxX(((SWTableViewCell *)cell).detailLeftImageView.frame), 16)];
        cell.detailNameLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailNameLabel.font = [UIFont systemFontOfSize:16];
        cell.detailNameLabel.textColor = UIColorFromRGB(0x25252f);
        [cell.contentView addSubview:((SWTableViewCell *)cell).detailNameLabel];
        
        UIImageView * addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(cell.detailNameLabel.frame), CGRectGetMaxY(cell.detailNameLabel.frame)+10, 13, 13)];
        addImageView.image = [UIImage imageNamed:@"address_line.png"];
        [cell.contentView addSubview:addImageView];
        
        
        cell.detailAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(cell.detailNameLabel.frame)+17, CGRectGetMaxY(cell.detailNameLabel.frame)+10, K_UIScreenWidth-CGRectGetMinX(cell.detailNameLabel.frame)-17, 12)];
        cell.detailAddressLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailAddressLabel.font = [UIFont systemFontOfSize:12];
        cell.detailAddressLabel.textColor = UIColorFromRGB(0x25252f);
        [cell.contentView addSubview:cell.detailAddressLabel];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, K_UIScreenWidth, 0.5)];
        line.backgroundColor = UIColor_line;
        [cell.contentView addSubview:line];
        
        }
    ShopModel * model = [self.dataLeftArray objectAtIndex:indexPath.row];
    
    ((SWTableViewCell *)cell).detailNameLabel.text = model.shopName;
    ((SWTableViewCell *)cell).detailAddressLabel.text = model.address;
    NSString * url = [[model.img firstObject] objectForKey:@"imgUrl"];
    [((SWTableViewCell *)cell).detailLeftImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"detailDefault.png"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ShopModel * shopModel;
    if ([self.leftOrRight isEqualToString:@"left"]) {
        shopModel = [self.dataLeftArray objectAtIndex:indexPath.row];
    }else{
        shopModel = [self.dataRightArray objectAtIndex:indexPath.row];
    }
    MerchantViewController * vc = [[MerchantViewController alloc] init];
    
    vc.shopModel = shopModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view did begin dragging");
}

#pragma mark - SWTableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)loginAnimation{
    [[DarkButton sharedManager] removeFromSuperview];
    [[MyAlertView sharedManager] removeFromSuperview];
    PersonalCentreViewController * vc = [[PersonalCentreViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    
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
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    
    switch (index) {
        case 0:
        {
            
            [self haveGoneShopAtIndexPath:cellIndexPath];
//            [self.tableView reloadData];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            
            [self deleteShopAtIndexPath:cellIndexPath];
            [cell hideUtilityButtonsAnimated:YES];

            break;
        }
        default:
            break;
    }
}

//去过
- (void)haveGoneShopAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopModel * shopModel = (ShopModel *)[self.dataLeftArray objectAtIndex:indexPath.row];
    NSLog(@"gone  %@", indexPath);
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ShopGoneDeleteAdd forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    
    [arguments setObject:self.shopKindModel.shopKindId forKey:@"shopKindId"];
    [arguments setObject:shopModel.shopId forKey:@"shopId"];
    [arguments setObject:@"G" forKey:@"actionType"];
    
    
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
#pragma mark ---
            @try {
                if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                    
                    [self.dataRightArray addObject:[self.dataLeftArray objectAtIndex:indexPath.row]];
                    [self.dataLeftArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    NSLog(@"删除成功");
                    
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
//删除
- (void)deleteShopAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"delete  %@", indexPath);
    
    ShopModel * shopModel = (ShopModel *)[self.dataLeftArray objectAtIndex:indexPath.row];
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ShopGoneDeleteAdd forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    
    [arguments setObject:self.shopKindModel.shopKindId forKey:@"shopKindId"];
    [arguments setObject:shopModel.shopId forKey:@"shopId"];
    [arguments setObject:@"D" forKey:@"actionType"];
    
    
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        if (![[json objectForKey:@"fault"] boolValue] ) {
#pragma mark ---
            @try {
                if ([[[json objectForKey:@"results"] objectForKey:@"errorMessage"] isEqualToString:@"ok"]) {
                    
                    [self.dataLeftArray removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    NSLog(@"删除成功");
                    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
