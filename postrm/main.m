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

	if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substrate/SubstrateInserter.dylib"])
	{
		hookingPlatform = 1;
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substitute-inserter.dylib"])
	{
		hookingPlatform = 2;
	}
	else
	{
		printf("ERROR: Can't determine hooking platform.\n");
		return -1;
	}

	NSString* targetPath;

	if(hookingPlatform == 1)
	{
		targetPath = @"/usr/lib/substrate/SubstrateLoader.dylib";
	}
	else if(hookingPlatform == 2)
	{
		targetPath = @"/usr/lib/substitute-loader.dylib";
	}

	NSString* origPath = [[[targetPath stringByDeletingPathExtension] stringByAppendingString:@"_orig"] stringByAppendingPathExtension:[targetPath pathExtension]];

	NSError* error;
	NSDictionary* targetLoaderAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:targetPath error:&error];

	if(![[targetLoaderAttributes objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink])
	{
		printf("ERROR: %s is not a symbolic link, ChoicyLoader is likely already disabled.\n", targetPath.UTF8String);
		return 0;
	}

	if(![[NSFileManager defaultManager] fileExistsAtPath:origPath])
	{
		printf("ERROR: %s does not exist, ChoicyLoader is likely already disabled.\n", origPath.UTF8String);
		return 0;
	}

	[[NSFileManager defaultManager] removeItemAtPath:targetPath error:&error];
	if(error)
	{
		printf("ERROR: Removing %s symlink failed: %s.\n", targetPath.lastPathComponent.UTF8String, error.description.UTF8String);
		return 2;
	}

	[[NSFileManager defaultManager] moveItemAtPath:origPath toPath:targetPath error:&error];
	if(error)
	{
		printf("ERROR: Moving %s back failed: %s.\n", targetPath.lastPathComponent.UTF8String, error.description.UTF8String);
		return 2;
	}

	printf("Sucessfully disabled ChoicyLoader!\n");

	return 0;
}
