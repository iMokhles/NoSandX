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

int main(int argc, char *argv[])
{
	setuid(0);
	pid_t pid = fork();

	if (pid < 0)
		return 1;

	if (pid > 0)
		return 0;

	// if pid == 0, then we are the child process 
	// keep chmod() mask unchanged

	umask(0);

	// not to become zombie
	pid_t sid = setsid();
	if (sid < 0)
		return 1;

	if ((chdir("/")) < 0)
		return 1;

	// a daemon does not need standard file descriptors
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

	// this is to keep various Foundation classes happy
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// actually start the server
	NSDelegate *delegate = [[NSDelegate alloc] init];
	NSDate *now = [[NSDate alloc] init];

	// set up a timer to keep the run loop alive
	// we seem to need to add a non-NULL target and selector to kepp the timer running
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:now interval:60.0 target:delegate selector:@selector(dummy) userInfo:NULL repeats:YES];
	[now release];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
	[runLoop run];

	// the following will be never reached
	[timer release];
	[delegate release];
	[pool release];

	return 0;
}
