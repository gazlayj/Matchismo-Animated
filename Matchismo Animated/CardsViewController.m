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
    NSLog(@"number of cards: %lu", (unsigned long)[self.cards count]);
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

- (void)populateCardGrid
{
    if (self.cardGrid.inputsAreValid) {
        for (NSUInteger row = 0; row < self.cardGrid.rowCount; row++) {
            for (NSUInteger column = 0; column < self.cardGrid.columnCount; column++) {
                CGRect cardFrame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
                NSUInteger indexForCell = [self indexForGridCellAtColumn:column andRow:row];
                if (indexForCell < [self.cards count]) {
                    [self addCardViewWithFrame:cardFrame forCardAtIndex:indexForCell];
                }
            }
        }
    } else {
        NSLog(@"Grid not created! inputs invalid");
    }
}

- (void)addCardViewWithFrame:(CGRect)cardViewFrame forCardAtIndex:(NSUInteger)index
{
    PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:cardViewFrame];
    
    [self setCardAtIndex:index forCardView:cardView];
    cardView.faceUp = NO;
    [self.view addSubview:cardView];
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

-(void)tappedCard:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([sender.view ifKindOfClass:[PlayingCardView class]])
        sender.view.faceUp = !sender.view.faceUp;
        
        //check if face up, if so let the parent view controller know the card was selected
    }
}


@end
