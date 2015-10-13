//
//  ViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 9/23/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "ViewController.h"
#import "CardsViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "Card.h"

@interface ViewController () <CardsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardsInPlay;
@property (nonatomic) NSUInteger numberOfCardsInGame;
@property (nonatomic) NSUInteger indexOfNextCardToDisplay;
@property (strong, nonatomic) NSMutableArray *indexesOfDisplayedCards;
@end

@implementation ViewController

static const int NUMBER_OF_CARDS_TO_SHOW = 20;

-(NSArray *)indexesOfDisplayedCardsAtIndexes:(NSIndexSet *)indexes
{
    if (!_indexesOfDisplayedCards) _indexesOfDisplayedCards = [[NSMutableArray alloc] init];
    return _indexesOfDisplayedCards;
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSUInteger)numberOfCardsInGame
{
    if (!_numberOfCardsInGame) _numberOfCardsInGame = 0;
    return _numberOfCardsInGame;
}

-(NSUInteger)indexOfNextCardToDisplay
{
    if (!_indexOfNextCardToDisplay) _indexOfNextCardToDisplay = 0;
    return _indexOfNextCardToDisplay;
}

-(CardMatchingGame *)game
{
    if (!_game) {
        [self newGame];
    }
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews
{
    [self displayCardsViewController];
}

- (void)displayCardsViewController
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUMBER_OF_CARDS_TO_SHOW; i++) {
        [cards addObject:[self nextCardToDisplay]];
        [self.indexesOfDisplayedCards addObject:[NSNumber numberWithUnsignedInteger:self.indexOfNextCardToDisplay]];
        self.indexOfNextCardToDisplay += 1;
    }
    
    CardsViewController *cardsVC = [[CardsViewController alloc] initWithCards:[cards copy]];
    cardsVC.delegate = self;
    [self displayContentController:cardsVC];
}

- (void) displayContentController:(UIViewController*)content {
    [self addChildViewController:content];
    content.view.frame = self.cardsContainerView.frame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

-(void)cardViewForCardTapped:(Card *)card
{
    card.chosen = !card.isChosen;
    [self replaceMatchedCards];
}

- (void)replaceMatchedCards
{
    NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
    NSMutableArray *replacementCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.indexesOfDisplayedCards count]; i++) {
        NSUInteger cardIndex = [self.indexesOfDisplayedCards[i] unsignedIntegerValue];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isMatched) {
            [matchedCards addObject:card];
            [replacementCards addObject:[self nextCardToDisplay]];
            self.indexOfNextCardToDisplay += 1;
            

        }
    }
    
    if ([matchedCards count]) {
        CardsViewController *cardsVC = [self getCardsViewController];
        
        [cardsVC replaceCards:matchedCards withNewCards:replacementCards animated:YES];
        //need a way to replace the matchedCards index in indexesOfDisplayedCards with the Replacement card indexes

    }
}

- (CardsViewController *)getCardsViewController
{
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[CardsViewController class]]) {
            return (CardsViewController *)controller;
        }
    }
    return nil;
}

- (void)newGame
{
    Deck *deck = [self createDeck];
    self.numberOfCardsInGame = [deck numberOfCardsInDeck];
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsInGame
                                                  usingDeck:deck];
}

- (Card *)nextCardToDisplay
{
    return [self.game cardAtIndex:self.indexOfNextCardToDisplay];
}


@end
