//
//  QLSimpleBitArray.h
//  A simple BitArray for bitwise operation
//
//  Created by 邱 朗 on 8/20/13.
//  Copyright (c) 2013 邱 朗. Do whatever you want.
//

#import <Foundation/Foundation.h>

@interface QLSimpleBitArray : NSObject {
    Byte *_array;  // the bits for the array
    NSInteger   _bsize;  // the size of the byte array
    NSInteger   _size;   // the number of bits of space actually in use
}

-(instancetype) initWithSize:(NSInteger)size NS_DESIGNATED_INITIALIZER;
-(instancetype) initFromNumber:(NSInteger)number NS_DESIGNATED_INITIALIZER;
-(instancetype) initFrom:(NSInteger) min to:(NSInteger) max; //min inclusive, max exclusive
-(instancetype) init;

-(void) set:(NSInteger) pos;
-(void) setFrom:(NSInteger) from to:(NSInteger) to;  //fromIndex inclusive, toIndex exclusive
-(void) reset;
-(void) reset:(NSInteger) pos;
-(void) resetFrom:(NSInteger) from to:(NSInteger) to; //fromIndex inclusive, toIndex exclusive

-(BOOL) isFull;
-(BOOL) isEmpty;
-(NSInteger) count;
-(NSInteger) toNumber;

-(BOOL)isEqualToBitArray:(QLSimpleBitArray *)another;
-(BOOL) setAs:(QLSimpleBitArray *) another;
-(QLSimpleBitArray*) clone;

-(void) AND:(QLSimpleBitArray *) another;
-(void) XOR:(QLSimpleBitArray *) another;
-(void) OR:(QLSimpleBitArray *) another;
-(void) NOT;

@end
