//
//  SetCard.h
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-02-28.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSUInteger number;
+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShadings;
+ (NSUInteger)maxNumber;
@end
