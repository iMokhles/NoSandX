//
// NSDelegate.h
// NoSandX
//
// (Unbox) Created by Árpád Goretity on 07/11/2011 
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//
/*
		NoSandX Created by Mokhlas Hussein (iMokhles on 29/09/2014)
		port of (Arpad Goretity) UnBox to make it work with iOS7 - arm64
*/

#import <stdlib.h>
#import <unistd.h>
#import <stdint.h>
#import <stdio.h>
#import <sys/stat.h>
#import <sys/types.h>
#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import "Rocket/rocketbootstrap.h"

@interface NSDelegate: NSObject {
	CPDistributedMessagingCenter *center;
	NSFileManager *fileManager;
}

- (NSDictionary *)handleMessageNamed:(NSString *)name userInfo:(NSDictionary *)info;
- (void)dummy;

@end
