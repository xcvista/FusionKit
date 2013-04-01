//
//  help.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "help.h"
#import "main.h"

NSString *appName(void)
{
    NSString *appName = [[NSProcessInfo processInfo] arguments][0];
    return [appName lastPathComponent];
}

void showHelp(BOOL exit)
{
    showAbout(NO);
    
    eprintf("USAGE:   %s [options] input-file -o output-file\n\n", [appName() cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    eprintf("OPTIONS: -h header-name: Specify the output header file name.\n"
            "         -t type:        Specify the output type.\n"
            "         -p prefix:      Specify the output symbols' prefix.\n"
            "         -c class-name:  Specify the output class name.\n"
            "         --help:         Show this help information.\n"
            "         --version:      Show version information.\n\n");
    eprintf("TYPES:   function:       Generate C function. (default)\n"
            "         class:          Generate Objective-C class.\n"
            "                         Use -c to specify the class name.\n"
            "         category:       Generate Objective-C class category.\n"
            "                         Use -c to specify the class to be categorized on.\n"
            "         const:          Generate constant global variables.\n"
            "                         Root object must be a dictionary.\n\n");
    
    if (exit)
        showCopyright();
}

void showAbout(BOOL exit)
{
    eprintf("%s: Property List to Objective-C Source Code Converter.\nCopyright (c) Copyright 2011-2013 John Shi & Maxthon Chan\nAll rights reserved.\n\n", [appName() cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    if (exit)
        showCopyright();
}

void showCopyright(void)
{
    eprintf("Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n"
            "* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n"
            "* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\n"
            "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n");
    exit(0);
}
