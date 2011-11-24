
//
//  main.m
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

/**
 pdb new title="Pig in Flowers" size=48x72 width=36                     // adds new with id=pig_in_flowers date=today, isNew=true
 pdb add title="Pig in Flowers" size=48x72 width=36 date=2011/07/25     // adds with id=pig_in_flowers dateAdded=2011/07/25, isNew=false
 pdb delete title="Pig in Flowers" or pdb delete id="pig_in_flowers"    // deletes painting
 pdb unsetnew                                                           // sets all isNew=false. Perform before running a bunch of "pdb new"
 pdb sold title="Pig in Flowers" date="2011/08/20"                      // sets isSold=true, dateSold=2011/08/20. If date not given date=today
 pdb change title="Pig in Flowers" or id=pig_in_flowers + list of attributes to change // changes given attribute(s)
 */

#include "CommandProcessor.h"

NSManagedObjectModel *managedObjectModel(void);
NSManagedObjectContext *managedObjectContext(void);

 

int main (int argc, const char * argv[])
{

    @autoreleasepool {
        
        if (argc < 2) {
            [CommandProcessor help:nil];
            return 1;
        }
        
        // Process command line
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        NSString *command = [args objectAtIndex:1];    // this may throw
        NSLog(@"Command is \"%@\"!\n", command);
        
        NSMutableDictionary* parameters;
        NSLog(@"Parameters:\n");
        for (size_t index = 2; index < argc; index++) {
            NSString* keyValue = [args objectAtIndex:index];
            NSLog(@"%@\n", keyValue );
            NSArray *split = [keyValue componentsSeparatedByString:@"="];
            [parameters setValue:[split objectAtIndex:1]          // this may throw
                          forKey:[split objectAtIndex:0]];
        }
        
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();

        
        // go build this class
        CommandProcessor* commandProcessor = [[CommandProcessor alloc] initWithCommand:command 
                                                                         AndParameters:parameters];
        commandProcessor.managedProjectContext = context;
        [commandProcessor execute];
        
        
                   
        // Custom code here...
        // Save the managed object context
        NSError *error = nil;    
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    return 0;
}

NSManagedObjectModel *managedObjectModel() {
    
    static NSManagedObjectModel *model = nil;
    
    if (model != nil) {
        return model;
    }
    
    NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
    path = [path stringByDeletingPathExtension];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

NSManagedObjectContext *managedObjectContext() {

    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

