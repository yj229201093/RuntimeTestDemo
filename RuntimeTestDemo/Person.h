//
//  Person.h
//  RuntimeTestDemo
//
//  Created by GongHui_YJ on 16/6/2.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *address;

- (void)eat;

- (void)test1;

- (void)test2;

@end
