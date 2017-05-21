//
//  GlobalVar.h
//  Tasksever
//
//  Created by LALALATT on 17/4/25.
//  Copyright © 2017年 zln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVar : NSObject
+(instancetype)globleFilePath;//用于建一个第三方app文件路径的全局变量
@property (nonatomic) NSMutableArray *appFilePath;
-(void)removeTheObjcet;
@end
