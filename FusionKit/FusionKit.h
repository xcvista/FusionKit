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

#else

#import <FusionKit/FKDecls.h>
#import <FusionKit/FKJSONKeyedArchiver.h>
#import <FusionKit/FKJSONKeyedUnarchiver.h>
#import <FusionKit/FKConnection.h>

#endif


