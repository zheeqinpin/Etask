//
//  GlobalVar.m
//  Tasksever
//
//  Created by LALALATT on 17/4/25.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "GlobalVar.h"

@implementation GlobalVar

+(instancetype)globleFilePath
{
    static GlobalVar *globalVar = nil;
    if (!globalVar) {
       globalVar= [[self alloc] init];
    }
    return globalVar;
}

-(instancetype)init
{
    self=[super init];
    self.appFilePath = [[NSMutableArray alloc] init];
    return self;
    
}

-(void)removeTheObjcet
{
    [self.appFilePath removeAllObjects];
}


@end


