//
//  taskManageViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "taskManageViewController.h"
#import "AFNetworking.h"
#import "ProjectHomePageViewController.h"
#import "webForAVViewController.h"
#import "GlowTopicTableViewController.h"
#import "UIColor+Utils.h"
#import "SDAnalogDataGenerator.h"
@interface taskManageViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tabletwo;
@property (weak, nonatomic) IBOutlet UISearchBar *searchGroup;

@end

@implementation taskManageViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"我的群组";
        self.tabBarItem.title = @"我的群组";
        UIImage *h = [UIImage imageNamed:@"taskManage.png"];
        self.tabBarItem.image =h;
        
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.questionName = [[NSMutableArray alloc] init];
    self.questionId = [[NSMutableArray alloc] init];
    self.projectDescription =  [[NSMutableArray alloc] init];
    self.projectId =  [[NSMutableArray alloc] init];
    self.projectTitle =  [[NSMutableArray alloc] init];
    self.projectImage =  [[NSMutableArray alloc] init];
    self.publiseNameList = [[NSMutableArray alloc] init];
    self.tabletwo.dataSource = self;
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tabletwo.mj_header = header;
    [self.tabletwo.mj_header beginRefreshing];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabletwo reloadData];
    self.tabBarController.tabBar.hidden = NO;
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
    cell.imageView.image = smallProfile; //decodedImage;
    cell.detailTextLabel.text = [self.projectDescription objectAtIndex:indexPath.row];
    //截止日期显示
    cell.detailTextLabel.text = [self.projectDescription objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
- (IBAction)endEditing:(id)sender {
    [self.searchGroup resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ProjectHomePageViewController *pro = [[ProjectHomePageViewController alloc] init];
    pro.user1 = self.user1;
    pro.projectId = self.projectId[indexPath.row];
    pro.projectTitle = self.projectTitle[indexPath.row];
    pro.publishName = self.publiseNameList[indexPath.row];
    pro.projectDescription = self.projectDescription[indexPath.row];
    pro.judgeWhoEnterThisPage = 1;
    pro.projectImageString = self.projectImage[indexPath.row];
    [self.navigationController pushViewController:pro animated:YES];
}
-(void)headerClick{
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                           @"userid":self.user1.userId,
                           };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    //    NSLog(@"Register JSON:%@",ch);
    }else{
      //  NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
   NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getMyPublishProject" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功我创建的群组%@",responseObject);
     //   NSLog(@"返回数据%@",responseObject);
        [self.questionName removeAllObjects];
        [self.questionId removeAllObjects];
        [self.projectId removeAllObjects];
        [self.projectTitle removeAllObjects];
        [self.projectDescription removeAllObjects];
        [self.projectImage removeAllObjects];
        [self.publiseNameList removeAllObjects];
        for (int i = 0; i<[responseObject[@"data1"] count]; i++) {
            [self.questionName addObject:responseObject[@"data1"][i][@"q_name"]];
         //   NSLog(@"shuzu %@",self.finishTitleList[i]);
            [self.questionId addObject:responseObject[@"data1"][i][@"id"]];
        }
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [self.projectTitle addObject:responseObject[@"data"][i][@"p_name"]];
            [self.projectId addObject:responseObject[@"data"][i][@"p_id"]];
            [self.projectDescription addObject:responseObject[@"data"][i][@"p_info"]];
            [self.projectImage addObject:responseObject[@"data"][i][@"p_img"]];
            [self.publiseNameList addObject:responseObject[@"data"][i][@"publish_name"]];
        }
        __weak UITableView *tableView = self.tabletwo;
        NSLog(@"####%lu",(unsigned long)self.projectTitle.count);
        [tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.tabletwo.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getQuestion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"userid":self.user1.userId,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        NSLog(@"Register JSON:%@",ch);
    }else{
        NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
  //  NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getMyPublishProject" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"返回成功%@",responseObject);


        __weak UITableView *tableView = self.tabletwo;
        
        [tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];

}

@end
