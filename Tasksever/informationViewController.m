//
//  informationViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/26.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "informationViewController.h"
#import "MJRefresh.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"
#import "SDAnalogDataGenerator.h"
@interface informationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation informationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    //设置头像
    UIImage *profileImage = [UIImage alloc];
    profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
    self.avatarImage.image = profileImage;
    self.view.layer.contents = (id) bground.CGImage;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.layer.borderWidth = 4;
    self.avatarImage.layer.cornerRadius = 60.5;
    self.avatarImage.layer.masksToBounds = true;
    _nameLabel.text = self.userName;
    //添加头像按钮
    self.avatarImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clockww = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockAddAvatar)];
    [self.avatarImage addGestureRecognizer:clockww];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setJudgeIfAddFriend];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
-(void)setJudgeIfAddFriend{
    if(_judgeIfAddFriend == 1){
        UIImage *rightButtonIcon = [[UIImage imageNamed:@"contacts_add_friend"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                        initWithImage:rightButtonIcon
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(addNewFriends)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }else if(_judgeIfAddFriend == 3){
     //   UIImage *rightButtonIcon = [[UIImage imageNamed:@"contacts_add_friend"]
        //                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
            initWithTitle:@"同意" style:UIBarButtonItemStylePlain target:self action:@selector(agreeAddNewFriends)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
}
//从相册选择照片
-(void)onClockAddAvatar{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//保存图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.avatarImage.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addNewFriends{
    //添加代码添加好友
 //   NSLog(@"##&&&&%@",self.user1.userName);
 //   NSLog(@"##&&&&%@",self.userName);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"username" : self.user1.userName,
                          @"friend" : self.userName,
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
    NSLog(@"###添加好友%@",ch);
    [manager POST:@"http://112.74.54.96/addFriend" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        //弹出上传成功 返回上一界面
        NSLog(@"###添加好友%@",responseObject);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已发送好友邀请！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发送邀请失败！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}
-(void)agreeAddNewFriends{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"receive_user" : self.user1.userName,
                          @"submmit_user" : self.userName,
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
    NSLog(@"###添加好友%@",ch);
    [manager POST:@"http://112.74.54.96/adoptFriendSubmission" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        //弹出上传成功 返回上一界面
        NSLog(@"###同意好友%@",responseObject);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已同意好友申请！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
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



@end
