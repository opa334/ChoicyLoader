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
	int hookingPlatform = 0;

	if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substrate/SubstrateInserter.dylib"])
	{
		HBLogDebug(@"Detected Substrate!");
		hookingPlatform = 1;
	}
	else if([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/substitute-inserter.dylib"])
	{
		HBLogDebug(@"Detected Substitute!");
		hookingPlatform = 2;
	}

	HBLogDebug(@"ChoicyLoader: Out here");
	dlopen("/Library/MobileSubstrate/DynamicLibraries/000_Choicy.dylib", RTLD_NOW);
	HBLogDebug(@"ChoicyLoader: Loaded Choicy");
	if(hookingPlatform == 1)
	{
		dlopen("/usr/lib/substrate/SubstrateLoader_orig.dylib", RTLD_NOW);
		HBLogDebug(@"ChoicyLoader: Loaded Substrate");
	}
	else if(hookingPlatform == 2)
	{
		dlopen("/usr/lib/substitute-loader_orig.dylib", RTLD_NOW);
		HBLogDebug(@"ChoicyLoader: Loaded Substitute");
	}
}