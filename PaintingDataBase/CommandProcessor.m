//
//  CommandProcessor.m
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommandProcessor.h"
#import "Painting.h"
#import "Genre.h"
#import "ImageName.h"

@interface CommandProcessor()  // "private" properties
@property (strong, nonatomic) NSString*     _command;
@property (strong, nonatomic) NSDictionary* _parameters;

/** Fetches painting from store for various reasons: 
 *  to just check if it is already there, or change/report something
 */
-(Painting *) fetchPaintingByTitle; //:(NSString*) normalizedID;
//-(NSArray *) fetchPainting;

/**
 Returns NSArray* of NSNumbers representing hegiht and width of painitng.
 \todo throw exception if size is misspecified
 */
-(NSArray*) paintingSize;

/**
 Returns genre of painitng.
 \todo throw exception if genre does not exist.
 */
-(Genre*) paintingGenre;

/**
 Executes new command - add new painting to Data Base
 Return true on success or false if fails
 */ 
-(BOOL) executeNew;

-(BOOL) executeAddGenre;

@end

@implementation CommandProcessor

@synthesize managedObjectContext;
@synthesize _command, _parameters;

+(NSString*) normalizedString:(NSString*) aString {
    // 1. Convert to lower case
    NSString* lowercase = [aString lowercaseString];
    // 2. Split on white spaces
    NSArray* split = [lowercase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([split count] == 0){ // aString has no words
        return nil;
    }    
    
    // 3. Capitalize 1st letter in each word
    NSMutableString* joined = [[NSMutableString alloc] init];
    NSString* word;
    for ( word in split ) {
        
        [joined setString:[NSString stringWithFormat:@"%@%@",[[word substringToIndex:1] capitalizedString],[word substringFromIndex:1]]];
    }
    return (NSString*)joined;
}

-(NSString*) normalizedIDInRequest{
    
    NSString* title = [self._parameters valueForKey:@"title"];
    return [CommandProcessor normalizedString:title];
    // throw if empty normalized
}

+(void) help: (NSString*) command{
    NSDictionary *helpDictionary 
        = [NSDictionary dictionaryWithObjectsAndKeys:
           @"title=\"Pig in Flowers\" size=48x72 width=36\n\tCreates a new record with id=pig_in_flowers, date=today",  @"new", 
           @"title=\"Pig in Flowers\" size=48x72 width=36 date=2011/07/25\n\tCreates a new record with id=pig_in_flowers, dateAdded=2011/07/25",  @"add",
           @"title=\"Pig in Flowers\" (or id=pig_in_flowers)\n\tDeletes corresponding painting",                        @"delete",
           @"\n\tUnsets all isNew flags. Perform before running a bunch of \"pdb new\"",                                @"unsetnew",
           @"title=\"Pig in Flowers\" date=2011/08/20\n\tSet isSold, dateSold=2011/08/20. If date not given date=today",@"sold",
           @"title=\"Pig in Flowers\" or id=pig_in_flowers + list of attributes to change\n\tChanges given attribute(s); date=2011/08/20 will change dateAdded, not dateSold. Use sold command for dateSold\n\tPossible atrributes:favourite=YES/NO, size=48x36, genre=\"still life\"",                                                 @"change",
           @"title=\"Pig in Flowers\"",                                                                                 @"doNotShow",
           @"\n\tOutput full help.",                                                                                    @"help",
           @"name=scrambles\n\tCreates new genre scrambles. Should not get used much.",                                 @"addGenre",
           @"name=scrambles\n\tDeletes genre scrambles. CAREFUL, there might be paintings in it",                       @"deleteGenre",
           @"<attribute1=value1>, <attribute2=value2>... Non-case sensitive search in DB. Prints on console",           @"fetch",
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
           parameters:(NSDictionary*) parameters
 managedObjectContext:(NSManagedObjectContext* ) context {

    //CommandProcessor* processor = nil;
    self = [super init];    // Designated initializer inits super!
    if (!self) {
        return self;  // Using exceptions is not recommended! Let caller deal with nil
    }
    
    self.managedObjectContext = context;
    self._command             = command;
    self._parameters          = parameters;
    
    return self;
}

-(void) execute {
    NSLog(@"Command is %@\n", self._command);
    if ([self._command isEqualToString:@"new"]) {
        [self executeNew];
    } else if ([self._command isEqualToString:@"add"]) {
        
    } else if ([self._command isEqualToString:@"delete"]) {
        
    } else if ([self._command isEqualToString:@"unsetnew"]) {
        
    } else if ([self._command isEqualToString:@"sold"]) {
        
    } else if ([self._command isEqualToString:@"change"]) {
        
    } else if ([self._command isEqualToString:@"doNotShow"]) {
        
    } else if ([self._command isEqualToString:@"addGenre"]) {
        [self executeAddGenre];
    } else if ([self._command isEqualToString:@"deleteGenre"]) {
        
    } else if ([self._command isEqualToString:@"fetch"]) {
        
    } else { // this case would also include "help" command
        [CommandProcessor help:self._command];
    }
}

#pragma mark - Command-specific private methods

/**
 * Should rethrow if [self normalizedIDInRequest] fails.
 */
-(Painting *) fetchPaintingByTitle {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Painting"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSString* normalizedID = self.normalizedIDInRequest;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"normalizedID LIKE %@", normalizedID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // executeFetchRequest returns nil iff there is a problem. If no problem but no object match request - returns empty array (not nil)! 
    if (fetchedObjects == nil) {
        // So this is a real problem - throw an exception here!
        return nil;
    }
    return [fetchedObjects lastObject];
}

-(NSArray*) paintingSize{
    NSString* sizeString = [self._parameters valueForKey:@"size"];
    NSArray* split = [sizeString componentsSeparatedByString:@"x"];
    if ( [split count] != 2 ){
        // @throw SizeException
    }
    
    //NSSize size;
    NSNumber* height = [ NSNumber numberWithInteger: [[split objectAtIndex:0] integerValue] ];
    NSNumber* width  = [ NSNumber numberWithInteger: [[split objectAtIndex:1] integerValue] ];
    NSArray*  size   = [ NSArray arrayWithObjects: height, width, nil ];
    return [size autorelease];  // Should it be autoreleased?
    
}

-(Genre*) paintingGenre {
    NSString* genreName = [CommandProcessor normalizedString:[self._parameters valueForKey:@"genre"]];
    if (!genreName) {
        // @throw;
    }
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Genre"
                                 inManagedObjectContext:self.managedObjectContext ];
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", genreName];
	
	NSError *error = nil;
	Genre* genre = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
	//[request release];
    
	if (!error && !genre) {
        // throw here. New genres must be added by "genre" command.

    }
	
	return genre;
}

-(BOOL) executeNew {
    Painting* existingPainting = [self fetchPaintingByTitle];
    if (existingPainting) { // Painting already in data base
        // Output error existingPainting data here and quit
        return false;
    }
    
    Painting* newPainting = [NSEntityDescription insertNewObjectForEntityForName:@"Painting"
                                                          inManagedObjectContext:self.managedObjectContext];
    
    newPainting.title        = [self._parameters valueForKey:@"title"];
    newPainting.normalizedID = self.normalizedIDInRequest;
    newPainting.isNew        = [NSNumber numberWithBool:YES];
    
    newPainting.dateAdded = [NSDate date];  // today
    
    NSArray* size = [self paintingSize];
    newPainting.height = [size objectAtIndex:0];
    newPainting.width  = [size objectAtIndex:1];
    
    BOOL isFavourite = [[self._parameters valueForKey:@"favourite"] isEqualToString:@"YES"];
    newPainting.isMyFavourite = [NSNumber numberWithBool:isFavourite];

    newPainting.genre = [self paintingGenre];
    
    ImageName* newImageName = [NSEntityDescription insertNewObjectForEntityForName:@"ImageName"
                                                            inManagedObjectContext:self.managedObjectContext];
    newImageName.iPadFull      = [NSString stringWithFormat: @"full_%@",  newPainting.normalizedID];
    newImageName.iPadThumbnail = [NSString stringWithFormat: @"thumb_%@", newPainting.normalizedID];
    newImageName.webImage      = newPainting.normalizedID;
    newPainting.imageName = newImageName;

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Something wrong with DB - throw
        return false;
    }    
    
    return true;
    
}

-(BOOL) executeAddGenre {
    NSString* genreName = [CommandProcessor normalizedString: [self._parameters valueForKey:@"name"] ];
    if (!genreName) {
        // @throw;
        return false;
    }
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Genre"
                                 inManagedObjectContext:self.managedObjectContext ];
	request.predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", genreName];
	
	NSError *error = nil;
    Genre* genre = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    NSAssert(error == nil, @"Error fetching genre request");
    
	if (genre) { 
        // genre already exists -> Output warning
        NSLog(@"Genre %@ already exists in the data base\n", genreName); 
    } else { // save new genre
        genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" 
                                              inManagedObjectContext:self.managedObjectContext];
		genre.name = genreName;
        
        if (![self.managedObjectContext save:&error]) {
            // Something wrong with DB - throw
            return false;
        }
        NSLog(@"Successfully added genre %@ to the Data Base\n", genreName);
    }
    return true;
}

@end
