//
//  NSObject+NSObject_KVO.m
//  RunTime-yunYong
//
//  Created by 刘冉 on 2017/6/5.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import "NSObject+NSObject_KVO.h"
#import <objc/message.h>

@implementation NSObject (NSObject_KVO)

-(void)LR_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    //获取类名
    NSString* oldClassName = NSStringFromClass([self class]);
    NSString* newClassName = [@"LR" stringByAppendingString:oldClassName];
    const char * name = [newClassName UTF8String];
    //1.动态生成一个类
    Class myClass = objc_allocateClassPair([self class], name, 0);
    //添加一个方法
    class_addMethod(myClass, @selector(setName:), (IMP)setName, "");
    //注册这个类
    objc_registerClassPair(myClass);
    //修改isa指针
    object_setClass(self, myClass);
}

/*
 * 动态添加的方法的实现
 */
void setName(id self, SEL _cmd,NSString* param){
    NSLog(@"监听到了%@",param);
}

@end
