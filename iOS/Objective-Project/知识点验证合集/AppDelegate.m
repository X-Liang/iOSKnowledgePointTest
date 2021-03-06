//
//  AppDelegate.m
//  知识点验证合集
//
//  Created by X-Liang on 2017/10/29.
//  Copyright © 2017年 X-Liang. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+KVO.h"
#import "Person.h"
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()
@property (nonatomic, strong) NSMutableArray *sourcesToPing;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
//    dispatch_apply(4, queue, ^(size_t index) {
//        NSLog(@"download1--%zd--%@",index,[NSThread currentThread]);
//        NSLog(@"+++++++++++++++");
//        dispatch_apply(4, queue, ^(size_t index) {
//            NSLog(@"download2--%zd--%@",index,[NSThread currentThread]);
//        });
//    });
    
    
    Person *person = [[Person alloc] init];
    [person addObserver:self forKey:@"name" withBlock:^(id observedObject, NSString *observerKey, id oldValue, id newValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"observer");
        });
    }];
    
    
    return YES;
}

- (void)registerSource:(RunloopContext *)sourceInfo {
    [self.sourcesToPing addObject:sourceInfo];
}

- (void)removeSource:(RunloopContext *)sourceInfo {
    id objToRemove = nil;
    for (RunloopContext *context in self.sourcesToPing) {
        if ([context isEqual:sourceInfo]) {
            objToRemove = context;
            break;
        }
    }
    if (objToRemove) {
        [self.sourcesToPing removeObject:objToRemove];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
