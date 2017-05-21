//
//  wanchegnrenViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/26.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "wanchegnrenViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "webForAVViewController.h"
#import "UIColor+Utils.h"
#import "SDAnalogDataGenerator.h"

@interface wanchegnrenViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tablerrrr;

@end

@implementation wanchegnrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"已提交",@"未提交",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(10.0, 20.0,30.0, 30.0);
    
    [segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    [[self navigationItem] setTitleView:segmentedControl];
    self.navigationItem.title = @"已上传任务成员";
    self.tablerrrr.dataSource = self;
    MJRefreshNormalHeader *header1 = [[MJRefreshNormalHeader alloc] init];
    [header1 setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tablerrrr.mj_header = header1;
    
    
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index)
    {
        case 0:
            self.judgeIfFinishMemberList = 0;
            [self.tablerrrr reloadData];
            break;
        case 1:
            self.judgeIfFinishMemberList = 1;
            [self.tablerrrr reloadData];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tablerrrr reloadData];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];//
    NSUInteger row = [indexPath row];
    if(self.judgeIfFinishMemberList == 0){
        //任务名显示
        cell.textLabel.text = [self.finishNameLis objectAtIndex:row];
        UIImage *profileImage = [UIImage alloc];
        profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
        CGSize reSize = CGSizeMake(40, 40);
        UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
        cell.imageView.image = smallProfile;
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = true;
        //截止日期显示
        //cell.detailTextLabel.text = [self.idList objectAtIndex:row];
    }else{
        cell.textLabel.text = [self.unfinishNameLis objectAtIndex:row];
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
    if(self.judgeIfFinishMemberList == 0){
        return self.finishNameLis.count;
    }else{
        return self.unfinishNameLis.count;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(self.judgeIfFinishMemberList == 0){
            [self.finishNameLis removeObjectAtIndex:indexPath.row];
            [self.tablerrrr deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(self.judgeIfFinishMemberList== 1){
            [self.unfinishNameLis removeObjectAtIndex:indexPath.row];
            [self.tablerrrr deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(self.judgeIfFinishMemberList == 0){
        webForAVViewController *m = [[webForAVViewController alloc] init];
        m.a = 3;
        m.commitId = self.finishIdList[indexPath.row];
        [self.navigationController pushViewController:m animated:YES];
    }
    
}
-(void)headerClick{
    // 可在此处实现下拉刷新时要执行的代码
    // ......
   /* AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                           @"t_id":self.taskId,
                           @"signal":@0,
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

    [manager POST:@"http://112.74.54.96/getFinishList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功%@",responseObject);
        //    NSLog(@"返回数据%@",responseObject[0][@"taskTitle"]);
        [self.NameList1 removeAllObjects];
        [self.comitIdList1 removeAllObjects];
        for (int i = 0; i<[responseObject count]; i++) {
            [self.NameList1 addObject:responseObject[i][@"commitName"]];
            [self.comitIdList1 addObject:responseObject[i][@"commitId"]];
        }
        
        __weak UITableView *tableView = self.tablerrrr;
        
        [tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];*/
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.tablerrrr.mj_header endRefreshing];
    
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
