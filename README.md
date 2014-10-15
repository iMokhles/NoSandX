NoSandX
=======

Access filesystem from Sandbox

<pre>
NoSandX is a daemon and client library, implemented using CPDistributedMessagingCenter, to make various filesystem operations possible for restricted/sandboxed applications. Having a similar functionality to as of Sandcastle, NoSandX makes it possible to actually execute filesystem operations as if under user root. Unbox also doesn't hook into Springboard (as it has a separate daemon), so it won't cause your iPhone's UI to lag or become unresponsive.
How to use this? The actual commands are executed by the daemon which does setuid(0) to run under user root. You communicate with it using the client library. The synopsys of the commands follows.
</pre>

**Installation**

<pre>
#import <nosandx/nosandx.h>
</pre>

**Usage**

<pre>
+ [NSClient sharedInstance] returns a shared client instance. You'll call its methods to perform operations.

- (NSString *) temporaryFile returns a filename pointing to a file in /tmp. It is, thus, guaranteed to be writable and it also permits chmod() and chown() syscalls.

- (void) moveFile:(NSString *)file1 toFile:(NSString *)file2 moves the file at path fil1 to te path file2.

- (void) copyFile:(NSString *)file1 toFile:(NSString *)file2 the same as the last one, but copies over the source file.

- (void) symlinkFile:(NSString *)file1 toFile:(NSString *)file2 and this one created a soft link, respectively.

- (void) deleteFile:(NSString *)file deletes a file from the filesystem.

- (NSDictionary *) attributesOfFile:(NSString *)file returns the attribute dictionary of the file at path 'file', as specified by NSFileManager.

- (NSArray *) contentsOfDirectory:(NSString *)dir returns a list of filenames that are present in the directory specified by 'dir'.

- (void) chmodFile:(NSString *)file mode:(mode_t)mode Performs a chmod() on the file 'file', treating 'mode' as an octal bitmask.

- (BOOL) fileExists:(NSString *)file return YES if the file specified by the path 'file' exists on the filesystem.

- (BOOL) fileIsDirectory:(NSString *)file returns YES if the file specified by 'file' is a directory.

- (void) createDirectory:(NSString *)dir creates a directory at the path specified by 'dir' (including the directory's name as well!)
</pre>
