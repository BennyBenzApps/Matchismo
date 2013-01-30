//
//  Deck.h
//  cardApp
//
//  Created by Benjamin Lavin on 2013-01-30.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
