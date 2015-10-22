//
//  CardsViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/1/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "CardsViewController.h"
#import "PlayingCard.h"
#import "Grid.h"



@interface CardsViewController ()

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
}

-(void)initCardViews
{
    [self createCardGrid];
    [self populateCardGrid];
}


-(void)updateUI
{
    [self createCardGrid];
    [self updateCardViewFrames];
}

-(void)updateCardViewFrames
{
    if (self.cardGrid.inputsAreValid) {
        for (CardView *cardView in self.currentCardViews) {
            NSUInteger viewIndex = [self indexForCardView:cardView];
            CGRect newCardFrame = [self.cardGrid frameOfCellAtRow:[self rowForCardIndex:viewIndex] inColumn:[self columnForCardIndex:viewIndex]];
            [cardView setFrame:newCardFrame];
        }
    } else {
        NSLog(@"Grid not created! inputs invalid");
    }
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


- (NSUInteger)indexForCard:(Card *)card
{
    return [self.cards indexOfObject:card];
}

- (NSUInteger)rowForCardIndex:(NSUInteger)index
{
    return index / self.cardGrid.columnCount;
}

- (NSUInteger)columnForCardIndex:(NSUInteger)index
{
    return index % self.cardGrid.columnCount;
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
    
    [self informDelegateOfRemoval];
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
                         [self.currentCardViews removeObject:cardView];
                         [self informDelegateOfRemoval];
                     }];

}

-(void)informDelegateOfRemoval
{
    if ([self.currentCardViews count] == 0) {
        [self.delegate allCardViewsRemoved];
    }
}

- (void)animateNewCardView:(CardView *)cardView withDelay:(NSTimeInterval)delay
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
    CardView *cardView = [self newCardViewWithFrame:cardViewFrame];
    
    [self setCardAtIndex:index forCardView:cardView];
    
    if (animated) {
        [self animateNewCardView:cardView withDelay:[self delayForCardIndex:index]];
    } else {
        [self.view addSubview:cardView];
    }
    
    [self addCardViewToCurrentCardViews:cardView];
    [self addTappedGestureRecongnizerToCardView:cardView];
    
}

-(CardView *)newCardViewWithFrame:(CGRect)frame
{
    return [[CardView alloc] initWithFrame:frame];
}

- (void)addCardViewToCurrentCardViews:(CardView *)cardView
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

- (void)addTappedGestureRecongnizerToCardView:(CardView *)cardView
{
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCard:)];
    tapped.numberOfTapsRequired = 1;
    [cardView addGestureRecognizer:tapped];
}

- (void)setCardAtIndex:(NSUInteger)index forCardView:(CardView *)cardView
{

}

- (NSUInteger)indexForGridCellAtColumn:(NSUInteger)column andRow:(NSUInteger)row
{
    return ([self.cardGrid columnCount] * row) + column;
}

- (NSUInteger)indexForCardView:(CardView *)cardView
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
        if ([sender.view isKindOfClass:[CardView class]]) {
            CardView *cardView = (CardView *)sender.view;
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

}



@end
