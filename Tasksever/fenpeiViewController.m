//
//  fenpeiViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/24.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "fenpeiViewController.h"
#import "chooseViewController.h"
#import "memberViewController.h"
#import "AFNetworking.h"
#import "UIColor+Utils.h"
#import "buzhirenwuViewController.h"
#import "bianjiwendaViewController.h"
#import "webForAVViewController.h"
@interface fenpeiViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UILabel *weekTextFIeld;
@property (weak, nonatomic) IBOutlet UILabel *yearTextField;
@property (weak, nonatomic) IBOutlet UILabel *dayTextFIeld;
@property (weak, nonatomic) IBOutlet UIImageView *wendaImage;
@property (weak, nonatomic) IBOutlet UIImageView *wenjuanImage;
@property (weak, nonatomic) IBOutlet UIImageView *yibanrenwuImage;
@end

@implementation fenpeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    [self getWeek];
    [self getsSystemTimeDay];
    [self getsSystemTimeYear];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"任务类型";
    //一般任务按钮
    self.yibanrenwuImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockYibanrenwu)];
    [self.yibanrenwuImage addGestureRecognizer:clock3];
    //问卷按钮
    self.wenjuanImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *cll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockWenjuan)];
    [self.wenjuanImage addGestureRecognizer:cll];
    //问答按钮
    self.wendaImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * aaa= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockWenda)];
    [self.wendaImage addGestureRecognizer:aaa];
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
    [statusBarView removeFromSuperview];
}
//发布一般任务
-(void)onClockYibanrenwu{
    buzhirenwuViewController *buzhi = [[buzhirenwuViewController alloc] init];
    buzhi.projectId = self.projectId;
    buzhi.user1 = self.user1;
    [self.navigationController pushViewController:buzhi animated:YES];
}
//发布问卷
-(void)onClockWenjuan{
    webForAVViewController *web = [[webForAVViewController alloc] init];
    web.a = 1;
    web.projectId = self.projectId;
    web.publisherId = self.user1.userId;
    [self.navigationController pushViewController:web animated:YES];
}
//发布问答
-(void)onClockWenda{
    bianjiwendaViewController *bianji = [[bianjiwendaViewController alloc] init];
    bianji.user1 = self.user1;
    bianji.projectId = self.projectId;
    [self.navigationController pushViewController:bianji animated:YES];
}
//获取系统时间日期
-(void)getsSystemTimeDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    self.dayTextFIeld.text = currentTimeString;
}
//获取系统时间年份
-(void)getsSystemTimeYear{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    self.yearTextField.text = currentTimeString;
}
- (void)getWeek{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    int year=[comps year];
    int week = [comps weekday];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    self.weekTextFIeld.text = [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]];
    NSLog(@"%@", [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]]);
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
