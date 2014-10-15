//
// NSDelegate.m
// NoSandX
//
// (Unbox) Created by Árpád Goretity on 07/11/2011 
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//
/*
		NoSandX Created by Mokhlas Hussein (iMokhles on 29/09/2014)
		port of (Arpad Goretity) UnBox to make it work with iOS7 - arm64
*/

#import "NSDelegate.h"

@implementation NSDelegate

- (id)init
{
	if ((self = [super init])) {
		center = [CPDistributedMessagingCenter centerNamed:@"com.imokhles.nosand"];
		rocketbootstrap_distributedmessagingcenter_apply(center);
		[center registerForMessageName:@"com.imokhles.nosand.move" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.copy" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.symlink" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.delete" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.attributes" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.dircontents" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.chmod" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.exists" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.isdir" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center registerForMessageName:@"com.imokhles.nosand.mkdir" target:self selector:@selector(handleMessageNamed:userInfo:)];
		[center runServerOnCurrentThread];
		fileManager = [[NSFileManager alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[fileManager release];
	[super dealloc];
}

- (NSDictionary *)handleMessageNamed:(NSString *)name userInfo:(NSDictionary *)info
{
	NSString *sourceFile = [info objectForKey:@"NSSourceFile"];
	NSString *targetFile = [info objectForKey:@"NSTargetFile"];
	NSNumber *modeNumber = [info objectForKey:@"NSFileMode"];
	const char *source = [sourceFile UTF8String];
	const char *target = [targetFile UTF8String];
	mode_t mode = [modeNumber intValue];
	NSMutableDictionary *result = [NSMutableDictionary dictionary];

	if ([name isEqualToString:@"com.imokhles.nosand.move"]) {
		[fileManager moveItemAtPath:sourceFile toPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"com.imokhles.nosand.copy"]) {
		[fileManager copyItemAtPath:sourceFile toPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"com.imokhles.nosand.symlink"]) {
		symlink(source, target);
	} else if ([name isEqualToString:@"com.imokhles.nosand.delete"]) {
		[fileManager removeItemAtPath:targetFile error:NULL];
	} else if ([name isEqualToString:@"com.imokhles.nosand.attributes"]) {
		[result setDictionary:[fileManager attributesOfItemAtPath:targetFile error:NULL]];
	} else if ([name isEqualToString:@"com.imokhles.nosand.dircontents"]) {
		NSArray *contents = [fileManager contentsOfDirectoryAtPath:targetFile error:NULL];
		if (contents) {
			[result setObject:contents forKey:@"NSDirContents"];
		}
	} else if ([name isEqualToString:@"com.imokhles.nosand.chmod"]) {
		chmod(target, mode);
	} else if ([name isEqualToString:@"com.imokhles.nosand.exists"]) {
		BOOL exists = access(target, F_OK);
		NSNumber *num = [[NSNumber alloc] initWithBool:exists];
		[result setObject:num forKey:@"NSFileExists"];
		[num release];
	} else if ([name isEqualToString:@"com.imokhles.nosand.isdir"]) {
		struct stat buf;
		stat(target, &buf);
		BOOL isDir = S_ISDIR(buf.st_mode);
		NSNumber *num = [[NSNumber alloc] initWithBool:isDir];
		[result setObject:num forKey:@"NSIsDirectory"];
		[num release];
	} else if ([name isEqualToString:@"com.imokhles.nosand.mkdir"]) {
		[fileManager createDirectoryAtPath:targetFile withIntermediateDirectories:YES attributes:nil error:NULL];
	}

	return result;
}

- (void)dummy
{
	// Keep the timer alive ;)
}

@end
