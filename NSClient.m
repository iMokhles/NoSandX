//
// NSClient.m
// NoSandX
//
// (Unbox) Created by Árpád Goretity on 07/11/2011 
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//
/*
		NoSandX Created by Mokhlas Hussein (iMokhles on 29/09/2014)
		port of (Arpad Goretity) UnBox to make it work with iOS7 - arm64
*/

#import "NSClient.h"

@implementation NSClient

+ (id)sharedInstance
{
	static id shared = nil;
	if (shared == nil) {
		shared = [[self alloc] init];
	}

	return shared;
}

- (id)init
{
	if ((self = [super init])) {
		center = [CPDistributedMessagingCenter centerNamed:@"com.imokhles.nosand"];
		rocketbootstrap_distributedmessagingcenter_apply(center);
	}

	return self;
}

- (NSString *)temporaryFile
{
	CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
	CFRelease(uuidRef);
	NSString *path = [NSString stringWithFormat:@"/tmp/%@.tmp", uuid];
	CFRelease(uuid);
	return path;
}

- (void)moveFile:(NSString *)file1 toFile:(NSString *)file2
{
	if (file1 == nil || file2 == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file1 forKey:@"NSSourceFile"];
	[info setObject:file2 forKey:@"NSTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.move" userInfo:info];
	[info release];
}

- (void)copyFile:(NSString *)file1 toFile:(NSString *)file2
{
	if (file1 == nil || file2 == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file1 forKey:@"NSSourceFile"];
	[info setObject:file2 forKey:@"NSTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.copy" userInfo:info];
	[info release];
}

- (void)symlinkFile:(NSString *)file1 toFile:(NSString *)file2
{
	if (file1 == nil || file2 == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file1 forKey:@"NSSourceFile"];
	[info setObject:file2 forKey:@"NSTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.symlink" userInfo:info];
	[info release];
}

- (void)deleteFile:(NSString *)file
{
	if (file == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"NSTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.delete" userInfo:info];
	[info release];
}

- (NSDictionary *)attributesOfFile:(NSString *)file
{
	if (file == nil) {
		return nil;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"NSTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.attributes" userInfo:info];
	[info release];
	return reply;
}

- (NSArray *)contentsOfDirectory:(NSString *)dir
{
	if (dir == nil) {
		return nil;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:dir forKey:@"NSTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.dircontents" userInfo:info];
	[info release];
	NSArray *result = [reply objectForKey:@"NSDirContents"];
	return result;
}

- (void)chmodFile:(NSString *)file mode:(mode_t)mode
{
	if (file == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"NSTargetFile"];
	NSNumber *modeNumber = [[NSNumber alloc] initWithInt:mode];
	[info setObject:modeNumber forKey:@"NSFileMode"];
	[modeNumber release];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.chmod" userInfo:info];
	[info release];
}

- (BOOL)fileExists:(NSString *)file
{
	if (file == nil) {
		return NO;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"NSTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.exists" userInfo:info];
	[info release];
	BOOL result = [(NSNumber *)[reply objectForKey:@"NSFileExists"] boolValue];
	return result;
}

- (BOOL)fileIsDirectory:(NSString *)file
{
	if (file == nil) {
		return NO;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:file forKey:@"NSTargetFile"];
	NSDictionary *reply = [center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.isdir" userInfo:info];
	[info release];
	BOOL result = [(NSNumber *)[reply objectForKey:@"NSIsDirectory"] boolValue];
	return result;
}

- (void)createDirectory:(NSString *)dir
{
	if (dir == nil) {
		return;
	}

	NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
	[info setObject:dir forKey:@"NSTargetFile"];
	[center sendMessageAndReceiveReplyName:@"com.imokhles.nosand.mkdir" userInfo:info];
	[info release];
}

@end
