//
//  doMyTaskViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/5/1.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "doMyTaskViewController.h"
#import "UIColor+Utils.h"
#import "handinViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "webForAVViewController.h"
#import "GlowTopicTableViewController.h"
#import "SDAnalogDataGenerator.h"
#import <UserNotifications/UserNotifications.h>
@interface doMyTaskViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableTen;
@property (nonatomic) NSMutableArray *unFinishedTaskTitleList;
@property (nonatomic) NSMutableArray *finishedTaskTitleList;
@property (nonatomic) NSInteger judgeFinishOrNot;
@property (nonatomic) NSMutableArray *finishedTaskImageList;
@property (nonatomic) NSMutableArray *unFinishedTaskImageList;
@property (nonatomic) NSMutableArray *taskInfoList;
@property (nonatomic) NSMutableArray *createTimeList;
@property (nonatomic) NSMutableArray *deadlineList;
@property (nonatomic) NSMutableArray *taskIdList;
@property (nonatomic) NSMutableArray *commitIdList;
@property (nonatomic) NSMutableArray *questionTitleList;
@property (nonatomic) NSMutableArray *questionIdList;
@property (nonatomic) NSMutableArray *questionFinishTitleList;
@property (nonatomic) NSMutableArray *questionFinishIdList;
@property (nonatomic) NSMutableArray *askNameList;
@property (nonatomic) NSMutableArray *askIdList;
@property (nonatomic) NSUInteger number;
@end

@implementation doMyTaskViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"我的任务";
        NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"未完成",@"已完成",nil];
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
    self.tableTen.delegate = self;
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tableTen.mj_header = header;
    [self.tableTen.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
   // [statusBarView removeFromSuperview];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index)
    {
        case 0:
            self.judgeFinishOrNot = 0;
            [self.tableTen reloadData];
            break;
        case 1:
            self.judgeFinishOrNot = 1;
             [self.tableTen reloadData];
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    if (self.judgeFinishOrNot == 0) {
        NSUInteger row = [indexPath row];
        if(indexPath.section == 0){
            cell.textLabel.text = [self.unFinishedTaskTitleList objectAtIndex:row];
            NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.unFinishedTaskImageList[row] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [decodedImage reSizeImage:decodedImage toSize:reSize];
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
            cell.imageView.image = smallProfile;
            /*//添加本地通知
            UILocalNotification *note = [[UILocalNotification alloc] init];
            NSString *tempstr1 =[self.unFinishedTaskTitleList objectAtIndex:row];
            NSString *tempstr2 = self.deadlineList[indexPath.row];
            NSString *strtemp = [tempstr1 stringByAppendingString:@"截止时间 "];
            NSString *strTemp2 = [strtemp stringByAppendingString:tempstr2];
            note.alertBody =strTemp2;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
            NSDate *dateTime = [formatter dateFromString:self.deadlineList[indexPath.row]];
            NSDate *newdate = [[NSDate date] initWithTimeInterval:-24 *60 * 60 sinceDate:dateTime];
            note.fireDate =newdate;
            NSLog(@"提醒时间%@",note.fireDate);
            NSLog(@"newtime%@",newdate);
            [[UIApplication sharedApplication] scheduleLocalNotification:note];*/
            NSString *tempstr1 =[self.unFinishedTaskTitleList objectAtIndex:row];
            NSString *tempstr2 = @"截止时间 ";
            NSString *strtemp = [tempstr2 stringByAppendingString:self.deadlineList[indexPath.row]];
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
            content.title =tempstr1;
            content.body =strtemp;
            content.sound = [UNNotificationSound defaultSound];
            UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                          triggerWithTimeInterval:5 repeats:NO];
            UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:self.deadlineList[indexPath.row]
                                                                                  content:content trigger:trigger];
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            }];

        }else if(indexPath.section == 1){
            cell.textLabel.text = [self.questionTitleList objectAtIndex:row];
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
        }else if(indexPath.section == 2){
            cell.textLabel.text = [self.askNameList objectAtIndex:row];
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
            
        }

    }
    else{
        if(indexPath.section == 0){
            NSUInteger row = [indexPath row];
            cell.textLabel.text = [self.finishedTaskTitleList objectAtIndex:row];
            NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.finishedTaskImageList[row] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [decodedImage reSizeImage:decodedImage toSize:reSize];
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
            cell.imageView.image = smallProfile;
        }else if(indexPath.section == 1){
            cell.textLabel.text = [self.questionFinishTitleList objectAtIndex:indexPath.row];
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
        }else if(indexPath.section == 2){
          //  cell.textLabel.text = [self.askNameList objectAtIndex:indexPath.row];
          //  cell.imageView.image = [UIImage imageNamed:@"icon@2x.png"];
            
        }
        
    }

       return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        self.titleForSections = @"一般任务";
    }else if(section == 1){
        self.titleForSections = @"问卷";
    }else if(section == 2){
        self.titleForSections = @"讨论区";
    }
    return self.titleForSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (self.judgeFinishOrNot ==0) {
        if(section == 0){
            self.number = self.unFinishedTaskTitleList.count;
        }else if(section == 1){
            self.number = self.questionTitleList.count;
        }else if(section == 2){
            self.number =self.askNameList.count;
        }
    }else{
        if(section == 0){
            self.number = self.finishedTaskTitleList.count;
        }else if(section == 1){
            self.number = self.questionFinishTitleList.count;
        }else if(section == 2){
            self.number = 0;//self.askNameList.count;
        }
    }
    return self.number;
}/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
        //   return CGFLOAT_MIN;
    }
   // return CGFLOAT_MIN;
      return 10.0f;
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.judgeFinishOrNot == 0) {
        if(indexPath.section == 0){
            handinViewController *hand = [[handinViewController alloc] init];
            hand.judgeIfManagerEnterThisPage = 0;
            hand.user1 = self.user1;
            hand.taskId = self.taskIdList[indexPath.row];
            hand.taskDescription = self.taskInfoList[indexPath.row];
            hand.creatTime = self.createTimeList[indexPath.row];
            hand.taskName = self.unFinishedTaskTitleList[indexPath.row];
            hand.deadline = self.deadlineList[indexPath.row];
            [self.navigationController pushViewController:hand animated:YES];
        }else if(indexPath.section == 1){
            webForAVViewController *web = [[webForAVViewController alloc ]init];
            web.a = 2;
            web.userId = self.user1.userId;
            web.qusetionId = self.questionIdList[indexPath.row];
            [self.navigationController pushViewController:web animated:YES];
        }else if(indexPath.section == 2){
            GlowTopicTableViewController *glow = [[GlowTopicTableViewController alloc] init];
            glow.askId = self.askIdList[indexPath.row];
            glow.user1 = self.user1;
            glow.askName = self.askNameList[indexPath.row];
            //glow.rowOfData = [indexPath row];
            [self.navigationController pushViewController:glow animated:YES];
            NSLog(@"进入glow");
        }
    }
    else{
        if(indexPath.section == 0){
            webForAVViewController *m = [[webForAVViewController alloc] init];
            m.a = 4;
            m.str12 = self.commitIdList[indexPath.row];
            [self.navigationController pushViewController:m animated:YES];
        }else if(indexPath.section == 1){
            //问卷填写者没必要看问卷统计结果
        }else if(indexPath.section == 2){
            
        }
    }
}
-(void)headerClick{
    [self getwendaList];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"userid":self.user1.userId,
                          @"p_id":self.projectId,
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
    [manager POST:@"http://112.74.54.96/getTaskList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功任务和%@",responseObject);
        NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        NSDictionary *temp =getDic[@"data"];
        NSDictionary *temp1 = getDic[@"data2"];
        NSMutableArray *questionTitleList = [[NSMutableArray alloc] init];
        NSMutableArray *questionIdList = [[NSMutableArray alloc] init];
        NSMutableArray *questionFinishIdList = [[NSMutableArray alloc] init];
        NSMutableArray *questionFinishTitleList = [[NSMutableArray alloc] init];
        NSMutableArray *titleList=[[NSMutableArray alloc] init];
        NSMutableArray *dateList=[[NSMutableArray alloc] init];
        NSMutableArray *idList=[[NSMutableArray alloc] init];
        NSMutableArray *finishTitleList=[[NSMutableArray alloc] init];
        //  NSMutableArray *finishDList=[[NSMutableArray alloc] init];
        NSMutableArray *finishIdList=[[NSMutableArray alloc] init];
        NSMutableArray *taskCommitId=[[NSMutableArray alloc] init];
        NSMutableArray *questionCommitId =[[NSMutableArray alloc] init];
        NSMutableArray *projectIdList=[[NSMutableArray alloc] init];
        NSMutableArray *projectTitleList = [[NSMutableArray alloc] init];
        NSMutableArray *finishedProjectTitleList = [[NSMutableArray alloc] init];
        NSMutableArray *finishedProjectIdList = [[NSMutableArray alloc] init];
        NSMutableArray *taskImage = [[NSMutableArray alloc] init];
        NSMutableArray *finishedTaskImage =[[NSMutableArray alloc] init];
        NSMutableArray *taskInfoList = [[NSMutableArray alloc] init];
        NSMutableArray *createTimeList = [[NSMutableArray alloc] init];
        NSMutableArray *commitIdList = [[NSMutableArray alloc] init];
        for(int i=0; i<[temp count]; i++) {
            if([getDic[@"data"][i][@"complete"] isEqualToString:@"0"])
            {
                [titleList addObject:getDic[@"data"][i][@"taskTitle"]];
                [dateList addObject:getDic[@"data"][i][@"deadline"]];
                [idList addObject:getDic[@"data"][i][@"task_id"]];
                [taskImage  addObject:getDic[@"data"][i][@"img"]];
                [taskInfoList addObject:getDic[@"data"][i][@"contentDescription"]];
                [createTimeList addObject:getDic[@"data"][i][@"create_time"]];
                
            }else {
                [finishTitleList addObject:getDic[@"data"][i][@"taskTitle"]];
                [finishIdList addObject:getDic[@"data"][i][@"task_id"]];
                [finishedTaskImage  addObject:getDic[@"data"][i][@"img"]];
                [commitIdList addObject:getDic[@"data"][i][@"commitId"]];
            }
        }
        for(int i=0; i<[temp1 count]; i++) {
                if([getDic[@"data2"][i][@"complete"] isEqualToString:@"0"])
                {
                    [questionTitleList addObject:getDic[@"data2"][i][@"questname"]];
                    [questionIdList addObject:getDic[@"data2"][i][@"questtableid"]];
        }else {
                    [questionFinishTitleList addObject:getDic[@"data2"][i][@"questname"]];
                    [questionIdList addObject:getDic[@"data2"][i][@"questtableid"]];
                }
        }

            
        
        /*for(int i=0; i<[temp1 count]; i++) {
            if([getDic[@"data2"][i][@"complete"] isEqualToString:@"0"])
            {
                NSLog(@"jinle");
                [questionTitleList addObject:getDic[@"data2"][i][@"questname"]];
                [questionIdList addObject:getDic[@"data2"][i][@"questtableid"]];
                
            }else {
                [questionFinishTitleList addObject:getDic[@"data2"][i][@"questname"]];
                [questionFinishIdList addObject:getDic[@"data2"][i][@"questtableid"]];
                [questionCommitId addObject:getDic[@"data2"][i][@"commitId"]];
            }
        }*/
        
        self.finishedTaskTitleList = finishTitleList;
        self.unFinishedTaskTitleList = titleList;
        self.finishedTaskImageList = finishedTaskImage;
        self.unFinishedTaskImageList = taskImage;
        self.taskInfoList = taskInfoList;
        self.createTimeList = createTimeList;
        self.deadlineList = dateList;
        self.taskIdList =idList;
        self.commitIdList = commitIdList;
        //问卷
        self.questionTitleList = questionTitleList;
        NSLog(@"###%lu",(unsigned long)self.questionTitleList.count);
        self.questionIdList = questionIdList;
        self.questionFinishTitleList = questionFinishTitleList;
        self.questionFinishIdList = questionFinishIdList;
        [self.tableTen reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.tableTen.mj_header endRefreshing];
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
       // NSLog(@"返回成功问答列表%@",responseObject);
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
