//
//  ViewController.m
//  RunTime-yunYong
//
//  Created by 刘冉 on 2017/6/4.
//  Copyright © 2017年 刘冉. All rights reserved.
//问题：需要知道从哪个控制器返回的
/*
 runtime中 Method 成员方法 Ivar 成员变量
 */

#import "ViewController.h"
#import "OneViewController.h"
#import <objc/message.h>
#import "Person.h"
#import "NSObject+NSObject_KVO.h"

@interface ViewController ()

@property(nonatomic,strong)Person* p;
@property(nonatomic,strong)NSMutableArray* dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"one";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    /*
     动态添加Person类的一个方法
     */
    Person* p = [[Person alloc] init];
    [p performSelector:@selector(run)];
    /*
     实现自己的KVO监听
     */
    [p LR_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    self.p = p;
    /*
     动态的遍历一个类的所有成员变量，用于字典转模型、归解档的操作
     */
    [self getPersonAllIvars];
    /*
     获得一个类的所有属性
     */
    [self getPersonAllPerpoty];
    /*
     runtime --- 交换方法
     */
    [self exchangeImp];
    /*
     动态添加一个类
     */
    [self creatClass];
}

/*
 自己实现的KVO之后，系统的KVO便不再监测到属性的变化
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"系统监听到了");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[[OneViewController alloc] init] animated:YES];
}

-(void)click:(UIButton*)sender{
    static int i = 0;
    i ++ ;
    self.p.name = [NSString stringWithFormat:@"%d",i];
}

#pragma mark - 拿到Person类的所有属性
-(void)getPersonAllIvars{
    unsigned int count = 0;
    //获得一个指向该类成员变量的指针
    Ivar* ivars = class_copyIvarList([Person class], &count);
    //for循环获得Ivar
    for (int i = 0;  i < count; i++) {
        Ivar ivar = ivars[i];
        //根据ivar获得其成员变量的名称--->C语言的字符串
        const char * name = ivar_getName(ivar);
        NSString* key = [NSString stringWithUTF8String:name];
        NSLog(@"%@",key);
    }
}

#pragma mark - 获得一个类的全部属性
-(void)getPersonAllPerpoty{
    unsigned int conut = 0;
    //获得指向该类的所有属性的指针
    objc_property_t* properties = class_copyPropertyList([Person class], &conut);
    for (int i = 0; i < conut; i++) {
        objc_property_t property = properties[i];
        //根据objc_property_t获得其属性的名称--->C语言的字符串
        const char* name = property_getName(property);
        NSString* key = [NSString stringWithUTF8String:name];
        NSLog(@"property%@",key);
    }
}

#pragma mark - runtime交换方法
-(void)exchangeImp{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@"lalla"];
    [self.dataSource addObject:@"kkkk"];
    [self.dataSource addObject:nil];
    NSLog(@"dataSource%@",self.dataSource);
}

#pragma mark - 动态添加一个类
-(void)creatClass{
    //添加一个studetn类
    Class classStudent = objc_allocateClassPair([Person class], "student", 0);
    //添加一个NSString变量
    if (class_addIvar(classStudent, "schoolName", sizeof(NSString*), 0, "@")) {
        NSLog(@"添加成员变量schoolName成功");
    }
    //添加一个方法
    if (class_addMethod(classStudent, @selector(goToSchool), (IMP)goToSchool, "v@:")) {
        NSLog(@"添加方法成功");
    }
    //注册这个类道runtime系统中
    objc_registerClassPair(classStudent);
    //创建类
    id student = [[classStudent alloc] init];
    NSString* schoolName = @"大学";
    //给新添加的变量赋值
    [student setValue:schoolName forKey:@"schoolName"];
    //动态调用
    [student performSelector:@selector(goToSchool)];
}

void goToSchool(id self,SEL _cmd){
    NSLog(@"我的学校是%@",[self valueForKey:@"schoolName"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
