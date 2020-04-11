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

#import <dlfcn.h>

__attribute__((constructor))
static void init(void)
{
	@autoreleasepool
	{
		HBLogDebug(@"ChoicyLoader: Out here");

		//Choicy 1.1.3 and below
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/000_Choicy.dylib"])
		{
			dlopen("/Library/MobileSubstrate/DynamicLibraries/000_Choicy.dylib", RTLD_NOW);
		}

		//Choicy 1.2 and above
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib"])
		{
			dlopen("/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib", RTLD_NOW);
		}
		
		char* error = dlerror();
		if(!error)
		{
			HBLogDebug(@"ChoicyLoader: Loaded Choicy!");
		}
		else
		{
			NSLog(@"ChoicyLoader: ERROR loading Choicy: %s", error);
		}

		if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substrate/SubstrateLoader_orig.dylib"])
		{
			dlopen("/usr/lib/substrate/SubstrateLoader_orig.dylib", RTLD_NOW);
			char* substrateError = dlerror();
			if(!substrateError)
			{
				HBLogDebug(@"ChoicyLoader: Loaded SubstrateLoader!");
			}
			else
			{
				NSLog(@"ChoicyLoader: ERROR loading SubstrateLoader");
			}
		}
		else
		{
			NSLog(@"ChoicyLoader: SubstrateLoader_orig not found");
		}
	}
}