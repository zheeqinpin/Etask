//
//  buzhirenwuViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "buzhirenwuViewController.h"
#import "memberViewController.h"
#import "AFNetworking.h"
#import "UIColor+Utils.h"
@interface buzhirenwuViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITextView *timuTextView; //标题
@property (weak, nonatomic) IBOutlet UITextView *yaoqiuTextView;  //要求
@property (weak, nonatomic) IBOutlet UIImageView *chengyuanImage;
@property (weak, nonatomic) IBOutlet UIImageView *tupianImage;
@property (weak, nonatomic) IBOutlet UIImageView *jiezhishijianImage;
@property (weak, nonatomic) IBOutlet UITextField *chengyuanTextField; //成员
@property (weak, nonatomic) IBOutlet UITextField *jiezhiriqiTextField;  //截止时间
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *avatarTextField;
@property (weak, nonatomic) NSString *currentTime;  //当前时间
@property (weak, nonatomic) NSString *encodeImageStr;  //头像转字符串
@end

@implementation buzhirenwuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"任务分配";
    self.memberNameList = [[NSMutableArray alloc] init];
    self.managerNameList = [[NSMutableArray alloc] init];
    self.user1.userChooseProjectMember = [[NSString alloc] init];
    self.avatarTextField.text = @"添加图片";
    //任务名
    _timuTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _timuTextView.text=NSLocalizedString(@"任务标题（必填），4-40字", nil);//提示语
    _timuTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _timuTextView.delegate=self;//代理
    //任务介绍
    _yaoqiuTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _yaoqiuTextView.text=NSLocalizedString(@"任务介绍（必填），15-500字", nil);//提示语
    _yaoqiuTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _yaoqiuTextView.delegate=self;//代理
    //添加成员
    self.chengyuanImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockChengyuan)];
    [self.chengyuanImage addGestureRecognizer:clock1];
    //添加截止日期
    self.jiezhishijianImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock1e = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockJiezhiriqi)];
    [self.jiezhishijianImage addGestureRecognizer:clock1e];
    //添加头像
    self.tupianImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock1e2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockAddAvatar)];
    [self.tupianImage addGestureRecognizer:clock1e2];
    //右边按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _chengyuanTextField.text = self.user1.userChooseProjectMember;
    [self getProjectMember];
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
//选择成员
-(void)onClockChengyuan{
    memberViewController *mem = [[memberViewController alloc] init];
    mem.MemberNameList = self.memberNameList;
    mem.managerNameList = self.managerNameList;
    mem.user1 = self.user1;
    [self.navigationController pushViewController:mem animated:YES];
}
- (IBAction)endEditing:(id)sender {
    [self.timuTextView resignFirstResponder];
    [self.yaoqiuTextView resignFirstResponder];
    [self.chengyuanTextField resignFirstResponder];
    [self.jiezhiriqiTextField resignFirstResponder];
    [self.avatarTextField resignFirstResponder];
}
//选择截止日期
-(void)onClockJiezhiriqi{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        //求出当天的时间字符串
        _jiezhiriqiTextField.text = dateString;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}
//选择头像
-(void)onClockAddAvatar{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.avatarImage.image = image;
    self.avatarImage.layer.cornerRadius = 27.5;
    self.avatarImage.layer.masksToBounds = true;
    self.avatarTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}
//获取当前系统时间
-(void)getsSystemTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    self.currentTime = currentTimeString;
}
-(void)complete{
    [self getsSystemTime];
    //头像转字符串
    NSData *data = UIImageJPEGRepresentation(self.avatarImage.image, 1.0f);
    self.encodeImageStr= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
  //  NSLog(@"###标题%@",self.timuTextView.text);
//    NSLog(@"###任务要求%@",self.yaoqiuTextView.text);
    NSLog(@"###成员%@",self.chengyuanTextField.text);
//    NSLog(@"###图片%@",self.encodeImageStr);
    NSLog(@"###截止时间%@",self.jiezhiriqiTextField.text);
    NSLog(@"###当前间%@",self.currentTime);
    //发布任务上传至服务器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"p_id" :self.projectId,
                          @"publisherId" : self.user1.userId,
                          @"taskTitle" : self.timuTextView.text,
                          @"contentDescription": self.yaoqiuTextView.text,
                          @"committerIds": self.chengyuanTextField.text,
                          @"img":_encodeImageStr,
                          @"dealline":self.jiezhiriqiTextField.text,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        // NSLog(@"Register JSON:%@",ch);
    }else{
        NSLog(@"error");
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/setEnglishTask" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                    //    [self.navigationController popToRootViewControllerAnimated:YES];
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布失败！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.textColor==[UIColor lightGrayColor])//如果是提示内容，光标放置开始位置
    {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor])//如果不是delete响应,当前是提示信息，修改其属性
    {
        textView.text=@"";//置空
        textView.textColor=[UIColor blackColor];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor=[UIColor lightGrayColor];
        textView.text=NSLocalizedString(@"", nil);
    }
}
-(void)getProjectMember{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"p_id":self.projectId,
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
    [manager POST:@"http://112.74.54.96/getProjectMember" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功群组的成员哈哈哈%@",responseObject);
        [self.memberNameList removeAllObjects];
        [self.managerNameList removeAllObjects];
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [self.memberNameList addObject:responseObject[@"data"][i][@"u_name"]];
            
        }
        for (int i = 0; i<[responseObject[@"data2"] count]; i++) {
            [self.managerNameList addObject:responseObject[@"data2"][i]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
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
