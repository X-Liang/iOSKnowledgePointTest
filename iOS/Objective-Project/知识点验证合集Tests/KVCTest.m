//
//  KVCTest.m
//  知识点验证合集Tests
//
//  Created by X-Liang on 2017/10/29.
//  Copyright © 2017年 X-Liang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Class1.h"
#import "Class2.h"
@interface KVCTest : XCTestCase

@end

@implementation KVCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)test {
    Class1 *class2 = [[Class2 alloc] init];
    
}

@end
