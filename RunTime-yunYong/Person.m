//
//  Person.m
//  RunTime-yunYong
//
//  Created by 刘冉 on 2017/6/5.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(run)) {
        //cls 类类型
        //name 方法编号
        //imp 方法实现,函数指针指向的一个实现
        //types 返回值类型
        class_addMethod([Person class], sel, (IMP)run, "v");
    }
    return [super resolveInstanceMethod:sel];
}

void run(id self,SEL _cmd){
    NSLog(@"%@===%@",self,NSStringFromSelector(_cmd));
    NSLog(@"动态创建了run方法");
}

@end
