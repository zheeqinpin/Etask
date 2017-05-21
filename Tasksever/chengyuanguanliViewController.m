//
//  chengyuanguanliViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "chengyuanguanliViewController.h"
#import "UIColor+Utils.h"
#import "SDAnalogDataGenerator.h"
#import "AFNetworking.h"
@interface chengyuanguanliViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableeee;

@end

@implementation chengyuanguanliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"小组成员",@"进组申请",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(10.0, 20.0,30.0, 30.0);
    
    [segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    [[self navigationItem] setTitleView:segmentedControl];
    self.navigationItem.title = @"小组成员";
    self.tabBarController.tabBar.hidden = YES;
    self.tableeee.dataSource = self;
    self.tableeee.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)segmentClick:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index)
    {
        case 0:
            self.judgeMemberOrJoin = 0;
            [self.tableeee reloadData];
            break;
        case 1:
            self.judgeMemberOrJoin = 1;
            [self.tableeee reloadData];
            break;
        default:
            break;
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableeee reloadData];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.judgeMemberOrJoin == 0){
        if(indexPath.section == 0){
            NSMutableString *strr = [[NSMutableString alloc] initWithFormat:@"(管理员)%@",[self.managerNameList objectAtIndex:indexPath.row]];
            cell.textLabel.text = strr;
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
        }else if(indexPath.section == 1){
            cell.textLabel.text = [self.memberNameList objectAtIndex:indexPath.row];
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
        }
    }else{
        cell.textLabel.text = [self.joinerNameList objectAtIndex:indexPath.row];
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
    if(self.judgeMemberOrJoin == 0){
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.judgeMemberOrJoin == 0){
        if(section == 0){
            return self.managerNameList.count;
        }else{
            return self.memberNameList.count;
        }
    }else{
        return self.joinerNameList.count;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(self.judgeMemberOrJoin == 1){
        //同意申请
        
    }else{
        
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.userPower isEqualToString:@"right"]){
        return YES;
    }
    return NO;
}
/*
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.judgeMemberOrJoin == 0){
        if(editingStyle == UITableViewCellEditingStyleDelete){
            
            if(indexPath.section == 0){
                [self.managerNameList removeObjectAtIndex:indexPath.row];
                [self.tableeee deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else if(indexPath.section == 1){
                [self.memberNameList removeObjectAtIndex:indexPath.row];
                [self.tableeee deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }else if(editingStyle == UITableViewCellEditingStyleInsert){
        }
    }else{
        
        
    }
}*/
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.judgeMemberOrJoin == 1){
        UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"同意" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            NSDictionary *dic = @{
                                  @"send_username":self.joinerNameList[indexPath.row],
                                  @"publisher_name":self.publishName,
                                  @"project_id":self.projectId,
                                  @"judge":@"1",

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
            [manager POST:@"http://112.74.54.96/judgeProjectSubmission" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSLog(@"返回成功%@",responseObject);
                
                
    
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"传输失败:%@",[error localizedDescription]);
            }];

            tableView.editing = NO;
        }];
        
        UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拒绝" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            NSDictionary *dic = @{
                                  @"send_username":self.joinerNameList[indexPath.row],
                                  @"publisher_name":self.publishName,
                                  @"project_id":self.projectId,
                                  @"judge":@"0",
                                  
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
            [manager POST:@"http://112.74.54.96/judgeProjectSubmission" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"返回成功%@",responseObject);
                
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"传输失败:%@",[error localizedDescription]);
            }];
            

            tableView.editing = NO;
        }];
        return @[action2,action0];
    }else{
        UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            if(indexPath.section == 0){
                [self.managerNameList removeObjectAtIndex:indexPath.row];
                [self.tableeee deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else if(indexPath.section == 1){
                [self.memberNameList removeObjectAtIndex:indexPath.row];
                [self.tableeee deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        return @[action1];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
