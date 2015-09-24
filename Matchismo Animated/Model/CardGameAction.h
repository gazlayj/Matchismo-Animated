//
//  CardGameAction.h
//  Matchismo
//
//  Created by Justin Gazlay on 9/18/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CardGameActionType) {
    CardChosen,
    Match,
    Mismatch
};

@interface CardGameAction : NSObject

@property (readonly, strong, nonatomic) NSArray *chosenCards; // of Card
@property (readonly, nonatomic) NSInteger pointsEarned;
@property (readonly, nonatomic) CardGameActionType actionType;

- (instancetype)initCardGameActionWithChosenCards:(NSArray *)chosenCards;

- (CardGameActionType)matchCards;
- (NSInteger)applyMatchBonusMultiplier:(int)bonusMultiplier;
- (NSInteger)subtractMismatchPenalty:(int)mismatchPenalty;

@end
