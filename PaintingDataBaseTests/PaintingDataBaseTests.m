//
//  PaintingDataBaseTests.m
//  PaintingDataBaseTests
//
//  Created by Ivan Sergienko on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintingDataBaseTests.h"
#import "Painting.h"
#import "ImageName.h"
#import "Genre.h"

@implementation PaintingDataBaseTests



- (void)setUp
{
    [super setUp];
    
    NSLog(@"%@ setUp", self.name);
//    commandProcessor = [[CommandProcessor alloc] initWithCommand:command 
//                                                      parameters:parameters
//                                            managedObjectContext:context];
    commandProcessor = [[CommandProcessor alloc] init];
    commandProcessor.managedObjectContext = [self managedObjectContext];    
    
    
    STAssertNotNil(commandProcessor, @"Cannot create Calculator instance");

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    // Clean up the database
    
    [super tearDown];
}

/**
 \brief Tests normalized ID function.
 */
- (void) testNormalizedString { 
    
    STAssertTrue([CommandProcessor normalizedString:@" "] == nil, @"Normalized ID 1 is wrong");
    
    STAssertTrue([ [CommandProcessor normalizedString:@"pigs  In flowers"] isEqualToString:@"PigsInFlowers"], @"Normalized ID 2 is wrong");
    
    STAssertTrue([ [CommandProcessor normalizedString:@"1 pigs i Flowers 2"] isEqualToString:@"1PigsIFlowers2"], @"Normalized ID 3 is wrong");
    
}

/**
 \brief Tests dateFromString function.
*/

-(void) testDateConversion {
    NSString* dateString = @"2011/11/17";
    NSDate*   date       = [CommandProcessor dateFromString:dateString];
    
    NSString* dateConvertedBack = [CommandProcessor stringFromDate:date];
    STAssertTrue([dateConvertedBack isEqualToString:dateString], @"Date conversion failed\n\tOriginal date: %@; Converted date: %@", dateString, dateConvertedBack);
    
}

-(BOOL) addGenre:(NSString*) genre {
    commandProcessor._command = @"addGenre";
    NSDictionary* params = [NSDictionary dictionaryWithObject:genre 
                                                       forKey:@"name"];
    commandProcessor._parameters = params;
    return [commandProcessor execute];
}

/**
 \brief Tests addition of a new painting in data base. 
 The painting is subsecquently removed from the database.
 */
- (void)testExecuteNew {
    NSString* genre = @"portrait";
    STAssertTrue([self addGenre:genre], @"Failed addGenre command");
    
    commandProcessor._command = @"new";
    
    // Set up painting attributes
    NSMutableDictionary* params = [NSMutableDictionary
                            dictionaryWithObjects:[NSArray arrayWithObjects:@"pigs  iN fLowers", @"23x54", genre, @"YES", nil] 
                            forKeys:[NSArray arrayWithObjects:@"title", @"size", @"genre", @"favourite", nil]
                            ];
    
    
    commandProcessor._parameters = (NSDictionary*) params;
    STAssertTrue([commandProcessor execute], @"Failed New command");
    
    Painting* existingPainting = [commandProcessor fetchPaintingByTitle];
    STAssertNotNil(existingPainting, @"Painting is not in data base.");
    STAssertTrue([existingPainting.isNew boolValue], @"isNew property is not set");

    // Try different spelling of the same title
    [params setObject:@"Pigs in Flowers" forKey:@"title"];
    commandProcessor._parameters = (NSDictionary*) params;
    STAssertFalse([commandProcessor execute], @"Failed New command");

    existingPainting = [commandProcessor fetchPaintingByTitle];
    STAssertNotNil(existingPainting, @"Painting is not in data base.");

    // Now delete the painting
    [commandProcessor.managedObjectContext deleteObject:existingPainting];
    
    NSError *error = nil;
    if (![commandProcessor.managedObjectContext save:&error]) {
        NSLog(@"Failed saving data in New %@", [error description] );
        return;
    }        
    
}

/**
 \brief Tests addition of a painting in data base. 
 The painting is subsecquently removed from the database.
 */

// change this to add more tests.

- (void)testExecuteAdd {
    NSString* genre = @"loons";
    STAssertTrue([self addGenre:genre], @"Failed addGenre command");
    
    commandProcessor._command = @"add";
    
    //NSDate* date = [CommandProcessor dateFromString:@"2011/11/29"];
    NSString* date = @"2011/11/29";
    // returns empty date
    
    // Set up painting attributes
    NSMutableDictionary* params = [NSMutableDictionary
                                   dictionaryWithObjects:[NSArray arrayWithObjects:@" portrait of  loon", @"48x17", genre   , @"NO"       , date, nil] 
                                   forKeys:              [NSArray arrayWithObjects:@"title"             , @"size" , @"genre", @"favourite", @"date", nil]
                                   ];    
    
    commandProcessor._parameters = (NSDictionary*) params;
    STAssertTrue([commandProcessor execute], @"Failed Add command");
    
    Painting* existingPainting = [commandProcessor fetchPaintingByTitle];
    STAssertNotNil(existingPainting, @"Painting is not in data base.");
    STAssertFalse ([existingPainting.isNew boolValue], @"isNew property should not be set");
    STAssertTrue([ [ CommandProcessor stringFromDate: existingPainting.dateAdded ] isEqualToString:date] , @"dateAddedProperty is wrong");
    
    existingPainting = [commandProcessor fetchPaintingByTitle];
    STAssertNotNil(existingPainting, @"Painting is not in data base.");
    
    // Now delete the painting
    [commandProcessor.managedObjectContext deleteObject:existingPainting];
    
    NSError *error = nil;
    if (![commandProcessor.managedObjectContext save:&error]) {
        NSLog(@"Failed saving data in Add: %@", [error description] );
        return;
    }        
    
}

- (NSManagedObjectModel *) managedObjectModel {
    
    static NSManagedObjectModel *model = nil;
    
    if (model != nil) {
        return model;
    }
    NSString* path = @"/Users/ivan/Library/Developer/Xcode/DerivedData/PaintingDataBase-gulunzriiaqefzcgxubjluboonvb/Build/Products/Debug/PaintingDataBaseTests.octest/Contents/Resources/PaintingDataBase.momd";
    
    
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

- (NSManagedObjectContext *) managedObjectContext {
    
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }
    
    @autoreleasepool {
        
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [context setPersistentStoreCoordinator:coordinator];
        //[context setUndoManager:nil];  // <-- Good technique to improve performance if Undo functionality not needed. I may want Undo here!
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString* path = @"/Users/ivan/Library/Developer/Xcode/DerivedData/PaintingDataBase-gulunzriiaqefzcgxubjluboonvb/Build/Products/Debug/PaintingDataBaseTests.octest/Contents/Resources/PaintingDataBase.sqlite";
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}


@end
