//
//  CardsViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/1/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "CardsViewController.h"

@interface CardsViewController ()
@property (strong, nonatomic) NSArray *cards;

@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithCards:(NSArray *)cards
{
    self = [super init];
    
    if (self) {
        self.cards = cards;
    }
    
    return self;
}

- (void)replaceCards:(NSArray *)currentCards withNewCards:(NSArray *)newCards
{
    //width*column+row will give the cards[index]
}

@end
