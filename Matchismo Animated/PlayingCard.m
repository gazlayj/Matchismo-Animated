//
//  PlayingCard.m
//  Matchismo
//
//  Created by Justin Gazlay on 9/1/15.
//  Copyright (c) 2015 Justin Gazlay. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

static const int MATCHED_RANK_SCORE = 4;
static const int MATCHED_SUITE_SCORE = 1;

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([self isOneCardToMatch:otherCards]) {
        PlayingCard *otherCard = [otherCards firstObject];
        score = [self scoreForSingleMatchCard:otherCard];
    } else if ([self isMultipleCardsToMatch:otherCards]) {
        score = [self scoreForMultipleMatchCards:otherCards];
    }

    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank { return [[self rankStrings] count]-1;}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

#pragma mark - HelperMethods

- (BOOL)isOneCardToMatch:(NSArray *)otherCards
{
    return ([otherCards count] == 1) ? YES : NO;
}

- (BOOL)isMultipleCardsToMatch:(NSArray *)otherCards
{
    return ([otherCards count] > 1) ? YES : NO;
}

- (int)scoreForSingleMatchCard:(PlayingCard *)card
{
    int score = 0;
    
    if ([self isSameRankAsCard:card]) {
        score = MATCHED_RANK_SCORE;
    } else if ([self isSameSuiteAsCard:card]) {
        score = MATCHED_SUITE_SCORE;
    }
    
    return score;
}

- (int)scoreForMultipleMatchCards:(NSArray *)otherCards
{
    int score = 0;
    int matchCount = 0;
    
    for (PlayingCard *otherCard in otherCards) {
        if ([self isSameRankAsCard:otherCard]) {
            score = MATCHED_RANK_SCORE;
            matchCount += 1;
        } else if ([self isSameSuiteAsCard:otherCard]) {
            score = MATCHED_SUITE_SCORE;
            matchCount += 1;
        }
    }
    
    if (matchCount > 0) {
        score += score * matchCount;
    }
    
    return score;
}

- (BOOL)isSameRankAsCard:(PlayingCard *)card
{
    return (self.rank == card.rank) ? YES : NO;
}

- (BOOL)isSameSuiteAsCard:(PlayingCard *)card
{
    return ([self.suit isEqualToString:card.suit]) ? YES : NO;
}

@end
