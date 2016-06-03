//
//  RuntimeTestViewController.m
//  RuntimeTestDemo
//
//  Created by GongHui_YJ on 16/6/2.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import "RuntimeTestViewController.h"
#import <objc/runtime.h>
#import "Person.h"

@interface RuntimeTestViewController ()
{
    Person *person1;
}
@end

//static void printSchool(id self, SEL _cmd) {
//    NSLog(@"我的学校是%@", [self valueForKey:@"schoolName"]);
//}

@implementation RuntimeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    person1 = [[Person alloc] init];
}

/**
 *  获取属性/成员
 *
 *  @param sender sender
 */
- (IBAction)getProperty:(id)sender {

    Class classPerson = NSClassFromString(@"Person");
    NSLog(@"--------------获取所有成员变量列表打印结果如下-----------------");
    // 获取所有成员变量列表 使用 class_copyIvarList
    unsigned int count = 0; //
    Ivar *ivarList = class_copyIvarList(classPerson, &count); // 获取所有的成员变量列表 count 记录变量的数量
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i]; // 取出第i个位置的成员变量
        const char *perosonName = ivar_getName(ivar); //获取变量名
        const char *perosonType = ivar_getTypeEncoding(ivar); // 获取变量编码类型
        NSLog(@"%s ---- %s\n", perosonName, perosonType);
    }

    NSLog(@"--------------分割线-----------------");
    NSLog(@"--------------获取所有属性列表打印结果如下-----------------");
    // 获取属性列表 使用 class_copyPropertyList
    unsigned int countProperty = 0;
    objc_property_t *propertyList = class_copyPropertyList(classPerson, &countProperty);
    for (int i = 0; i < countProperty; i++) {
        const char *cName = property_getName(propertyList[i]);
        const char *butes = property_getAttributes(propertyList[i]);
        NSLog(@"%s --- %s\n", cName, butes);
    }


    // 获取成员变量列表打印结果 （使用class_copyIvarList函数）
    /**
     2016-06-02 19:26:16.522 RuntimeTestDemo[32706:3539390] --------------获取所有成员变量列表打印结果如下-----------------
     2016-06-02 19:26:16.523 RuntimeTestDemo[32706:3539390] age ---- i
     2016-06-02 19:26:16.523 RuntimeTestDemo[32706:3539390] sex ---- @"NSString"
     2016-06-02 19:26:16.523 RuntimeTestDemo[32706:3539390] _name ---- @"NSString"
     2016-06-02 19:26:16.523 RuntimeTestDemo[32706:3539390] _address ---- @"NSString"
     2016-06-02 19:26:16.524 RuntimeTestDemo[32706:3539390] --------------分割线-----------------
     2016-06-02 19:26:16.524 RuntimeTestDemo[32706:3539390] --------------获取所有属性列表打印结果如下-----------------
     2016-06-02 19:26:16.524 RuntimeTestDemo[32706:3539390] name --- T@"NSString",&,N,V_name
     2016-06-02 19:26:16.524 RuntimeTestDemo[32706:3539390] address --- T@"NSString",&,N,V_address
     */

}




/**
 *  获取类的所有方法（包括私有）
 *
 *  @param sender sender
 */
- (IBAction)getAllMethod:(id)sender {
    unsigned int count = 0;
    Method *memberFuncs = class_copyMethodList([Person class], &count); // 获取所有方法名
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(memberFuncs[i]);
        const char *nameMethod = sel_getName(name); // 获取方法名
        NSLog(@"%s", nameMethod);
    }


    /** 获取所有.m 文件的所有方法  其中包括属性的get set方法.cxx_destruct 系统的
     2016-06-02 19:55:26.411 RuntimeTestDemo[33544:3558588] eat
     2016-06-02 19:55:26.412 RuntimeTestDemo[33544:3558588] address
     2016-06-02 19:55:26.412 RuntimeTestDemo[33544:3558588] .cxx_destruct
     2016-06-02 19:55:26.412 RuntimeTestDemo[33544:3558588] description
     2016-06-02 19:55:26.412 RuntimeTestDemo[33544:3558588] name
     2016-06-02 19:55:26.413 RuntimeTestDemo[33544:3558588] setName:
     2016-06-02 19:55:26.413 RuntimeTestDemo[33544:3558588] init
     2016-06-02 19:55:26.413 RuntimeTestDemo[33544:3558588] setAddress:
     */
}



/**
 *  动态添加方法
 *
 *  @param sender sender
 */
- (IBAction)addMethod:(id)sender {

//    class_addMethod函数参数的含义:
//    第一个参数Class cls, 类型
//    第二个参数SEL name, 被解析的方法
//    第三个参数 IMP imp, 指定的实现 这里表示具体的实现方法 myTestMethod
//    第四个参数const char *types,方法的类型（方法的参数） 0代表没有参数

//    const char *cs = getprogname();
    class_addMethod([Person class], @selector(NewMethod::), (IMP)myTestMethod, "i@:i@"); // 这里会报警告  可以忽略
    //调用方法 【如果使用[per method]方法！(在ARC下会报no visible @interface 错误)】
    [person1 performSelector:@selector(NewMethod::)];

}

// 具体的实现， 即IMP所指向的方法
int myTestMethod(id self, SEL _cmd, int var1, NSString *str)
{
    NSLog(@"已经新增方法");
    return var1;
}
/**打印结果 打印如下 说明已经添加成功
 2016-06-03 11:00:58.040 RuntimeTestDemo[34732:3750980] 已经新增方法
 */

/** 此刻再打印获取类的所有方法 NewMethod:: 这个新增的方法已经添加进来
 2016-06-03 11:00:59.185 RuntimeTestDemo[34732:3750980] NewMethod::
 2016-06-03 11:00:59.185 RuntimeTestDemo[34732:3750980] eat
 2016-06-03 11:00:59.185 RuntimeTestDemo[34732:3750980] address
 2016-06-03 11:00:59.185 RuntimeTestDemo[34732:3750980] .cxx_destruct
 2016-06-03 11:00:59.185 RuntimeTestDemo[34732:3750980] description
 2016-06-03 11:00:59.185 RuntimeTestDemo[34732:3750980] name
 2016-06-03 11:00:59.186 RuntimeTestDemo[34732:3750980] setName:
 2016-06-03 11:00:59.186 RuntimeTestDemo[34732:3750980] init
 2016-06-03 11:00:59.186 RuntimeTestDemo[34732:3750980] setAddress:

 */


/**
 *  修改私有变量的值
 *
 *  @param sender
 */
- (IBAction)updatePrivateValue:(id)sender {
    Person *person = [[Person alloc] init];
    NSLog(@"修改前数据： %@", [person description]);

    unsigned int count = 0; //
    Ivar *ivarList = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = ivarList[i];
        if (i == 0) // 1 是表示私有变量 age  刚刚上面打印出来 第2个
        {
            object_setIvar(person, var, @28); // 把私有变量age的值改成 28
        }

        if (i == 1) // 私有变量 sex
        {
            object_setIvar(person, var, @"女");
        }
    }

    NSLog(@"修改后数据---： %@", [person description]);

    /** 打印结果 发现 私有变量 age  和 sex 的值已经改变
     2016-06-02 19:48:32.218 RuntimeTestDemo[33349:3554863] 修改前数据： name: 张三 -- age: 18 -- sex:男 -- 浙江省杭州市
     2016-06-02 19:48:32.218 RuntimeTestDemo[33349:3554863] 修改后数据---： name: 张三 -- age: 450 -- sex:女 -- 浙江省杭州市
     */
}

/**
 *  方法交换
 *
 *  @param sender sender
 */
- (IBAction)methodExchange:(id)sender {

    [person1 test1]; // 未交换前的输出结果

    Method method1 = class_getInstanceMethod([person1 class], @selector(test1));
    Method method2 = class_getInstanceMethod([person1 class], @selector(test2));

    // 方法交换
    method_exchangeImplementations(method1, method2);
    [person1 test1]; // 输出交换后的结果

    /**  打印结果 交换完之后 test1的方法 打印test2的结果
     2016-06-03 11:27:57.921 RuntimeTestDemo[35341:3767704] 我是test1方法
     2016-06-03 11:27:57.922 RuntimeTestDemo[35341:3767704] 我是test2方法
     */
}

/**
 *  动态添加类
 *
 *  @param sender
 */
- (IBAction)addClass:(id)sender {
    // 添加一个Student类
    Class classStudent = objc_allocateClassPair([Person class], "Student", 0);

    // 添加一个NSStrig的变量
    if (class_addIvar(classStudent, "schoolName", sizeof(NSString *), 0, "@")) {
        NSLog(@"添加成员变量 schollName成功");
    }

    // 为Student类添加方法
    if (class_addMethod(classStudent, @selector(printSchool), (IMP)printSchool, "v@:")) {
        NSLog(@"添加方法printSchool成功");
    }

    // 注册这个类到runtime系统中 可以使用他
    objc_registerClassPair(classStudent); // 返回void


    // 创建类
    id student = [[classStudent alloc] init];

    NSString *schoolName = @"福建师范大学";

    // 给刚刚添加的变量赋值
    [student setValue:schoolName forKey:@"schoolName"];

    // 动态调用
    [student performSelector:@selector(printSchool) withObject:nil];


    /** 打印结果
     2016-06-03 11:49:26.724 RuntimeTestDemo[35846:3781380] 添加成员变量 schollName成功
     2016-06-03 11:49:26.725 RuntimeTestDemo[35846:3781380] 添加方法printSchool成功
     2016-06-03 11:49:26.725 RuntimeTestDemo[35846:3781380] 我的学校是福建师范大学
     */
}

//方法的实现
void printSchool(id self, SEL _cmd)
{
    NSLog(@"我的学校是%@", [self valueForKey:@"schoolName"]);
}

/**
 *  修改方法
 *
 *  @param sender
 */
- (IBAction)updateMethod:(id)sender {

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
