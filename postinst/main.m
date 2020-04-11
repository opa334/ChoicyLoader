// Copyright (c) 2020 Lars Fröder

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <stdio.h>

int hookingPlatform = 0;

int main(int argc, char *argv[], char *envp[])
{
	if (geteuid() != 0)
	{
		printf("ERROR: This tool needs to be run as root.\n");
		return 1;
	}

	if(![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substrate/SubstrateInserter.dylib"])
	{
		printf("ERROR: Substrate not found\n");
		printf("ChoicyLoader DOES NOT DO ANYTHING ON YOUR DEVICE AND IS NOT NEEDED, PLEASE UNINSTALL IT.\n");
		printf("ChoicyLoader DOES NOT DO ANYTHING ON YOUR DEVICE AND IS NOT NEEDED, PLEASE UNINSTALL IT.\n");
		printf("ChoicyLoader DOES NOT DO ANYTHING ON YOUR DEVICE AND IS NOT NEEDED, PLEASE UNINSTALL IT.\n");
		return 0;
	}

	NSString* targetPath = @"/usr/lib/substrate/SubstrateLoader.dylib";

	NSString* origPath = [[[targetPath stringByDeletingPathExtension] stringByAppendingString:@"_orig"] stringByAppendingPathExtension:[targetPath pathExtension]];

	if(![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/ChoicyLoader.dylib"])
	{
		printf("ERROR: /usr/lib/ChoicyLoader.dylib does not exist.\n");
		return -1;
	}

	if(![[NSFileManager defaultManager] fileExistsAtPath:targetPath])
	{
		printf("ERROR: %s does not exist.\n", [targetPath UTF8String]);
		return -1;
	}

	NSDictionary* targetLoaderAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:targetPath error:nil];

	if([[targetLoaderAttributes objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink])
	{
		printf("ERROR: %s is already a symbolic link, ChoicyLoader is likely already enabled.\n", [targetPath UTF8String]);
		return 0;
	}

	NSError* error;

	if([[NSFileManager defaultManager] fileExistsAtPath:origPath])
	{
		printf("%s already exists and %s is not a symbolic link, removing %s...\n", origPath.lastPathComponent.UTF8String, targetPath.lastPathComponent.UTF8String, origPath.lastPathComponent.UTF8String);
		[[NSFileManager defaultManager] removeItemAtPath:origPath error:&error];
		if(error)
		{
			printf("ERROR: Removing %s failed: %s.\n", origPath.lastPathComponent.UTF8String, error.description.UTF8String);
			return 2;
		}
	}

	[[NSFileManager defaultManager] moveItemAtPath:targetPath toPath:origPath error:&error];
	if(error)
	{
		printf("ERROR: Renaming %s to %s failed: %s.\n", targetPath.lastPathComponent.UTF8String, origPath.lastPathComponent.UTF8String, error.description.UTF8String);
		return 2;
	}

	[[NSFileManager defaultManager] createSymbolicLinkAtPath:targetPath withDestinationPath:@"/usr/lib/ChoicyLoader.dylib" error:&error];
	if(error)
	{
		printf("ERROR: Creating %s symbolic link failed: %s.\n", targetPath.lastPathComponent.UTF8String, error.description.UTF8String);
		return 2;
	}

	printf("Sucessfully enabled ChoicyLoader!\n");

	return 0;
}
