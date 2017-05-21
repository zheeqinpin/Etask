//
//  contactsViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "contactsViewController.h"
#import "handinViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "webForAVViewController.h"
#import "GlowTopicTableViewController.h"
#import "UIColor+Utils.h"
#import "ProjectHomePageViewController.h"
@interface contactsViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchGroup;
@property (weak, nonatomic) IBOutlet UITableView *mytable;            //未读消息数量提醒Label
@end

@implementation contactsViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.tabBarItem.title = @"参与群组";
        UIImage *h = [UIImage imageNamed:@"work32.net.png"];
        self.tabBarItem.image =h;
        self.navigationItem.title = @"参与群组";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.mytable.dataSource=self;
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.mytable.mj_header = header;
    [self.mytable.mj_header beginRefreshing];
    self.publiseNameList = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.mytable reloadData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [statusBarView removeFromSuperview];
}
- (IBAction)endEditing:(id)sender {
    [self.searchGroup resignFirstResponder];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [self.projectTitle objectAtIndex:indexPath.row];
    NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.projectImage[indexPath.row] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    CGSize reSize = CGSizeMake(40, 40);
    UIImage *smallProfile = [decodedImage reSizeImage:decodedImage toSize:reSize];
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.masksToBounds = true;
    cell.imageView.image = smallProfile;
    cell.detailTextLabel.text = [self.projectDescription objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
         return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectTitle.count;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
        //   return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
    //  return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ProjectHomePageViewController *proff = [[ProjectHomePageViewController alloc] init];
    proff.judgeWhoEnterThisPage = 0;
    proff.user1 = self.user1;
    proff.projectId = self.projectId[indexPath.row];
    proff.projectTitle = self.projectTitle[indexPath.row];
    proff.projectDescription = self.projectDescription[indexPath.row];
    proff.projectImageString = self.projectImage[indexPath.row];
    proff.userPower = self.userPower[indexPath.row];
    proff.publishName = self.publiseNameList[indexPath.row];
    NSLog(@"###%@",proff.userPower);
    [self.navigationController pushViewController:proff animated:YES];
}
-(void)headerClick{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"username":self.user1.userName,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
      //  NSLog(@"Register JSON:%@",ch);
    }else{
     //   NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getMyProject" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功参与的群组%@",responseObject);
        NSMutableArray *projectIdList= [[NSMutableArray alloc] init];
        NSMutableArray *projectNameList = [[NSMutableArray alloc] init];
        NSMutableArray *projectImageList =[[NSMutableArray alloc] init];
        NSMutableArray *projectInfoList = [[NSMutableArray alloc] init];
        NSMutableArray *userRights = [[NSMutableArray alloc] init];
        [self.publiseNameList removeAllObjects];
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [projectNameList addObject:responseObject[@"data"][i][@"name"]];
            [projectIdList addObject:responseObject[@"data"][i][@"id"]];
            [userRights addObject:responseObject[@"data"][i][@"power"]];
            [projectImageList addObject:responseObject[@"data"][i][@"img"]];
            [projectInfoList addObject:responseObject[@"data"][i][@"info"]];
            [self.publiseNameList addObject:responseObject[@"data"][i][@"publish_name"]];
        }
        self.projectId = projectIdList;
        self.projectTitle = projectNameList;
        self.projectDescription = projectInfoList;
        self.projectImage = projectImageList;
        self.userPower = userRights;
        NSLog(@"####%@",self.userPower);
        [self.mytable reloadData];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.mytable.mj_header endRefreshing];
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
