//
//  UIViewController+Extension.m
//  RunTime-yunYong
//
//  Created by 刘冉 on 2017/6/5.
//  Copyright © 2017年 刘冉. All rights reserved.
//
/*
 HOOK 钩子思想
 勾住一个方法，改变一个方法
 */

#import "UIViewController+Extension.h"
#import <objc/message.h>

@implementation UIViewController (Extension)

+(void)load{
    //控制器加载的时候执行的方法
    //拿到方法
    Method popToRoot = class_getInstanceMethod([UINavigationController class], @selector(popToRootViewControllerAnimated:));
    //拿出原来的方法实现
    IMP popToRootImp = method_getImplementation(popToRoot);
    //给出一个新的实现
    IMP myImp = imp_implementationWithBlock(^(id self,SEL _cmd,BOOL animation){
        UINavigationController* nav = self;
        NSLog(@"我是%@返回的",nav.childViewControllers.lastObject);
        popToRootImp(self,_cmd,animation);
    });
    //HOOK思想
    method_setImplementation(popToRoot, myImp);
}

@end
