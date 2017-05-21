//
//  chooseViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/25.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "chooseViewController.h"
#import "UIColor+Utils.h"

@interface chooseViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tablesss;

@end

@implementation chooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tablesss.dataSource = self;
    self.navigationItem.title = @"小组成员";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tablesss reloadData];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger row = [indexPath row];
    //任务名显示
    cell.textLabel.text = [self.chooseMemberNameList objectAtIndex:row];
    UIImage *profileImage = [UIImage alloc];
    profileImage = [UIImage imageNamed:@"bg.jpg"];
    CGSize reSize = CGSizeMake(40, 40);
    UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
    cell.imageView.image = smallProfile;
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.masksToBounds = true;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.chooseMemberNameList.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

}
/*-(IBAction)creatQuestion:(id)sender{
  /*  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功！" message: @" "preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                {
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];   */
    //上传
   // self.str3  对应任务描述
  //  self.str2  对任务名称
  //  self.str5  对应项目名
 /*   NSLog(@"  任务名%@",self.str2);
    NSLog(@"  任务描述%@",self.str3);
    NSLog(@"  项目名%@",self.str5);
    NSLog(@"  发布者ID%@",self.user1.userId);
    for (int i=0; i<self.selectmember.count; i++) {
        
        NSLog(@"  选定人员%@",self.selectmember[i]);
    }
  
    
    //[NSNumber numberWithDouble:_stepper2.value];
    NSString *tempString = [self.selectmember componentsJoinedByString:@";"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"taskTitle" : self.str2,  //任务名
                           @"deadline" : self.str5,   //项目名
                          @"contentDescription" : self.str3,  //任务描述
                          @"publisherId" : self.user1.userId,   //发布者ID
                          @"committerIds": tempString,      //被要求完成者
                        @"videoTypeNumber" : @0,
                               @"wordTypeNumber" :@0
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
    [manager POST:@"http://112.74.54.96/setEnglishTask" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        if([getDic[@"status"] isEqualToString: @"successed"]){
            //弹出上传成功 返回上一界面
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                        }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if(self.str2 == nil || self.str3== nil){
            //.....
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布失败！" message:@"请检查输入是否为空！" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            
                                        }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布失败！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];

    
    
}*/
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
