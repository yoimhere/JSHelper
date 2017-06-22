//
//  AppDelegate.m
//  ATMJSHelper
//
//  Created by admin  on 2017/6/19.
//  Copyright © 2017年 admin . All rights reserved.
//

#import "AppDelegate.h"
#import "ATMCoreJSHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static JSContext *_context;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self testCall];
    [self testCalls];
    return YES;
}


- (void)testCall
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    JSContext *context = [JSContext new];
    [ATMCoreJSHelper injectionForContext:context];
    
    NSString *tempString2 = [NSString stringWithFormat:@"function test(){\
                             var appWks = _OC.call('LSApplicationWorkspace','defaultWorkspace');\
                             var items = _OC.call(appWks,'allInstalledApplications');\
                             var c = [];\
                             for (index in items) {\
                             var bundleID =  _OC.call(items[index],'bundleIdentifier');\
                             var bundleType =  _OC.call(items[index],'bundleType');\
                             if (bundleType.toLowerCase() == 'user')\
                             {\
                             c.push(bundleID);  \
                             }\
                             };\
                             return  c;\
                             };\
                             test();"];
    JSValue *v =  [context evaluateScript:tempString2];
    NSObject *obj = [v toObject];
    
}

- (void)testCalls
{
    JSContext *context = [JSContext new];
    [ATMCoreJSHelper injectionForContext:context];
    
    NSString *tempString2 = [NSString stringWithFormat:@"function test(){\
                             var items = _OC.calls('LSApplicationWorkspace',['defaultWorkspace','allInstalledApplications']);\
                             var c = [];\
                             for (index in items) {\
                             var bundleID =  _OC.call(items[index],'bundleIdentifier');\
                             var bundleType =  _OC.call(items[index],'bundleType');\
                             if (bundleType.toLowerCase() == 'user')\
                             {\
                             c.push(bundleID);  \
                             }\
                             };\
                             return  c;\
                             };\
                             test();"];
    JSValue *v =  [context evaluateScript:tempString2];
    NSObject *obj = [v toObject];

    
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
