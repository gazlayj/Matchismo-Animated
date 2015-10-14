//
//  ViewController.h
//  Matchismo Animated
//
//  Created by Justin Gazlay on 9/23/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grid.h"
#import "Deck.h"

@interface ViewController : UIViewController

//FOR SUBCLASSING
-(Deck *)createDeck;

@property (nonatomic) NSUInteger numberOfCardsForGameStart;

@end

