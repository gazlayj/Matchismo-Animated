//
//  SetCard.h
//  Matchismo
//
//  Created by Justin Gazlay on 9/14/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbolIdentifier;
@property (nonatomic) NSUInteger shadingIdentifier;
@property (nonatomic) NSUInteger colorIdentifier;

+ (NSUInteger)maxValuesForASetCardProperty;

@end
