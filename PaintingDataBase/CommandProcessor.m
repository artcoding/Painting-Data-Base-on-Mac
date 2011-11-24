//
//  CommandProcessor.m
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommandProcessor.h"

@interface CommandProcessor()  // "private" properties
@property (strong, nonatomic) NSString*     _command;
@property (strong, nonatomic) NSDictionary* _parameters;
@end

@implementation CommandProcessor

@synthesize managedProjectContext;
@synthesize _command, _parameters;

/**
 pdb new title="Pig in Flowers" size=48x72 width=36                     // adds new with id=pig_in_flowers date=today, isNew=true
 pdb add title="Pig in Flowers" size=48x72 width=36 date=2011/07/25     // adds with id=pig_in_flowers dateAdded=2011/07/25, isNew=false
 pdb delete title="Pig in Flowers" or pdb delete id="pig_in_flowers"    // deletes painting
 pdb unsetnew                                                           // sets all isNew=false. Perform before running a bunch of "pdb new"
 pdb sold title="Pig in Flowers" date="2011/08/20"                      // sets isSold=true, dateSold=2011/08/20. If date not given date=today
 
 */

+(void) help: (NSString*) command{
    NSDictionary *helpDictionary 
        = [NSDictionary dictionaryWithObjectsAndKeys:
           @"title=\"Pig in Flowers\" size=48x72 width=36\n\tCreates a new record with id=pig_in_flowers, date=today",  @"new", 
           @"title=\"Pig in Flowers\" size=48x72 width=36 date=2011/07/25\n\tCreates a new record with id=pig_in_flowers, dateAdded=2011/07/25",
                                                                                                                        @"add",
           @"title=\"Pig in Flowers\" (or id=pig_in_flowers)\n\tDeletes corresponding painting",                        @"delete",
           @"\n\tUnsets all isNew flags. Perform before running a bunch of \"pdb new\"",                                @"unsetnew",
           @"title=\"Pig in Flowers\" date=2011/08/20\n\tSet isSold, dateSold=2011/08/20. If date not given date=today",@"sold",
           @"title=\"Pig in Flowers\" or id=pig_in_flowers + list of attributes to change\n\tChanges given attribute(s); date=2011/08/20 will change dateAdded, not dateSold. Use sold command for dateSold",                                                                        @"change",
           @"\n\tOutput full help.",                                                                                    @"help",
           nil];
    
    NSString* name = [[NSProcessInfo processInfo] processName];
    
    if (command && ![command isEqualToString: @"help"]) {      // command provided - try finding its help
        NSString* log = [helpDictionary valueForKey:command];
        if (log) {      // valid command - output only its help and return get out
            NSLog(@"Improper use of %@ command. Usage is:\n%@ %@ %@", command, name, command,  log);
            return;
        }
    }
    // if command == nil or == "help" or unsupported - output general help
    
    NSMutableString* fullHelp = [NSMutableString stringWithString:@"\nUsage is:\n\n"];
    for (NSString* com in helpDictionary) {
        [fullHelp appendFormat:@"%@ %@ %@\n", name, com, [helpDictionary valueForKey:com]];
    }   
    NSLog (@"%@", fullHelp);
}

-(id) initWithCommand:(NSString*) command
                       AndParameters:(NSDictionary*) parameters{
    
    //CommandProcessor* processor = nil;
    self = [super init];    // Designated initializer inits super!
    if (!self) {
        return self;  // Using exceptions is not recommended! Let caller deal with nil
    }
    
    self._command    = command;
    self._parameters = parameters;
    // Check for valid values here

    
    return self;
}

-(void) execute{
    NSLog(@"Command is %@\n", self._command);
    if ([self._command isEqualToString: @"help"]) {
        [CommandProcessor help:self._command];
    }
    
}



@end
