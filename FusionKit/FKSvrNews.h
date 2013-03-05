//
//  FKSvrNews.h
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import <Foundation/Foundation.h>

@class FKUserService;

@interface FKSvrNews : NSObject <NSCoding>

@property NSString *svr;
@property NSString *svrId;
@property FKUserService *us;

@end
