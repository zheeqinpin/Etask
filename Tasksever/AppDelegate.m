//
//  AppDelegate.m
//  Tasksever
//
//  Created by zln on 16/11/3.
//  Copyright © 2016年 zln. All rights reserved.
//

#import "AppDelegate.h"
#import "contactsViewController.h"
#import "homePageViewController.h"
#import "taskManageViewController.h"
#import "messageViewController.h"
#import "loginViewController.h"
#import "webForAVViewController.h"
#import "GlobalVar.h"
#import "JhtDocFileOperations.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];      self.window = [[UIWindow alloc ] initWithFrame:
                   [[UIScreen mainScreen] bounds]];
    NSBundle *appBundle = [NSBundle mainBundle];
   loginViewController *l = [[loginViewController alloc]
                                     initWithNibName:@"loginViewController"
                                      bundle:appBundle];
   //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:l];
    self.window.rootViewController = l;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // 三方跳转
    if (launchOptions) {
        NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
        // 根据“其他应用” 用“本应用”打开，通过url，进入列表页
        [self pushDocListViewControllerWithUrl:url];
    }

    return YES;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

#pragma mark - ApplicationDelegate
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
        NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];
        NSLog(@"%@", str);
        if (self.window && url) {
            // 根据“其他应用” 用“本应用”打开，通过url，进入列表页
            [self pushDocListViewControllerWithUrl:url];
        }
    }
    return YES;
}


#pragma mark ApplicationDelegate Method
/** 根据“其他应用” 用“本应用”打开，通过url，进入列表页 */
- (void)pushDocListViewControllerWithUrl:(NSURL *)url {
    // 根据“其他应用” 用“本应用”打开，通过要打开的url，获得本地地址
    NSString *appFilePath = [[JhtDocFileOperations sharedInstance] findLocalPathFromAppLicationOpenUrl:url];
    GlobalVar *globalVarItem = [GlobalVar globleFilePath];
    [globalVarItem.appFilePath addObject:appFilePath];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
