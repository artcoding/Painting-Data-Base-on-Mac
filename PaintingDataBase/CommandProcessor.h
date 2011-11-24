//
//  CommandProcessor.h
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandProcessor : NSObject

+(void) help: (NSString*) command;

-(id) initWithCommand:(NSString*) command
        AndParameters:(NSDictionary*) parameters;

-(void) execute;

@property (weak,nonatomic) NSManagedObjectContext* managedProjectContext;


@end
