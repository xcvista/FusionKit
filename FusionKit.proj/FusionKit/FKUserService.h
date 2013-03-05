//
//  FKUserService.h
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import <Foundation/Foundation.h>

@interface FKUserService :  NSObject <NSCoding>

@property id ID;
@property id user;
@property NSString *gate;
@property NSString *account;
@property NSString *key;
@property NSDate *time;
@property NSDate *update;

@end
