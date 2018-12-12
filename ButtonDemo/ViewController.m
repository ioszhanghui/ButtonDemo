//
//  ViewController.m
//  ButtonDemo
//
//  Created by Gome on 2018/12/12.
//  Copyright © 2018年 Gome. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"开始时%ld",CFGetRetainCount((__bridge CFTypeRef)(self)));
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    SEL btnAction = NULL;
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:nil action:@selector(clickAction2:) forControlEvents:UIControlEventTouchDown];
    NSLog(@"添加之后%ld",CFGetRetainCount((__bridge CFTypeRef)(self)));
    [self.view addSubview:btn];
}

-(void)clickAction2:(UIButton*)btn{
    NSLog(@"%s",__func__);
    
   
}

-(void)clickAction:(UIButton*)btn{
    NSLog(@"%s",__func__);
    unsigned int count;
   Ivar * ivars = class_copyIvarList([UIControl class], &count);
    for (NSInteger i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        NSString * ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSLog(@"ivar***%@",ivarName);
       NSLog(@"ivar_getTypeEncoding***%@",[NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding]);
        if ([ivarName isEqualToString:@"_targetActions"]) {
            NSArray * objArr = object_getIvar(btn, ivar);
           NSLog(@"object_getIvar***%@", objArr[0]);            
        }
    }
    
    [self getPropertyList];
}

-(void)getPropertyList{
    unsigned int count;
  objc_property_t * objc_propertys =  class_copyPropertyList([UIControl class], &count);
    for (NSInteger i=0; i<count; i++) {
        objc_property_t objc_property = objc_propertys[i];
        NSLog(@"objc_property***%@",[NSString stringWithCString:property_getName(objc_property) encoding:NSUTF8StringEncoding]);
        
    }
}

-(void)getMethodList{
    unsigned int count;
   Method * methods = class_copyMethodList([UIButton class], &count);
    for (NSInteger i=0; i<count; i++) {
        Method method = methods[i];
        NSLog(@"%@",NSStringFromSelector(method_getName(method)));
    }
}
@end
