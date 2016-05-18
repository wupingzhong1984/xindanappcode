//
//  ArticalListViewController.m
//  JieTu
//
//  Created by 开发者 on 15/11/1.
//  Copyright (c) 2015年 meself. All rights reserved.
//

#import "ArticalListViewController.h"
#import "ArticalListCell.h"
#import "ArticalInfoViewController.h"
#import "MJRefresh.h"
#import "ArticalModel.h"
#import "PersonalCentreViewController.h"
#import "MainNavigationController.h"

@interface ArticalListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * articalListArray;
@property(nonatomic, assign)int pageNo;
@end

@implementation ArticalListViewController

-(NSMutableArray *)articalListArray{
    if (!_articalListArray) {
        self.articalListArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _articalListArray;
}

- (void)leftBarButtonItemAction{
    PersonalCentreViewController * vc = [[PersonalCentreViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"心单";
    self.navigationItem.titleView = label;
    //用户安装了微信，可以去登陆页面，没有安装，隐藏。
    //use menu instead of login
//    if ([WXApi isWXAppInstalled]) {
//        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"center.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
//    }
    
    //menu bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[[UIImage imageNamed:@"menu.png"]
                                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                             style:UIBarButtonItemStylePlain
                                             target:(MainNavigationController *)self.navigationController
                                             action:@selector(showMenu)];
    self.pageNo = 1;
    [self creatTableView];
}

- (void)requestData{
   
    NetworkRequest *networkRequest = [CherryHelper getInstance].networkRequest;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:ArticalListType forKey:@"requestType"];
    NSMutableDictionary *arguments=[[NSMutableDictionary alloc] init];
    [arguments setObject:[NSNumber numberWithInt:self.pageNo] forKey:@"pageNo"];
    [arguments setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:arguments forKey:@"arguments"];
    
    //封装好的方法数据请求， 带有回调block
    [networkRequest retrieveJsonWithJSONRequest:JieTuURL parameters:params success:^(NSDictionary *json) {
        
        NSLog(@"=====%@", json);
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (![[json objectForKey:@"fault"] boolValue] ) {

            @try {
                if (self.pageNo == 1) {
                    [self.articalListArray removeAllObjects];
                };
                
                NSArray * array = [[json objectForKey:@"results"] objectForKey:@"articleList"];
                for (int i = 0; i < array.count; i++) {
                    ArticalModel * model = [[ArticalModel alloc] initWithDictionary:[array objectAtIndex:i]];
                    [self.articalListArray addObject:model];
                }
                
                if (self.tableView) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self creatTableView];
                    });
                    
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
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        NSLog(@"%@", error);
    }];
    
}



- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), K_UIScreenWidth, K_UIScreenHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = K_UIScreenWidth*2/3+2;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}


- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在拼命的刷新数据中，请稍后!";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在拼命的加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.pageNo = 1;
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestData];
    });
}

- (void)footerRereshing
{
    self.pageNo++;
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self requestData];
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.articalListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticalListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"articalCell"];
    if (!cell) {
        cell = [[ArticalListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"articalCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ArticalModel * articalModel = [self.articalListArray objectAtIndex:indexPath.row];
    cell.articalModel = articalModel;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ArticalModel * articalModel = [self.articalListArray objectAtIndex:indexPath.row];
    ArticalInfoViewController * vc = [[ArticalInfoViewController alloc] init];
    vc.articleId = articalModel.articleId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
