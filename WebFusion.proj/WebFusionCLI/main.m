//
//  main.m
//  WebFusionCLI
//
//  Created by Maxthon Chan on 13-3-7.
//
//

#import <Foundation/Foundation.h>
#import <readline/readline.h>
#import <readline/history.h>
#import <FusionKit/FusionKit.h>
#import <unistd.h>
#import <termios.h>

#define NSDefaultCStringEncoding [NSString defaultCStringEncoding]
#define eprintf(format, ...) fprintf(stderr, format, ##__VA_ARGS__)

NSString *NSReadline(NSString *prompt);
NSString *NSReadpass(NSString *prompt);
int getche(void);

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Scan local frameworks and load them.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *pathRoot = [[[NSProcessInfo processInfo] arguments][0] stringByDeletingLastPathComponent];
        NSArray *localDirectory = [fileManager contentsOfDirectoryAtPath:pathRoot
                                                                   error:NULL];
        NSMutableArray *loadableModules = [NSMutableArray arrayWithCapacity:[localDirectory count]];
        for (NSString *path in localDirectory)
        {
            NSBundle *bundle = [NSBundle bundleWithPath:[pathRoot stringByAppendingPathComponent:path]];
            if (bundle)
            {
                NSLog(@"Loaded: %@", path);
                [bundle load];
                [loadableModules addObject:bundle];
            }
        }
        
        NSString *welcomeMessage =
        @"WebFusion CLI Version 3.0\n"
         "This is the command-line prompt of WebFusion, a social aggregration "
         "application.\n\n";
        
        printf("%s", [welcomeMessage cStringUsingEncoding:NSDefaultCStringEncoding]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *serverRoot = [defaults objectForKey:@"server"];
        if (!serverRoot)
            serverRoot = @"https://www.shisoft.net/ajax/";
        
        if (![serverRoot hasSuffix:@"/"])
            serverRoot = [serverRoot stringByAppendingString:@"/"];
        
        // Perform login
        printf("WebFusion authentication:\n\n");
        
        FKConnection *connection = [[NSClassFromString(@"FKConnection") alloc] initWithServerRoot:[NSURL URLWithString:serverRoot]];
        if (!connection)
        {
            eprintf("ERROR: Cannot establish FusionKit objects. Abort.\n");
            exit(1);
        }
        
        do
        {
            printf("Server:   %s\n", [serverRoot cStringUsingEncoding:NSDefaultCStringEncoding]);
            NSString *username = NSReadline(@"Handle:   ");
            NSString *password = NSReadpass(@"Password: ");
            
            NSError *error = nil;
            if ([connection loginWithUsername:username
                                     password:password
                                        error:&error])
            {
                break;
            }
            else
            {
                if (error)
                {
                    eprintf("Login error: %s\n%s\n\n", [error.localizedDescription cStringUsingEncoding:NSDefaultCStringEncoding], [error.localizedRecoverySuggestion cStringUsingEncoding:NSDefaultCStringEncoding]);
                }
                else
                {
                    eprintf("Login error.\n\n");
                }
            }
            
        } while (1);
        
        // Running
        
        printf("Welcome to %s\n"
               "To get help, type \"help\" and press Enter.\n\n", [serverRoot cStringUsingEncoding:NSDefaultCStringEncoding]);
        clear_history(); // Clear readline history.
        
        NSString *prompt = [NSString stringWithFormat:@"WebFusion %c ", getuid() ? '$' : '#'];
        
        do
        {
            NSString *command = [NSReadline(prompt) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (!command || [@[@"quit", @"exit"] containsObject:command])
                break;
            else if ([command isEqualToString:@"help"])
            {
                
            }
            else
            {
                eprintf("Unrecognized command: %s\n", [command cStringUsingEncoding:NSDefaultCStringEncoding]);
            }
        } while (1);
        
    }
    return 0;
}

int getche(void)
{
    struct termios oldattr, newattr;
    int ch;
    tcgetattr( STDIN_FILENO, &oldattr );
    newattr = oldattr;
    newattr.c_lflag &= ~( ICANON | ECHO); // knock down keybuffer
    tcsetattr( STDIN_FILENO, TCSANOW, &newattr );
    system("stty -echo"); // shell out to kill echo
    ch = getchar();
    system("stty echo");
    tcsetattr( STDIN_FILENO, TCSANOW, &oldattr );
    return ch;
}

NSString *NSReadpass(NSString *prompt)
{
    NSMutableData *data = [NSMutableData dataWithCapacity:16];
    int ch = 0;
    printf("%s", [prompt cStringUsingEncoding:NSDefaultCStringEncoding]);
    while ((ch = getche()) != '\n')
    {
        char _char = ch;
        switch (ch)
        {
            case 0x7f:
                [data setLength:[data length] - 1];
                break;
            default:
                [data appendBytes:&_char length:1];
                break;
        }
    }
    putchar('\n');
    return [[NSString alloc] initWithData:data encoding:NSDefaultCStringEncoding];
}

NSString *NSReadline(NSString *prompt)
{
    char *buf = readline([prompt cStringUsingEncoding:NSDefaultCStringEncoding]);
    if (!buf)
        return nil;
    add_history(buf);
    return [[NSString alloc] initWithCString:buf encoding:NSDefaultCStringEncoding];
}
