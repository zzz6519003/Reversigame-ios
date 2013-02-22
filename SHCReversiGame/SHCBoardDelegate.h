//
//  SHCBoardDelegate.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "BoardCellState.h"

@protocol SHCBoardDelegate <NSObject>

- (void)cellStateChanged:(BoardCellState)state forColumn:(int)column andRow:(int) row;

@end
