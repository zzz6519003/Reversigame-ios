//
//  SHCBoard.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoard.h"
#import "SHCBoardDelegate.h"


@implementation SHCBoard {
    NSUInteger _board[8][8];
}


- (id)init {
    if (self = [super init]) {
        [self clearBoard];
    }
    return self;
}

- (BoardCellState)cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row
{
    [self checkBoundsForColumn:column andRow:row];

    return _board[column][row];
}

- (void)setCellState:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row
{
    [self checkBoundsForColumn:column andRow:row];

    _board[column][row] = state;
}

- (void)checkBoundsForColumn:(NSInteger)column andRow:(NSInteger)row {
    if (column < 0 || column > 7 || row < 0 || row > 7) {
        [NSException raise:NSRangeException format:@"row or column out of bounds"];
    }
}

- (void)clearBoard
{
    memset(_board, 0, sizeof(NSUInteger) * 8 * 8);
    
}


@end
