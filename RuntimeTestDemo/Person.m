//
//  Person.m
//  RuntimeTestDemo
//
//  Created by GongHui_YJ on 16/6/2.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import "Person.h"

@implementation Person
{
    int age;
    NSString *sex;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"张三";
        _address = @"浙江省杭州市";
        age = 18;
        sex = @"男";
    }
    return self;
}

- (void)eat
{
    NSLog(@"吃饭");
}

- (void)test1
{
    NSLog(@"我是test1方法");
}

- (void)test2
{
    NSLog(@"我是test2方法");
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@ -- age: %i -- sex:%@ -- %@", _name, age, sex, _address];
}

@end
