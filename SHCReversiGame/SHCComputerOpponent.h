//
//  SHCComputerOpponent.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/26/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCReversiBoardDelegate.h"
#import "SHCReversiBoard.h"


@interface SHCComputerOpponent : NSObject<SHCReversiBoardDelegate>

- (id)initWithBoard:(SHCReversiBoard *)board andColor:(BoardCellState)computerColor maxDepth:(NSInteger)depth;
// Looking ahead to the very end of the game will take a lot of processing time, as there are many, many possible game states to analyze. Therefore, the depth argument will be used to specify how many steps to evaluate when looking for the optimum position.

;

@end
