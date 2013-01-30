//
//  Card.h
//  cardApp
//
//  Created by Benjamin Lavin on 2013-01-30.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;

@end
