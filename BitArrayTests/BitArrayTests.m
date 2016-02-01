//
//  BitArrayTests.m
//  A bitarray implementation is always a good candidate to try Unit Test
//
//  Created by 邱 朗 on 16/1/29.
//  Copyright © 2016年 邱 朗. Do whatever you want.
//

#import <XCTest/XCTest.h>
#import "BitArray.h"

@interface BitArrayTests : XCTestCase

@end

@implementation BitArrayTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testToNumber {
    QLSimpleBitArray *abits = [[QLSimpleBitArray alloc] initFrom:0 to:10];
    XCTAssertEqual([abits toNumber], (1<<10)-1,@"Should be 2^10-1");
    
    abits = [[QLSimpleBitArray alloc] initFromNumber:255];
    XCTAssertEqual([abits toNumber], 255,@"Back to its original");
    
    abits = [[QLSimpleBitArray alloc] init];
    XCTAssertTrue([abits isEmpty], @"Should be an empty block");
    abits = [[QLSimpleBitArray alloc] initFromNumber:-1];
    XCTAssertTrue([abits isFull], @"-1 Should be an full block");
    
    abits = [[QLSimpleBitArray alloc] initFromNumber:1024];
    QLSimpleBitArray *abits2 = [[QLSimpleBitArray alloc] init];
    [abits2 set:10];
    XCTAssertTrue([abits isEqual:abits2], @"Equal test for 2^10 = 1024");
}

- (void)testBitMap {
    QLSimpleBitArray *bits = [[QLSimpleBitArray alloc] initFromNumber:0xfea8];
    NSLog(@"%@:%zd: %04lx",[bits debugDescription],[bits count],(long)[bits toNumber]);
    NSString *desc = [bits debugDescription];
    desc = [desc substringFromIndex:[desc rangeOfString:@"1"].location];
    desc = [desc stringByReplacingOccurrencesOfString:@" " withString:@""];
    XCTAssertTrue([desc isEqualToString:@"1111111010101000"],@"bit value");
    XCTAssertEqual([bits count], 10, @"As 4+3+2+1");
}

- (void)testNOT {
    QLSimpleBitArray *abits = [[QLSimpleBitArray alloc] initFrom:4 to:9];
    [abits set:13];
    NSInteger a = [abits toNumber];
    [abits NOT];
    NSInteger b = [abits toNumber];
    XCTAssertEqual(a+b, (1<<16)-1, @"NOT x + −x = − 1");
    [abits reset];
    XCTAssertTrue([abits isEmpty],@"Reset means empty");
    [abits setFrom:5 to:9];
    [abits setFrom:12 to:15];
    a = [abits toNumber];
    [abits NOT];
    b = [abits toNumber];
    XCTAssertEqual(a+b, (1<<16)-1, @"Again NOT x + −x = − 1");
}

- (void)testAND {
    QLSimpleBitArray *abits = [[QLSimpleBitArray alloc] initFrom:0 to:10];
    QLSimpleBitArray *abits2 = [abits clone];
    [abits2 NOT];
    [abits AND:abits2];
    NSInteger a = [abits toNumber];
    XCTAssertTrue([abits isEmpty], @"X AND ~X = 0");
    XCTAssertEqual(a, 0,@" X AND ~X should be 0");
    
    abits = [[QLSimpleBitArray alloc] initFromNumber:123456789];
    abits2 = [abits clone];
    [abits2 AND:abits];
    XCTAssertTrue([abits isEqual:abits2], @"X AND X = X");
}

- (void)testOR {
    QLSimpleBitArray *abits = [[QLSimpleBitArray alloc] initFromNumber:0xfcab];
    QLSimpleBitArray *abits2 = [abits clone];
    [abits OR:abits2];
    XCTAssertTrue([abits isEqual:abits2], @"X OR X = X");
    [abits2 NOT];
    [abits OR:abits2];
    UInt16 a = [abits toNumber];
    XCTAssertEqual(a, (1<<16)-1, @"X OR -X = − 1");
    // a is -1 actually
    XCTAssertTrue([abits isFull],@"X OR -X = -1, all bits are set");
}


-(void) testXOR {
    QLSimpleBitArray *bits = [[QLSimpleBitArray alloc] initFromNumber:123456789];
    QLSimpleBitArray *bits2 = [bits clone];
    [bits2 XOR:bits];
    XCTAssertEqual(0, [bits2 toNumber], "XOR itself should be ZERO");
    
    QLSimpleBitArray *bits3 = [[QLSimpleBitArray alloc] initFromNumber:0];
    [bits3 XOR:bits];
    XCTAssertEqualObjects(bits3, bits,"XOR 0 should be itself");
    
    bits3 = [[QLSimpleBitArray alloc] initFromNumber:-1];
    [bits3 XOR:bits];
    [bits NOT];
    XCTAssertTrue([bits isEqual:bits3],"X XOR -1 should be ~X");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
