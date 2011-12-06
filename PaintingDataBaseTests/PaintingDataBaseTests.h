//
//  PaintingDataBaseTests.h
//  PaintingDataBaseTests
//
//  Created by Ivan Sergienko on 11-11-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "CommandProcessor.h"


@interface PaintingDataBaseTests : SenTestCase
{
@private 
    CommandProcessor* commandProcessor;
}

- (NSManagedObjectModel*)   managedObjectModel;
- (NSManagedObjectContext*) managedObjectContext;


@end
