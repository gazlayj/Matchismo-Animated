//
//  CardsViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/1/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "CardsViewController.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "Grid.h"



@interface CardsViewController ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Grid *cardGrid;
@property (nonatomic) CGSize cardViewSize;
@property (strong, nonatomic) NSMutableArray *currentCardViews;
@property (nonatomic)NSUInteger removedCardViewsCount;

@end

@implementation CardsViewController

- (Grid *)cardGrid
{
    if (!_cardGrid) {
        [self createCardGrid];
    }
    return _cardGrid;
}

- (void)createCardGrid
{
    self.cardGrid = [[Grid alloc] init];
    self.cardGrid.size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    self.cardGrid.cellAspectRatio = 0.65;
    self.cardGrid.minimumNumberOfCells = [self.cards count];
}

-(CGSize)cardViewSize
{
    CGRect frame = [self.cardGrid frameOfCellAtRow:0 inColumn:0];
    return frame.size;
}

-(NSMutableArray *)currentCardViews
{
    if (!_currentCardViews) {
        _currentCardViews = [[NSMutableArray alloc] init];
    }
    return _currentCardViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCardGrid];
    [self populateCardGrid];
}

- (instancetype)initWithCards:(NSArray *)cards
{
    self = [super init];
    
    if (self) {
        if ([cards count] > 0) {
            _cards = [cards mutableCopy];
        } else {
            self = nil;
            NSLog(@"You must initialize a CardsViewController with at least one card");
        }
    }
    
    return self;
}

- (void)replaceCards:(NSArray *)currentCards withNewCards:(NSArray *)newCards animated:(BOOL)animated
{
    //width*column+row will give the cards[index]
    //row = index % width
    //column = index / width
    
    //replace old cards with new cards in self.cards
    NSIndexSet *currentCardsIndices = [self getIndexSetForCards:currentCards];
    
    if ([currentCardsIndices count] == [newCards count]) {
        [self.cards replaceObjectsAtIndexes:currentCardsIndices withObjects:newCards];
    } else {
        NSLog(@"Number of current cards to replace does NOT match the number of new cards");
    }
    
    //animate currentCardViews off screen
    //populate & animate newCardViews on screen
}

- (NSIndexSet *)getIndexSetForCards:(NSArray *)cards
{
    NSMutableIndexSet *indices = [[NSMutableIndexSet alloc] init];
    
    for (Card *card in cards) {
        if ([self isCurrentCard:card]) {
            [indices addIndex:[self indexForCard:card]];
        }
    }
    
    return [indices copy];
}

- (BOOL)isCurrentCard:(Card *)card
{
    return [self.cards containsObject:card];
}

- (NSUInteger)indexForCard:(Card *)card
{
    return [self.cards indexOfObject:card];
}

- (NSUInteger)rowForCardIndex:(NSUInteger)index
{
    return index % self.cardGrid.rowCount;
}

- (NSUInteger)columnForCardIndex:(NSUInteger)index
{
    return index / self.cardGrid.rowCount;
}

- (void)populateCardGrid
{
    if (self.cardGrid.inputsAreValid) {
        for (NSUInteger row = 0; row < self.cardGrid.rowCount; row++) {
            for (NSUInteger column = 0; column < self.cardGrid.columnCount; column++) {
                CGRect cardFrame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
                NSUInteger indexForCell = [self indexForGridCellAtColumn:column andRow:row];
                if (indexForCell < [self.cards count]) {
                    [self addCardViewWithFrame:cardFrame forCardAtIndex:indexForCell animatedEntrance:YES];
                }
            }
        }
    } else {
        NSLog(@"Grid not created! inputs invalid");
    }
}

- (void)removeAllCardsFromViewAnimated:(BOOL)animated
{
    for (UIView *cardView in self.currentCardViews) {
       if (animated) {
           NSUInteger index = [self.currentCardViews indexOfObject:cardView];
           [self animateRemovalOfCardView:cardView withDelay:[self delayForCardIndex:index]];
        }
    }
    
    if ([self.currentCardViews count] == 0) {
        [self.delegate allCardViewsRemoved];
    }
}

- (void)animateRemovalOfCardView:(UIView *)cardView withDelay:(NSTimeInterval)delay
{
    CGPoint finalCardViewCenter = CGPointMake(0 - (cardView.frame.size.width /2), 0 - cardView.frame.size.height);
    [UIView animateWithDuration:.5
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cardView.center = finalCardViewCenter;
                     }
                     completion:^(BOOL finished) {
                         self.removedCardViewsCount += 1;
                         [self informDelegateOfRemoval];
                     }];

}

-(void)informDelegateOfRemoval
{
    if (self.removedCardViewsCount == [self.currentCardViews count]) {
        [self.delegate allCardViewsRemoved];
    }
}

- (void)animateNewCardView:(PlayingCardView *)cardView withDelay:(NSTimeInterval)delay
{
    CGPoint finalCardViewCenter = cardView.center;
    CGPoint startCardViewCenter = CGPointMake(0 - (cardView.frame.size.width /2), 0 - cardView.frame.size.height);
    cardView.center = startCardViewCenter;
    [self.view addSubview:cardView];
    
    [UIView animateWithDuration:.5
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                                  cardView.center = finalCardViewCenter;
                              }
                     completion:nil];
    
    
}

- (void)addCardViewWithFrame:(CGRect)cardViewFrame forCardAtIndex:(NSUInteger)index animatedEntrance:(BOOL)animated
{
    PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:cardViewFrame];
    
    [self setCardAtIndex:index forCardView:cardView];
    cardView.faceUp = NO;
    
    if (animated) {
        [self animateNewCardView:cardView withDelay:[self delayForCardIndex:index]];
    } else {
        [self.view addSubview:cardView];
    }
    
    [self addCardViewToCurrentCardViews:cardView];
    [self addTappedGestureRecongnizerToCardView:cardView];
    
}

- (void)addCardViewToCurrentCardViews:(PlayingCardView *)cardView
{
    [self.currentCardViews addObject:cardView];
}

-(NSTimeInterval)delayForCardIndex:(NSUInteger)index
{
    NSTimeInterval delay = 0.0;
    if (index > 0) {
        delay += index * 0.05;
    }
    return delay;
}

- (void)addTappedGestureRecongnizerToCardView:(PlayingCardView *)cardView
{
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCard:)];
    tapped.numberOfTapsRequired = 1;
    [cardView addGestureRecognizer:tapped];
}

- (void)setCardAtIndex:(NSUInteger)index forCardView:(PlayingCardView *)cardView
{
    Card *card = self.cards[index];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        cardView.rank = playingCard.rank;
        cardView.suit = playingCard.suit;
    }
}

- (NSUInteger)indexForGridCellAtColumn:(NSUInteger)column andRow:(NSUInteger)row
{
    return ([self.cardGrid columnCount] * row) + column;
}

- (NSUInteger)indexForCardView:(PlayingCardView *)cardView
{
    if ([self.currentCardViews containsObject:cardView]) {
        return [self.currentCardViews indexOfObject:cardView];
    } else {
        return [self.currentCardViews count];
    }
}

-(void)tappedCard:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([sender.view isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *cardView = (PlayingCardView *)sender.view;
            [self animateCardFlipForCardView:cardView];
            NSUInteger viewIndex = [self indexForCardView:cardView];
            
            if (viewIndex < [self.currentCardViews count]) {
                [self.delegate tappedCardAtIndex:viewIndex];
                [self updateCardsUI];
            }
        }
    }
}

-(void)updateCardsUI
{
    for (PlayingCardView *cardView in self.currentCardViews) {
        Card *card = self.cards[[self.currentCardViews indexOfObject:cardView]];
        if (cardView.faceUp != card.isChosen) {
            [self animateCardFlipForCardView:cardView];
        }
    }
}

-(void)animateCardFlipForCardView:(PlayingCardView *)cardView
{
    [CATransaction flush];
    [UIView transitionWithView:cardView
                      duration:.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        cardView.faceUp = !cardView.faceUp;
                    }
                    completion:nil];
    
}

@end
