//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/14/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger number = 1; number <= [SetCard maxValuesForASetCardProperty]; number++) {
            for (NSUInteger symbolIdentifier = 0; symbolIdentifier < [SetCard maxValuesForASetCardProperty]; symbolIdentifier++) {
                for (NSUInteger shadingIdentifier = 0; shadingIdentifier < [SetCard maxValuesForASetCardProperty]; shadingIdentifier++) {
                    for (NSUInteger colorIdentifier = 0; colorIdentifier < [SetCard maxValuesForASetCardProperty]; colorIdentifier++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbolIdentifier = symbolIdentifier;
                        card.shadingIdentifier = shadingIdentifier;
                        card.colorIdentifier = colorIdentifier;
                        [self addCard:card];
                    }
                        
                }
            }
        }
    }
    
    return self;
}

@end
