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
#import <CoreFoundation/CoreFoundation.h>

__attribute__((constructor))
static void init(void)
{
	CFStringRef securityIdentifier = CFStringCreateWithCString(kCFAllocatorDefault, "com.apple.Security", kCFStringEncodingUTF8);
	CFBundleRef securityBundle = CFBundleGetBundleWithIdentifier(securityIdentifier);
	CFRelease(securityIdentifier);	

	if(!securityBundle)
	{
		return;
	}

	//Choicy 1.1.3 and below
	if(access("/Library/MobileSubstrate/DynamicLibraries/000_Choicy.dylib", F_OK) != -1)
	{
		dlopen("/Library/MobileSubstrate/DynamicLibraries/000_Choicy.dylib", RTLD_NOW);
	}

	//Choicy 1.2 and above
	if(access("/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib", F_OK) != -1)
	{
		dlopen("/Library/MobileSubstrate/DynamicLibraries/   Choicy.dylib", RTLD_NOW);
	}

	//Load Substrate
	if(access("/usr/lib/substrate/SubstrateLoader_orig.dylib", F_OK) != -1)
	{
		dlopen("/usr/lib/substrate/SubstrateLoader_orig.dylib", RTLD_NOW);
	}
}