//
//  MMDefines.h
//  MMInstagram
//
//  Created by Rockstar. on 4/7/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#ifdef MMDEFINES
#define MMDEFINES 1
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@import Foundation;

#endif


#pragma mark - Parse
extern NSString *const MM_PARSE_APPLICATION_ID;
extern NSString *const MM_PARSE_CLIENT_KEY;

#pragma mark - Instagram
extern NSString *const MM_INSTAGRAM_CLIENT_ID;
extern NSString *const MM_INSTAGRAM_CLIENT_SECRET;