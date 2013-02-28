//
//  GameResult.h
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-02-08.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults;
+ (void)resetScores;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

@end
