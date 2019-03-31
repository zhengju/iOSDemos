//
//  ViewController.m
//  深浅拷贝
//
//  Created by zhengju on 2016/11/19.
//  Copyright © 2016年 zhengju. All rights reserved.
//

#import "ViewController.h"

#import "ZJPerson.h"

@interface ViewController ()
@property(nonatomic,strong)NSString * name;
@property(nonatomic,copy)NSString * nameStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableString * name = [NSMutableString stringWithFormat:@"郑俱"];
    NSLog(@"name:%p",name);
    
    self.name = name;
    
    self.nameStr = name;
    
    [name appendString:@"!!"];
    
     NSLog(@"name:%p",name);
    NSLog(@"%@ %@",self.name,self.nameStr);
    
    NSLog(@"%p,%p,%p",name,_name,_nameStr);
    
    
    
    //[self test2];
   // [self test1];
    
    [self test4];
    
    
}

- (void)test4{
    
    NSMutableString * name = [NSMutableString stringWithFormat:@"iOS俱哥"];
    
    
    ZJPerson * p1 = [[ZJPerson alloc]init];
    p1.name = name;
    p1.StrongName = name;

    ZJPerson * p = [p1 copy];
    
    [name appendString:@"iOS"];
    
    NSLog(@"p.name = %@",p.name);
    NSLog(@"p.StrongName = %@",p.StrongName);
    
    NSLog(@"name:%p,p.name:%p,p.StrongName:%p",name,p.name,p.StrongName);
    
    
}

- (void)test3{
    NSArray * mArray1 = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"a"],@"b",@"c",nil];
    NSArray * mArrayCopy1 = [mArray1 copy];
    NSLog(@"mArray1 retain count: %lu",(unsigned long)[mArray1 retainCount]);
    NSMutableArray *mArrayMCopy1 = [mArray1 mutableCopy];
    NSLog(@"mArray1 retain count: %lu",(unsigned long)[mArray1 retainCount]);
    //mArrayCopy2,mArrayMCopy1和mArray1指向的都是不一样的对象，但是其中的元素都是一样的对象——同一个指针
    //一下做测试
    NSMutableString *testString = [mArray1 objectAtIndex:0];
    //testString = @"1a1";//这样会改变testString的指针，其实是将@“1a1”临时对象赋给了testString
    [testString appendString:@" tail"];//这样以上三个数组的首元素都被改变了
    NSLog(@"%@",mArray1[0]);
    
}

- (void)test2{
    //copy返回不可变对象，mutablecopy返回可变对象
    NSArray * array1 = [NSArray arrayWithObjects:@"a",@"b",@"c",nil];
    NSArray * arrayCopy1 = [array1 copy];
    ////arrayCopy1是和array同一个NSArray对象（指向相同的对象），包括array里面的元素也是指向相同的指针
    NSLog(@"%p,%p,%lu,%lu",array1,arrayCopy1,(unsigned long)[arrayCopy1 retainCount],(unsigned long)[array1 retainCount]);
    NSMutableArray * mArrayCopy1 = [array1 mutableCopy];
    ////mArrayCopy1是array1的可变副本，指向的对象和array1不同，但是其中的元素和array1中的元素指向的是同一个对象。mArrayCopy1还可以修改自己的对象
    
    
    [mArrayCopy1 addObject:@"de"];
    NSLog(@"%@,%p",mArrayCopy1[0],array1[0]);
    
}
- (void)test1{
    //NSString * string = @"test";
    // NSString * stringCopy = [string copy];
    // NSMutableString * stringMuCopy = [string mutableCopy];
    // [stringMuCopy appendString:@"!!"];
    
    //  NSLog(@"string retainCount : %d",[string retainCount]);
    //  NSLog(@"stringCopy retainCount : %d",[stringCopy retainCount]);
    //  NSLog(@"stringMuCopy retainCount : %d",[stringMuCopy retainCount]);
    
    
    NSMutableString * string = [NSMutableString stringWithFormat:@"test"];
    NSString * stringCopy = [string copy];
    NSMutableString * mstringCopy = [string copy];
    NSMutableString * stringMuCopy = [string mutableCopy];
    
    
    NSLog(@"%p,%p,%p,%p",string,stringMuCopy,mstringCopy,stringCopy);
    
    
    [mstringCopy appendString:@"AA"];
    [string appendString:@"BB"];
    [stringMuCopy appendString:@"!!"];
}



@end
