//
//  SHCBoard.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "BoardCellState.h"
#import "SHCMulticastDelegate.h"


/** An 8x8 playing board. */
@interface SHCBoard : NSObject <NSCopying>

// multicasts changes in cell state. Each delegate is informed of changes in state of individual cells.
@property (readonly) SHCMulticastDelegate* boardDelegate;


// gets the state of the cell at the given location
- (BoardCellState)cellStateAtColumn:(NSInteger)column andRow:(NSInteger)row;

// sets the state of the cell at the given location
- (void)setCellState:(BoardCellState)state forColumn:(NSInteger)column andRow:(NSInteger)row;

// clears the entire board
- (void)clearBoard;

- (NSUInteger)countCellsWithState:(BoardCellState)state;

@end
