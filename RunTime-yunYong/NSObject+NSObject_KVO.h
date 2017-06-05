//
//  NSObject+NSObject_KVO.h
//  RunTime-yunYong
//
//  Created by 刘冉 on 2017/6/5.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_KVO)

- (void)LR_addObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nullable)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end
