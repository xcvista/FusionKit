//
//  WFPreferenceKeys.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import <Foundation/Foundation.h>

#define WFStringKey(type) extern NSString *const

WFStringKey(NSString *)     WFServerRoot;
WFStringKey(BOOL)           WFOverrideMode;
WFStringKey(NSString *)     WFUsername;
WFStringKey(NSString *)     WFPassword;
WFStringKey(BOOL)           WFSaveUsername;
WFStringKey(BOOL)           WFDeveloperMode;
WFStringKey(NSUInteger)     WFLoadBatchSize;
WFStringKey(NSUInteger)     WFLoadHistoryBatchSize;
WFStringKey(NSTimeInterval) WFPullFrequency;
WFStringKey(BOOL)           WFPrettyPrintJSON;
WFStringKey(BOOL)           WFStallTimeout;
WFStringKey(BOOL)           WFAllowServerChange;
WFStringKey(NSString *)     WFCacheRoot;
WFStringKey(BOOL)           WFShowPacketInspectorAtLaunch;
