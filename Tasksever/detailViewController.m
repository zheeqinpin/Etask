//
//  detailViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/19.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "detailViewController.h"
#import "AFNetworking.h"
#import "messageViewController.h"
#import "UIColor+Utils.h"
#import "chooseContactsViewController.h"
@interface detailViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *descraptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *memberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *addMemberButton;
@property (weak, nonatomic) IBOutlet UIImageView *addManagerImage;
@property (weak, nonatomic) IBOutlet UIImageView *addAvatarImage;
@property (weak, nonatomic) IBOutlet UITextField *managerTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *avatarTextField;
@property (weak, nonatomic) NSString *encodeImageStr;
@end

@implementation detailViewController{
    UIView *statusBarView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self getMyFriends];
    self.navigationItem.title = @"创建群组";
    self.avatarTextField.text = @"添加群组头像";
    self.user1.userChooseMember = [[NSString alloc] init];
    self.user1.userChooseManager = [[NSString alloc] init];
    self.friendNameList = [[NSMutableArray alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    //添加成员按钮
    self.addMemberButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockImage)];
    [self.addMemberButton addGestureRecognizer:clock];
    //添加头像按钮
    self.addAvatarImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clockww = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockAddAvatar)];
    [self.addAvatarImage addGestureRecognizer:clockww];
    //添加管理员
    self.addManagerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockAddManager)];
    [self.addManagerImage addGestureRecognizer:clock1];
    //项目名
    _titleTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _titleTextView.text=NSLocalizedString(@"标题（必填），4-40字", nil);//提示语
    _titleTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _titleTextView.delegate=self;//代理
    //项目要求
    _descraptionTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _descraptionTextView.text=NSLocalizedString(@"群组介绍（必填），15-500字", nil);//提示语
    _descraptionTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _descraptionTextView.delegate=self;//代理
    //右边按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _memberTextField.text = self.user1.userChooseMember;
    _managerTextField.text = self.user1.userChooseManager;
     self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
     statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
     statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
     [self.navigationController.navigationBar addSubview:statusBarView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [statusBarView removeFromSuperview];
}
-(void)onClockImage{
    chooseContactsViewController *mess = [[chooseContactsViewController alloc] init];
    mess.user1 =self.user1;
    mess.judgeChooseManagerOrMember = 0;
    mess.friendNameList = self.friendNameList;
    [self.navigationController pushViewController:mess animated:YES];
}
-(void)onClockAddManager{
    chooseContactsViewController *mess = [[chooseContactsViewController alloc] init];
    mess.user1 =self.user1;
    mess.judgeChooseManagerOrMember = 1;
    mess.friendNameList = self.friendNameList;
    [self.navigationController pushViewController:mess animated:YES];
}
//从相册选择照片
-(void)onClockAddAvatar{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)endEditing:(id)sender {
    [self.titleTextView resignFirstResponder];
    [self.descraptionTextView resignFirstResponder];
    [self.memberTextField resignFirstResponder];
    [self.managerTextField resignFirstResponder];
    [self.avatarTextField resignFirstResponder];
}
//保存图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //图片转字符串
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodeImageStr= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //字符串转图片
    NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodeImageStr options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    self.avatarImage.image = decodedImage;
    self.avatarImage.layer.cornerRadius = 27;
    self.avatarImage.layer.masksToBounds = true;
    self.avatarTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)complete{
    //创建成功
    //头像转字符串
    NSData *data = UIImageJPEGRepresentation(self.avatarImage.image, 1.0f);
    self.encodeImageStr= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
   
//    NSLog(@"###%@",_titleTextView.text);
//    NSLog(@"###%@",_descraptionTextView.text);
  //  NSLog(@"####成员%@",_memberTextField.text);
 //   NSLog(@"####%@",self.user1.userId);
 //   NSLog(@"####头像%@",self.encodeImageStr);
 //   NSLog(@"####管理员%@",_managerTextField.text);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"projectTitle" : _titleTextView.text,
                          @"committerIds" : _memberTextField.text,
                          @"contentDescription" : self.descraptionTextView.text,
                          @"publisherId": self.user1.userId,
                          @"admins": _managerTextField.text,
                          @"img": _encodeImageStr,
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
    [manager POST:@"http://112.74.54.96/setProject" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        //if([getDic[@"status"] isEqualToString: @"successed"]){
        //弹出上传成功 返回上一界面
     //   NSLog(@"###%@",responseObject);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        
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

    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建成功！" message: @""preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                {
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getMyFriends{
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
        NSLog(@"Register JSON:%@",ch);
    }else{
        NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###%@",ch);
    
    [manager POST:@"http://112.74.54.96/getFriendsList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回好友列表啦%@",responseObject);
        [self.friendNameList removeAllObjects];
        for (int i = 0; i<[responseObject count]; i++) {
            [self.friendNameList addObject:responseObject[i]];
        }
      //  __weak UITableView *tableView = self.tablethree;
     //   [tableView reloadData];
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
