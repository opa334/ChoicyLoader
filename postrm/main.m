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

//0: did nothing, -1: error, 1: success
int disableChoicyLoader(NSString* loaderPath)
{
	NSString* origPath = [[[loaderPath stringByDeletingPathExtension] stringByAppendingString:@"_orig"] stringByAppendingPathExtension:[loaderPath pathExtension]];

	NSError* error;
	NSDictionary* loaderAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:loaderPath error:&error];

	if(![[loaderAttributes objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink])
	{
		printf("%s is not a symbolic link, ChoicyLoader is likely already disabled.\n", loaderPath.UTF8String);
		return 0;
	}

	if(![[NSFileManager defaultManager] fileExistsAtPath:origPath])
	{
		printf("%s does not exist, ChoicyLoader is likely already disabled.\n", origPath.UTF8String);
		return 0;
	}

	[[NSFileManager defaultManager] removeItemAtPath:loaderPath error:&error];
	if(error)
	{
		printf("ERROR: Removing %s symlink failed: %s.\n", loaderPath.lastPathComponent.UTF8String, error.description.UTF8String);
		return -1;
	}

	[[NSFileManager defaultManager] moveItemAtPath:origPath toPath:loaderPath error:&error];
	if(error)
	{
		printf("ERROR: Moving %s back failed: %s.\n", loaderPath.lastPathComponent.UTF8String, error.description.UTF8String);
		return -1;
	}

	return 1;
}

int main(int argc, char *argv[], char *envp[])
{
	if (geteuid() != 0)
	{
		printf("ERROR: This tool needs to be run as root.\n");
		return 1;
	}

	if(![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substrate/SubstrateInserter.dylib"])
	{
		printf("Substrate not found. Looking for a deprecated Substitute installation...\n");

		int ret = disableChoicyLoader(@"/usr/lib/substitute-loader.dylib");

		if(ret == 1)
		{
			printf("Sucessfully reverted deprecated Substitute installation!\n");
		}
		else if(ret == 0)
		{
			printf("Deprecated Substitute installation not found, all good\n");
		}

		return 0;
	}

	int ret = disableChoicyLoader(@"/usr/lib/substrate/SubstrateLoader.dylib");

	if(ret == 1)
	{
		printf("Sucessfully disabled ChoicyLoader!\n");
	}

	return 0;
}
