//
//  CommandProcessor.m
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommandProcessor.h"
//#import "Painting.h"
#import "Genre.h"
#import "ImageName.h"

@interface CommandProcessor()  // "private" properties

/** 
 \return an instance of NSDateFormatter initialized for date format "YYYY/MM/DD"
 */
+(NSDateFormatter*) dateFormatter;

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
 Return YES on success or NO if fails
 */ 
-(BOOL) executeAddWithNewSetTo: (BOOL)new;

-(BOOL) executeAddGenre;

@end

@implementation CommandProcessor

@synthesize managedObjectContext;
@synthesize _command, _parameters;

+(NSDateFormatter*) dateFormatter {
    static NSDateFormatter* formatter;
    if (!formatter) {
        //formatter = [[NSDateFormatter alloc] initWithDateFormat:@"yyyy'/'MM'/'dd" allowNaturalLanguage:NO];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'/'MM'/'dd"];
    }
    return formatter;

}

+(NSDate*) dateFromString:(NSString*) dateString {
    //NSDateFormatter* formatter = [[NSDateFormatter alloc] initWithDateFormat:@"yyyy'/'MM'/'dd" allowNaturalLanguage:NO];
    return [[self.class dateFormatter] dateFromString:dateString];
}

+(NSString*) stringFromDate:(NSDate*) date {
   // NSDateFormatter* formatter = [[NSDateFormatter alloc] initWithDateFormat:@"yyyy'/'MM'/'dd" allowNaturalLanguage:NO];
    return [[self.class dateFormatter] stringFromDate:date];
}


+(NSString*) normalizedString:(NSString*) aString {
    // 1. Convert to lower case
    NSString* lowercase = [aString lowercaseString];
    
    // 2. Result string
    NSMutableString* joined = [[NSMutableString alloc] init];
    NSScanner* scanner = [NSScanner scannerWithString:lowercase];
    while ( ![scanner isAtEnd] ) {
        // Scan up to next alpha-numeric character
        [scanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:nil];
        // Scan word to next white space
        NSString* word;
        if ( ![scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&word]) {
            break;
        }
        // Capitalize 1st letter of word
        NSString* Word = [NSString stringWithFormat:@"%@%@",[[word substringToIndex:1] capitalizedString],[word substringFromIndex:1]];
        [joined appendString:Word];
        
    }
    
    return [joined isEqualToString:@""] ? nil : (NSString*)joined;
}

-(NSString*) normalizedIDInRequest{
    
    NSString* title = [self._parameters objectForKey:@"title"];
    return [self.class normalizedString:title];
}

+(void) help: (NSString*)command {
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
            NSLog(@"Usage of command %@ is:\n%@ %@ %@", command, name, command,  log);
            return;
        }
    }
    
    NSMutableString* fullHelp = [NSMutableString stringWithString:@"\nUsage is:\n\n"];
    for (NSString* com in helpDictionary) {
        [fullHelp appendFormat:@"%@ %@ %@\n", name, com, [helpDictionary valueForKey:com]];
    }   
    NSLog (@"%@", fullHelp);
}

///< Designated initializer
-(id) init {
    self = [super init];
    return self;
}

-(id) initWithCommand:(NSString*) command
           parameters:(NSDictionary*) parameters
 managedObjectContext:(NSManagedObjectContext* ) context {

    [self init];    // Designated initializer!
    if (!self) {
        return self;  // Using exceptions is not recommended! Let caller deal with nil
    }
    
    self.managedObjectContext = context;
    self._command             = command;
    self._parameters          = parameters;
    
    return self;
}

-(BOOL) execute {
    NSLog(@"Command is %@\n", self._command);
    if ([self._command isEqualToString:@"new"]) {
        return [self executeAddWithNewSetTo:YES];
    } else if ([self._command isEqualToString:@"add"]) {
        return [self executeAddWithNewSetTo:NO];
    } else if ([self._command isEqualToString:@"delete"]) {
        
    } else if ([self._command isEqualToString:@"unsetnew"]) {
        
    } else if ([self._command isEqualToString:@"sold"]) {
        
    } else if ([self._command isEqualToString:@"change"]) {
        
    } else if ([self._command isEqualToString:@"doNotShow"]) {
        
    } else if ([self._command isEqualToString:@"addGenre"]) {
        return [self executeAddGenre];
    } else if ([self._command isEqualToString:@"deleteGenre"]) {
        
    } else if ([self._command isEqualToString:@"fetch"]) {
        
    } else { // this case would also include "help" command
        [CommandProcessor help:self._command];
    }
    return YES;
}

#pragma mark - Command-specific methods

/**
 * Should rethrow if [self normalizedIDInRequest] fails.
 */
-(Painting *) fetchPaintingByTitle {
    NSString* normalizedID = self.normalizedIDInRequest;
    if (!normalizedID) {
        NSLog (@"Must provide valid title");
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Painting"
                                              inManagedObjectContext:self.managedObjectContext];
    NSAssert(entity, @"Illegal Entity requested in Model"); 
    [fetchRequest setEntity:entity];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"normalizedID = %@", normalizedID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // executeFetchRequest returns nil iff there is a problem. If no problem but no object match request - returns empty array (not nil)! 
    if (fetchedObjects == nil) {        
        NSException* anException = [NSException exceptionWithName:@"ProblemWithDatabaseException" reason:@"EXCEPTION: Serious Problem With Database" userInfo:nil];
        @throw anException;
        return nil;
    }
    return [fetchedObjects lastObject];
}

-(NSArray*) paintingSize{
    NSString* sizeString = [self._parameters valueForKey:@"size"];

    NSArray* split = [sizeString componentsSeparatedByString:@"x"];
    if ( [split count] != 2 ){
        NSLog (@"ERROR: size must be of form 00x00\n");
        return nil;
    }
    
    NSNumber* height = [ NSNumber numberWithInteger: [[split objectAtIndex:0] integerValue] ];
    NSNumber* width  = [ NSNumber numberWithInteger: [[split objectAtIndex:1] integerValue] ];
    NSArray*  size   = [ NSArray arrayWithObjects: height, width, nil ];
    return size;  // Should it be autoreleased?
    
}

-(Genre*) paintingGenre {
    NSString* genreName = [CommandProcessor normalizedString:[self._parameters valueForKey:@"genre"]];
    if (!genreName) {
        NSLog (@"ERROR: valid genre must be provided\n");
        return nil;
    }
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Genre"
                                 inManagedObjectContext:self.managedObjectContext ];
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", genreName];
	
	NSError *error = nil;
	Genre* genre = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    
	if (!genre) {
        // throw here. New genres must be added by "genre" command.
        NSLog(@"Genre does not exist. Use addGenre command:\n%@", [error description]);
        [self.class help:@"addGenre"];
        return nil;
    }
	
	return genre;
}

-(BOOL) executeAddWithNewSetTo: (BOOL)new {
    Painting* thePainting = [self fetchPaintingByTitle];
    if (thePainting) { // Painting already in data base
        // Output error existingPainting data here and quit
        return NO;
    }
    
    thePainting = [NSEntityDescription insertNewObjectForEntityForName:@"Painting"
                                                          inManagedObjectContext:self.managedObjectContext];
    
    thePainting.title        = [self._parameters objectForKey:@"title"];
    thePainting.normalizedID = self.normalizedIDInRequest;
    if (!thePainting.normalizedID) {
        NSLog(@"ERROR: Invalid title %@.", thePainting.title);
        [self.class help:@"new"];
        return NO;
    }
    
    thePainting.isNew     = [NSNumber numberWithBool:new];
    
    NSDate* date = [NSDate date]; // today's date
    if (!new) { // if not new - check if date is given
        NSString* dateInRequest = [self._parameters objectForKey:@"date"];
        if (dateInRequest) // if date is provided in request - try to use it
            date = [self.class dateFromString:dateInRequest];
    }    
    if (!date) {
        NSLog(@"Problem setting date.\n");
        [self.class help:@"add"];
        return NO;
    }
    
    thePainting.dateAdded = date;  // today
    
    NSArray* size = [self paintingSize];
    if (!size) {
        [self.class help:@"new"];
        return NO;
    }
    
    thePainting.height = [size objectAtIndex:0];
    thePainting.width  = [size objectAtIndex:1];
    
    BOOL isFavourite = [[self._parameters valueForKey:@"favourite"] isEqualToString:@"YES"];
    thePainting.isMyFavourite = [NSNumber numberWithBool:isFavourite];

    thePainting.genre = [self paintingGenre];
    if ( !thePainting.genre ) {
        return NO;
    }
    
    ImageName* theImageName    = [NSEntityDescription insertNewObjectForEntityForName:@"ImageName"
                                                               inManagedObjectContext:self.managedObjectContext];
    theImageName.iPadFull      = [NSString stringWithFormat: @"full_%@",  thePainting.normalizedID];
    theImageName.iPadThumbnail = [NSString stringWithFormat: @"thumb_%@", thePainting.normalizedID];
    theImageName.webImage      = thePainting.normalizedID;
    thePainting.imageName      = theImageName;

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"new command failed:\n%@", [error description]);
        return NO;
    }    
    
    return YES;
    
}

-(BOOL) executeAddGenre {
    NSString* genreName = [CommandProcessor normalizedString: [self._parameters valueForKey:@"name"] ];
    if (!genreName) {
        // @throw;
        return NO;
    }
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Genre"
                                 inManagedObjectContext:self.managedObjectContext ];
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", genreName];
	
	NSError *error = nil;
    Genre* genre = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    NSAssert(error == nil, @"Error fetching genre request.\n%@",[error description]);
    
	if (genre) { 
        // genre already exists -> Output warning
        NSLog(@"Genre %@ already exists in the data base\n", genreName); 
    } else { // save new genre
        genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" 
                                              inManagedObjectContext:self.managedObjectContext];
		genre.name = genreName;
        
        if (![self.managedObjectContext save:&error]) {
            // Something wrong with DB - throw
            return NO;
        }
        NSLog(@"Successfully added genre %@ to the Data Base\n", genreName);
    }
    return YES;
}

@end
