//
//  SetCard.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/14/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#pragma mark - Property Setters/Getters
- (NSString *)contents
{
    return nil;
}

- (void)setColorIdentifier:(NSUInteger)colorIdentifier
{
    if (colorIdentifier < [SetCard maxValuesForASetCardProperty]) {
        _colorIdentifier = colorIdentifier;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number > 0 && number <= [SetCard maxValuesForASetCardProperty]) {
        _number = number;
    }
}

- (void)setShadingIdentifier:(NSUInteger)shadingIdentifier
{
    if (shadingIdentifier < [SetCard maxValuesForASetCardProperty]) {
        _shadingIdentifier = shadingIdentifier;
    }
}

- (void)setSymbolIdentifier:(NSUInteger)symbolIdentifier
{
    if (symbolIdentifier < [SetCard maxValuesForASetCardProperty]) {
        _symbolIdentifier = symbolIdentifier;
    }
}

#pragma mark - Instance Methods

- (int)match:(NSArray *)otherCards
{
    int gameScore = 0;
    
    if ([self isCardsMatch:otherCards]) {
        gameScore = 5;
    }
    
    return gameScore;
    
}

#pragma mark - Helper Methods

- (BOOL)isCardsMatch:(NSArray *)otherCards
{
    
    
    if ([self isNumbersMatch:otherCards] &&
        [self isSymbolsMatch:otherCards] &&
        [self isShadingsMatch:otherCards] &&
        [self isColorsMatch:otherCards]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNumbersMatch:(NSArray *)otherCards
{
    if (otherCards.count == 2) {
        NSArray *properties = @[[NSNumber numberWithUnsignedInteger:[self number]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[0] number]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[1] number]]];
        return [self isIntegersMatch:properties];
    }
    
    return NO;
    
}

- (BOOL)isSymbolsMatch:(NSArray *)otherCards
{
    if (otherCards.count == 2) {
        NSArray *properties = @[[NSNumber numberWithUnsignedInteger:[self symbolIdentifier]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[0] symbolIdentifier]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[1] symbolIdentifier]]];
        return [self isIntegersMatch:properties];
    }
    
    return NO;
}

- (BOOL)isShadingsMatch:(NSArray *)otherCards
{
    if (otherCards.count == 2) {
        NSArray *properties = @[[NSNumber numberWithUnsignedInteger:[self shadingIdentifier]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[0] shadingIdentifier]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[1] shadingIdentifier]]];
        return [self isIntegersMatch:properties];
    }
    
    return NO;
}

- (BOOL)isColorsMatch:(NSArray *)otherCards
{
    if (otherCards.count == 2) {
        NSArray *properties = @[[NSNumber numberWithUnsignedInteger:[self colorIdentifier]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[0] colorIdentifier]],
                                [NSNumber numberWithUnsignedInteger:[otherCards[1] colorIdentifier]]];
        return [self isIntegersMatch:properties];
    }
    
    return NO;
}

- (BOOL)isIntegersMatch:(NSArray *)integers
{
    if (integers.count == 3) {
        if ([integers[0] isEqualToNumber:integers[1]] &&
            [integers[0] isEqualToNumber:integers[2]]) {
            return YES;
        } else if (![integers[0] isEqualToNumber:integers[1]] &&
                   ![integers[0] isEqualToNumber:integers[2]] &&
                   ![integers[1] isEqualToNumber:integers[2]]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Class Methods


+ (NSUInteger)maxValuesForASetCardProperty
{
    return 3;
}

@end
