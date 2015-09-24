//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Justin Gazlay on 9/3/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
#import "CardGameAction.h"

#pragma mark - CardMatchingGame Public Interface
@interface CardMatchingGame : NSObject

#pragma mark - Designated initalizer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

#pragma mark - Instance Methods
- (void)choosecardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

#pragma mark - Properties
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger numberOfCardsToCompareMatch;
@property (nonatomic, readonly) BOOL gameStarted;
@property (nonatomic, strong, readonly) NSArray *gameActions; // of CardGameAction

@end
