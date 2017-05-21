//
//  checkViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/21.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "checkViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "wanchegnrenViewController.h"
#import "UIColor+Utils.h"
#import "handinViewController.h"
#import "webForAVViewController.h"
#import "GlowTopicTableViewController.h"
#import "SDAnalogDataGenerator.h"
@interface checkViewController (){
    UIView *statusBarView;
}
@property (nonatomic) NSUInteger number;
@property (weak, nonatomic) IBOutlet UITableView *tablefour;
@property (nonatomic) NSInteger judgeTaskType;
@end

@implementation checkViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"任务进度";
        NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"一般任务",@"问卷",@"讨论区",nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
        segmentedControl.frame = CGRectMake(10.0, 20.0,30.0, 30.0);
        
        [segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex=0;
        [[self navigationItem] setTitleView:segmentedControl];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.tablefour.dataSource = self;
    MJRefreshNormalHeader *header1 = [[MJRefreshNormalHeader alloc] init];
    [header1 setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tablefour.mj_header = header1;
    [self.tablefour.mj_header beginRefreshing];
    self.taskTitleList = [[NSMutableArray alloc] init];
    self.taskIdList = [[NSMutableArray alloc] init];
    self.taskImageList = [[NSMutableArray alloc] init];
    self.questioonTitleList = [[NSMutableArray alloc] init];
    self.questionIdList = [[NSMutableArray alloc] init];
    self.askNameList = [[NSMutableArray alloc] init];
    self.askIdList = [[NSMutableArray alloc] init];
    self.taskName = [[NSString alloc] init];
}
- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [self.tablefour reloadData];
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
        statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
        statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
        [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
     //   [statusBarView removeFromSuperview];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index)
    {
        case 0:
            self.judgeTaskType = 0;
            [self.tablefour reloadData];
            break;
        case 1:
            self.judgeTaskType = 1;
            [self.tablefour reloadData];
            break;
        case 2:
            self.judgeTaskType = 2;
            [self.tablefour reloadData];
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    if(self.judgeTaskType == 0){
        cell.textLabel.text = [self.taskTitleList objectAtIndex:indexPath.row];
        NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.taskImageList[indexPath.row] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
        CGSize reSize = CGSizeMake(40, 40);
        UIImage *smallProfile = [decodedImage reSizeImage:decodedImage toSize:reSize];
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = true;
        cell.imageView.image = smallProfile;
    }else if(self.judgeTaskType == 1){
        cell.textLabel.text = [self.questioonTitleList objectAtIndex:indexPath.row];
        UIImage *profileImage = [UIImage alloc];
        profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
        CGSize reSize = CGSizeMake(40, 40);
        UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
        cell.imageView.image = smallProfile;
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = true;
    }else if(self.judgeTaskType == 2){
        cell.textLabel.text = [self.askNameList objectAtIndex:indexPath.row];
        UIImage *profileImage = [UIImage alloc];
        profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
        CGSize reSize = CGSizeMake(40, 40);
        UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
        cell.imageView.image = smallProfile;
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = true;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.judgeTaskType == 0){
        self.number = self.taskTitleList.count;
    }else if(self.judgeTaskType == 1){
        self.number = self.questioonTitleList.count;
    }else if(self.judgeTaskType == 2){
        self.number = self.askNameList.count;
    }
    return  self.number;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(self.judgeTaskType == 0){
            [self.taskTitleList removeObjectAtIndex:indexPath.row];
            [self.tablefour deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(self.judgeTaskType == 1){
            [self.questioonTitleList removeObjectAtIndex:indexPath.row];
            [self.tablefour deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(self.judgeTaskType == 2){
            [self.askNameList removeObjectAtIndex:indexPath.row];
            [self.tablefour deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(self.judgeTaskType == 0){
        self.taskid = self.taskIdList[indexPath.row];
        [self getTaskInfomation];
    }else if(self.judgeTaskType == 1){
        webForAVViewController *web = [[webForAVViewController alloc] init];
        web.a = 5;
        web.questId = self.questionIdList[indexPath.row];
        [self.navigationController pushViewController:web animated:YES];
    }else if(self.judgeTaskType == 2){
        GlowTopicTableViewController *glow = [[GlowTopicTableViewController alloc] init];
        glow.askId = self.askIdList[indexPath.row];
        glow.user1 = self.user1;
        glow.askName = self.askNameList[indexPath.row];
        //glow.rowOfData = [indexPath row];
        [self.navigationController pushViewController:glow animated:YES];
        NSLog(@"进入glow");
    }
}
-(void)headerClick{
    // 模拟延迟3秒
    [self getwendaList];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSDictionary *dic = @{
                          @"p_id":self.projectId,
                          @"user_id":self.user1.userId,
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
    NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getMyPublishList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"返回成功任务和问卷%@",responseObject);
        [self.taskTitleList removeAllObjects];
        [self.taskIdList removeAllObjects];
        [self.taskImageList removeAllObjects];
        [self.questioonTitleList removeAllObjects];
        [self.questionIdList removeAllObjects];
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [self.taskTitleList addObject:responseObject[@"data"][i][@"taskTitle"]];
            [self.taskIdList addObject:responseObject[@"data"][i][@"taskId"]];
            [self.taskImageList addObject:responseObject[@"data"][i][@"img"]];
        }
        for (int i = 0; i<[responseObject[@"data2"] count]; i++) {
            [self.questioonTitleList addObject:responseObject[@"data2"][i][@"questTitle"]];
            [self.questionIdList addObject:responseObject[@"data2"][i][@"questId"]];
        }
        
        __weak UITableView *tableView = self.tablefour;
        
        [tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];

    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.tablefour.mj_header endRefreshing];
    
}
-(void)getTaskInfomation{
    // 模拟延迟3秒
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSDictionary *dic = @{
                          @"taskId":self.taskid,
                            
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
     //   NSLog(@"Register JSON:%@",ch);
    }else{
     //   NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getEnglishTask" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"任务信息%@",responseObject);
            self.taskDesc = responseObject[@"data"][@"contentDescription"];
            self.creatTime = responseObject[@"data"][@"publish_time"];
            self.deadLine = responseObject[@"data"][@"deadline"];
            self.taskName = responseObject[@"data"][@"taskTitle"];
       
            //   NSLog(@"###%@",self.creatTime);
        if(self.taskDesc != nil){
            handinViewController *hand = [[handinViewController alloc] init];
            hand.user1 = self.user1;
            hand.taskId = self.taskid;
            hand.taskDescription = self.taskDesc;
            hand.creatTime = self.creatTime;
            hand.deadline = self.deadLine;
            hand.judgeIfManagerEnterThisPage = 1;
            hand.taskName = self.taskName;
           
            [self.navigationController pushViewController: hand  animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}
-(void)getwendaList{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"projectId":self.projectId,
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
    [manager POST:@"http://112.74.54.96/getAsksList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功问答列表%@",responseObject);
        NSMutableArray *askIdList= [[NSMutableArray alloc] init];
        NSMutableArray *askNameList = [[NSMutableArray alloc] init];
        for (int i = 0; i<[responseObject count]; i++) {
            [askNameList addObject:responseObject[i][@"title"]];
            [askIdList addObject:responseObject[i][@"id"]];
        }
        self.askIdList = askIdList;
        self.askNameList = askNameList;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
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
