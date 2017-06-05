//
//  NSMutableArray+runtime_exchangeMethod.m
//  RunTime-yunYong
//
//  Created by 刘冉 on 2017/6/5.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "NSMutableArray+runtime_exchangeMethod.h"
#import <objc/message.h>

@implementation NSMutableArray (runtime_exchangeMethod)

+(void)load{
    Method oldMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(LR_addObject:));
    //交换方法的实现
    method_exchangeImplementations(oldMethod, newMethod);
}

-(void)LR_addObject:(id)object{
    if (object != nil) {
        //注意噶方法的调用，因为该方法已经实现方法交换，如果继续调用系统的addObject方法会出现死循环
        [self LR_addObject:object];
    }
}

@end
