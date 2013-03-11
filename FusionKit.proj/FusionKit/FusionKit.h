//
//  FusionKit.h
//  FusionKit
//
//  Created by Maxthon Chan on 13-2-22.
//
//

#import <TargetConditionals.h>

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE

#import <MobileFusionKit/FKDecls.h>
#import <MobileFusionKit/FKJSONKeyedArchiver.h>
#import <MobileFusionKit/FKJSONKeyedUnarchiver.h>
#import <MobileFusionKit/FKConnection.h>
#import <MobileFusionKit/FKNews.h>
#import <MobileFusionKit/FKContact.h>

#else

#import <FusionKit/FKDecls.h>
#import <FusionKit/FKJSONKeyedArchiver.h>
#import <FusionKit/FKJSONKeyedUnarchiver.h>
#import <FusionKit/FKConnection.h>
#import <FusionKit/FKNews.h>
#import <FusionKit/FKContact.h>
#import <FusionKit/FKMedia.h>
#import <FusionKit/FKPost.h>
#import <FusionKit/FKSvrNews.h>
#import <FusionKit/FKUserService.h>
#import <FusionKit/FKUserContact.h>
#import <FusionKit/FKuserContactLink.h>

#endif


