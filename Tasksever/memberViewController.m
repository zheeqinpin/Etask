//
//  memberViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/9.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "memberViewController.h"
#import "AFNetworking.h"
#import "UIColor+Utils.h"
#import "SDAnalogDataGenerator.h"
@interface memberViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *membertable;
@end
@implementation memberViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"小组成员";
    self.tabBarController.tabBar.hidden = YES;
    self.selectIndexs = [[NSMutableArray alloc ] init];
   // self.user1.userChooseProjectMember = [[NSString alloc] init];
    self.membertable.dataSource = self;
    self.membertable.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.membertable reloadData];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    NSString *str = [self.selectIndexs componentsJoinedByString:@","];
    self.user1.userChooseProjectMember = str;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [statusBarView removeFromSuperview];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        cell.textLabel.text = [self.MemberNameList objectAtIndex:indexPath.row];
        UIImage *profileImage = [UIImage alloc];
        profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
        CGSize reSize = CGSizeMake(40, 40);
        UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
        cell.imageView.image = smallProfile;
        cell.imageView.layer.cornerRadius = 20;
        cell.imageView.layer.masksToBounds = true;
    }
    
 //   cell.detailTextLabel.text =[self.idList objectAtIndex:row];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
        //   return CGFLOAT_MIN;
    }
   // return CGFLOAT_MIN;
      return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return self.managerNameList.count;
    }else{
        return self.MemberNameList.count;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
     UITableViewCell *cell = [ self.membertable cellForRowAtIndexPath: indexPath];
    if(indexPath.section == 0){
        if (cell.accessoryType == UITableViewCellAccessoryNone){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectIndexs addObject:[self.managerNameList objectAtIndex:indexPath.row]];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectIndexs removeObject:[self.managerNameList objectAtIndex:indexPath.row]];
        }
    }else if(indexPath.section == 1){
        if (cell.accessoryType == UITableViewCellAccessoryNone){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectIndexs addObject:[self.MemberNameList objectAtIndex:indexPath.row]];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectIndexs removeObject:[self.MemberNameList objectAtIndex:indexPath.row]];
        }
    }
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
