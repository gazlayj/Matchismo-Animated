//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/3/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import "CardMatchingGame.h"

#pragma mark - CardMatchingGame Private Interface
@interface CardMatchingGame()
@property (strong, nonatomic) Deck *deck;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) BOOL gameStarted;
@property (nonatomic, strong, readwrite) NSMutableArray *gameActionHistory;// of CardGameAction
@end

#pragma mark - CardMatchingGame Implemenation
@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

#pragma mark - Properties

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSArray *)gameActions
{
    NSArray *gameActions = [self.gameActionHistory copy];
    return gameActions;
}

-(BOOL)gameStarted
{
    return ([self.gameActions count] > 0) ? YES : NO;
}

-(NSMutableArray *)gameActionHistory
{
    if (!_gameActionHistory) _gameActionHistory = [[NSMutableArray alloc] init];
    return _gameActionHistory;
}

-(NSUInteger)cardsInPlayCount
{
    return [self.cards count];
}

@synthesize numberOfCardsToCompareMatch = _numberOfCardsToCompareMatch;

- (void)setNumberOfCardsToCompareMatch:(NSUInteger)numberOfCardsToCompareMatch
{
    if (!self.gameStarted) {
        _numberOfCardsToCompareMatch = numberOfCardsToCompareMatch;
    }
}

- (NSUInteger)numberOfCardsToCompareMatch
{
    if (!_numberOfCardsToCompareMatch) _numberOfCardsToCompareMatch = 2;
    return _numberOfCardsToCompareMatch;
    
    
}

#pragma mark - Designated Initializer

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    
    if (self) {
        self.deck = deck;
        [self addCardsCount:count];
        
        if ([self.cards count] != count) {
            self = nil;
        }
    }

    return self;
}



#pragma mark - Instance Methods
- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}



-(void)choosecardAtIndex:(NSUInteger)index
{
    Card *card = self.cards[index];
    
    if (!card.isMatched) {
        [self setChosenStateForCard:card];
        [self performGameAction];
        self.score -= COST_TO_CHOOSE;
    }
}

-(NSString *)stringFromBool:(BOOL)boolValue
{
    return boolValue ? @"YES" : @"NO";
}

- (NSUInteger)increaseInPlayCardsCountBy:(NSUInteger)count;
{
    NSUInteger cardsAdded = 0;
    for (int i = 0; i < count; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
            cardsAdded += 1;
        } else {
            break;
        }
    }
    return cardsAdded;
}



#pragma mark - Private Helper Methods

- (void)addCardsCount:(NSUInteger)count
{
    for (int i = 0; i < count; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        } else {
            break;
        }
    }
}

-(void)setChosenStateForCard:(Card *)card
{
    if (card.isChosen) {
        card.chosen = NO;
    } else {
        card.chosen = YES;
    }
}


- (void)performGameAction
{
    CardGameAction *action = [[CardGameAction alloc] initCardGameActionWithChosenCards:[self getChosenUnmatchedCards]];
    
    if ([self enoughCardsForMatchingAction:action]) {
        [self matchCardsForAction:action];
    }
    
    [self.gameActionHistory addObject:action];
}


- (NSArray *)getChosenUnmatchedCards
{
    NSMutableArray *chosenUnmatchedCards = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards) {
        if (card.chosen) {
            if (!card.matched) {
                [chosenUnmatchedCards addObject:card];
            }
        }
    }
    
    return [chosenUnmatchedCards copy];
}

- (BOOL)enoughCardsForMatchingAction:(CardGameAction *)action
{
    return ([action.chosenCards count] == self.numberOfCardsToCompareMatch) ? YES : NO;
}


- (void)matchCardsForAction:(CardGameAction *)action
{
    [action matchCards];
    [self applyBonusOrPenaltyToAction:action];
}

- (void)applyBonusOrPenaltyToAction:(CardGameAction *)action
{
    switch (action.actionType) {
        case Match:
            self.score += [action applyMatchBonusMultiplier:MATCH_BONUS];
            break;
            
        case Mismatch:
            self.score += [action subtractMismatchPenalty:MISMATCH_PENALTY];
            break;
            
        default:
            break;
    }
}


@end
