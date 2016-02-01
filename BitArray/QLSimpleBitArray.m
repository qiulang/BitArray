//
//  QLSimpleBitArray.m
//  A simple BitArray for bitwise operation
//
//  Created by 邱 朗 on 8/20/13.
//  Copyright (c) 2013 邱 朗. Do whatever you want.
//

#import "QLSimpleBitArray.h"

@implementation QLSimpleBitArray

-(instancetype) init {
    self = [self initFromNumber:0];
    return self;
}

-(instancetype) initWithSize:(NSInteger)size {
    self = [super init];
    _size = size;
    _bsize = (size %8) == 0 ? size/8: size/8+1;
    _array = malloc(_bsize);
    [self reset];
    return self;
}

-(instancetype) initFrom:(NSInteger) min to:(NSInteger) max {
    if (max<min) {
        NSInteger tmp = min;
        min = max;
        max = tmp;
    }
    self = [self initWithSize:max];
    [self setFrom:min to:max];
    return self;
}

-(instancetype) initFromNumber:(NSInteger)number {
    self = [super init];
    _bsize = sizeof(NSInteger);
    _size = _bsize * 8;
    _array = malloc(_bsize);
    memcpy(_array, &number, _bsize);
    return self;
}

-(void) dealloc {
    free(_array);
}

#pragma mark -

-(NSUInteger) hash {
    NSInteger tmp = [self toNumber];
    if (tmp == -1) {
        //I probably should come up with better number than just -1
        return -1;
    }
    return tmp;
}

-(BOOL) isEqualToBitArray:(QLSimpleBitArray *)another {
    if (_size != another->_size) return NO;
    NSInteger result = memcmp(_array, another->_array, _bsize);
    return (result == 0);
}

-(BOOL) isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[QLSimpleBitArray class]]) {
        return NO;
    }
    
    return [self isEqualToBitArray:(QLSimpleBitArray *)object];
}

-(NSString *) description {
    NSMutableString *bitString=[NSMutableString stringWithCapacity:8*_bsize];
    for (NSInteger i=_bsize-1; i >=0; i--) {
        Byte dest = _array[i];
        NSMutableString *byteString = [NSMutableString stringWithCapacity:8];
        for (NSInteger j=7;j >=0;j--) {
            NSInteger bit = dest & (1 << j) ? 1 : 0;
            [byteString appendFormat:@"%zd",bit];
        }
        [bitString appendFormat:@"%@ ",byteString];
    }
    return bitString;
}

#pragma mark -

-(BOOL) setAs:(QLSimpleBitArray *) another {
    if (_size != another->_size) {
        return NO;
    }
    memcpy(self->_array, another->_array, another->_bsize);
    return YES;
}

-(QLSimpleBitArray*) clone {
    QLSimpleBitArray * another = [[QLSimpleBitArray alloc] initWithSize:self->_size];
    [another setAs:self];
    return another;
}

#pragma mark -

-(void) set:(NSInteger) pos {
    if (pos >= _size) return;
    NSInteger index = pos/8;
    NSInteger bit = pos%8;
     _array[index] = _array[index] | (1 << bit);
}

-(void) setFrom:(NSInteger) from to:(NSInteger) to { //fromIndex inclusive, toIndex exclusive
    if (from>to) return;
    if (from <0) from =0;
    if (to > _size) to = _size;
    
    while (from < to)
    {
        _array[from / 8] |= (1 << (from % 8));
        from++;
    }
}

-(void) reset {
    memset(_array, 0, _bsize);
}

-(void) reset:(NSInteger) pos {
    if (pos >= _size) return;
    NSInteger index = pos/8;
    NSInteger bit = pos%8;
    _array[index] = _array[index] & (~(1 << bit));
}

-(void) resetFrom:(NSInteger) from to:(NSInteger) to { //fromIndex inclusive, toIndex exclusive
    if (from>to) return;
    if (from <0) from =0;
    if (to > _size) to = _size;
    
    while (from < to)
    {
        _array[from / 8] &= ~(1 << (from % 8));
        from++;
    }
}

#pragma mark -

-(NSInteger) count {
    NSInteger count = 0, index = 0;
    while (index < _size) { //can NOT be <= as the first bit will be sign bit!!
        if (_array[index / 8] & (1 << (index % 8))) {
            count++;
        }
        index++;
    }
    return count;
}

-(BOOL) isFull {
    NSInteger bound = (_size%8==0) ? _bsize : _bsize -1;
    for (NSInteger i=0; i<bound; i++) {
        if (_array[i] != 255) return NO;
    }
    if (_size%8==0) return YES;
    NSInteger j = _size -bound * 8;
    return _array[bound] == (1<<j)-1;
}

-(BOOL) isEmpty {
    for (NSInteger i=0; i<_bsize; i++) {
        if (_array[i]!=0) return NO;
    }
    return YES;
}

-(NSInteger) toNumber {
    NSInteger number = 0;
    NSInteger long_size = sizeof(NSInteger);
    if (_bsize >long_size) {
        return -1;
    }
    memcpy(&number, _array, _bsize);
    return number;
}

#pragma mark -

-(void) AND:(QLSimpleBitArray *) another {
    if (_size != another->_size) return;
    for (int i=0; i<_bsize; i++) {
        _array[i] &= another->_array[i];
    }
}

-(void) OR:(QLSimpleBitArray *) another {
    if (_size != another->_size) return;
    for (int i=0; i<_bsize; i++) {
        _array[i] |= another->_array[i];
    }
}

-(void) XOR:(QLSimpleBitArray *) another {
    if (_size != another->_size) return;
    for (int i=0; i<_bsize; i++) {
        _array[i] ^= another->_array[i];
    }
}

-(void) NOT {
    for (int i=0; i<_bsize; i++) {
        _array[i] = ~_array[i];
    }
}

@end
