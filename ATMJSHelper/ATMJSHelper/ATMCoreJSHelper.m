//
//  ATMJSHelper.m
//  ATMJSHelper
//
//  Created by admin  on 2017/6/19.
//  Copyright © 2017年 admin . All rights reserved.
//

#import "ATMCoreJSHelper.h"
#import <objc/runtime.h>
#import <objc/message.h>

@protocol ATMJSHelperExports <JSExport>

JSExportAs(call, - (id)OC_obj:(id)obj call:(NSString *)method);
JSExportAs(call, - (id)OC_obj:(id)obj call:(NSString *)method arguments:(id)arguments);

JSExportAs(calls, - (id)OC_obj:(id)obj calls:(NSArray*)methods);
JSExportAs(calls, - (id)OC_obj:(id)obj calls:(NSArray*)methods arguments:(id)arguments);

JSExportAs(attrFile, - (id)attributesFilePath:(NSString *)path);

@end

@interface ATMCoreJSHelper ()<ATMJSHelperExports>

@end

static ATMCoreJSHelper *helper;
@implementation ATMCoreJSHelper

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [ATMCoreJSHelper new];
    });
}

+ (void)injectionForContext:(JSContext *)context
{
    if (![context isKindOfClass:[JSContext class]]) {
        return;
    }
    
    context[@"_OC"] = helper;
    context.exceptionHandler = ^(JSContext *context,JSValue *exception)
    {
        NSLog(@"JS异常信息：%@", exception);
    };
}

+ (void)injectionForWebView:(UIWebView *)webView
{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self injectionForContext:context];
}

- (id)OC_obj:(id)obj call:(NSString *)method
{
    return  [self OC_obj:obj call:method arguments:nil];
}

- (id)OC_obj:(id)obj calls:(NSArray*)methods
{
    if (![methods isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    id rObj;
    for (NSString *method in methods)
    {
        rObj = [self OC_obj:obj call:method];
        if(!rObj)
        {
            break;
        }
        obj = rObj;
    }
    return obj;
}

- (id)OC_obj:(id)obj calls:(NSArray*)methods arguments:(id)arguments
{
    if (![arguments isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    if (![methods isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    id rObj;
    for (NSString *method in methods)
    {
        rObj = [rObj OC_obj:(id)obj call:method arguments:[arguments objectForKey:method]];
        if(!rObj)
        {
            break;
        }
    }
    return obj;
}

- (id)OC_obj:(id)obj call:(NSString *)method arguments:(id)arguments
{
    if ([obj isKindOfClass:[NSString class]])
    {
        Class clasz = NSClassFromString(obj);
        if (clasz) {
            obj = clasz;
        }
    }
    
    if ([obj respondsToSelector:NSSelectorFromString(method)])
    {
        if (![arguments isKindOfClass:[NSArray class]]){
            arguments = nil;
        }
        
        id returnVal = nil;
        if ([arguments count] == 0) {
            returnVal =  [obj performSelector:NSSelectorFromString(method)];
        }else if([arguments count] == 1){
            returnVal = [obj performSelector:NSSelectorFromString(method) withObject:arguments[0]];
        }else if([arguments count] == 2){
            returnVal = [obj performSelector:NSSelectorFromString(method) withObject:arguments[0] withObject:arguments[1]];
        }
        
        if (returnVal) {
            return returnVal;
        }
    }
    else
    {
        NSLog(@"%@ noRespondsToSelector -> %@",obj,method);
    }
    
    return nil;
}

- (id)attributesFilePath:(NSString *)path
{
    NSDictionary *fileAttributes;
    if ([path isKindOfClass:[NSString class]] && [[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        return fileAttributes;
    }
    return fileAttributes;
}

#pragma clang diagnostic pop
#pragma clang diagnostic pop

@end
