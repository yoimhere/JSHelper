//
//  ATMJSHelper.h
//  ATMJSHelper
//
//  Created by admin  on 2017/6/19.
//  Copyright © 2017年 admin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ATMCoreJSHelper : NSObject

+ (void)injectionForContext:(JSContext *)context;
+ (void)injectionForWebView:(UIWebView *)webView;

@end
