//
// NSServer.m
// NoSandX
//
// (Unbox) Created by Árpád Goretity on 07/11/2011 
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//
/*
		NoSandX Created by Mokhlas Hussein (iMokhles on 29/09/2014)
		port of (Arpad Goretity) UnBox to make it work with iOS7 - arm64
*/

#import "NSServer.h"

// static void Reboot(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
// {
//     NSLog(@"NSServer: reboot");
// #pragma GCC diagnostic push
// #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
//     system("NSServer");
// #pragma GCC diagnostic pop
// }

// int main(int argc, char **argv, char **envp) {
//     NSLog(@"NSServer: NSServer is launched!");
//     CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, Reboot, CFSTR("com.zeus.nosandx.reboot"), NULL, CFNotificationSuspensionBehaviorCoalesce);
//     CFRunLoopRun(); // keep it running in background
//     return 0;
// }

// int main(int argc, char *argv[])
int main(int argc, char **argv, char **envp)
{
	NSLog(@"NSServer: NSServer 222 is launched!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	setuid(0);
	pid_t pid = fork();
	NSLog(@"NSServer: NSServer 333 pid fork!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);
	NSLog(@"NSServer: NSServer 666 pid fork!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);

	if (pid < 0)
		NSLog(@"NSServer: Has 444 fork error! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);
		return 1;

	if (pid > 0)
		NSLog(@"NSServer: 555 Already running!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);
		return 0;

	// if pid == 0, then we are the child process 
	// keep chmod() mask unchanged

	NSLog(@"NSServer: NSServer 777 pid fork!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);
	umask(0);

	// not to become zombie
	NSLog(@"NSServer: NSServer 888 pid fork!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);
	pid_t sid = setsid();
	if (sid < 0)
		return 1;

	NSLog(@"NSServer: NSServer 999 pid fork!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", pid);
	if ((chdir("/")) < 0)
		NSLog(@"NSServer: child dir error!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d", chdir("/"));
		return 1;

	// a daemon does not need standard file descriptors
	NSLog(@"NSServer: STAGE1!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

	// this is to keep various Foundation classes happy
	NSLog(@"NSServer: STAGE2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// actually start the server
	NSLog(@"NSServer: STAGE3!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	NSDelegate *delegate = [[NSDelegate alloc] init];
	NSDate *now = [[NSDate alloc] init];

	NSLog(@"NSServer: STAGE4!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	// set up a timer to keep the run loop alive
	// we seem to need to add a non-NULL target and selector to kepp the timer running
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:now interval:60.0 target:delegate selector:@selector(dummy) userInfo:NULL repeats:YES];
	[now release];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
	[runLoop run];

	NSLog(@"NSServer: STAGE5!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	// the following will be never reached
	[timer release];
	[delegate release];
	[pool release];

	return 0;
}
