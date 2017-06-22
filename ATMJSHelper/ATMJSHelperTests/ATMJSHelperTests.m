//
//  ATMJSHelperTests.m
//  ATMJSHelperTests
//
//  Created by admin  on 2017/6/22.
//  Copyright © 2017年 admin . All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ATMCoreJSHelper.h"

@interface ATMJSHelperTests : XCTestCase

@property (nonatomic, strong) JSContext *context;


@end

@implementation ATMJSHelperTests

- (void)setUp
{
    [super setUp];
    self.context = [JSContext new];
    [ATMCoreJSHelper injectionForContext:self.context];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCall
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
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
    JSValue *v =  [self.context evaluateScript:tempString2];
    
    XCTAssert([v toObject] == nil,@"测试不通过");
}

- (void)testCalls
{
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
    JSValue *v =  [self.context evaluateScript:tempString2];
    
    XCTAssert([v toObject] == nil,@"测试不通过");
}


@end
