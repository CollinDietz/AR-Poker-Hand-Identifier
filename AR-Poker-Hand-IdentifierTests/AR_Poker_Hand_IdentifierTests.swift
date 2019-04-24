//
//  AR_Poker_Hand_IdentifierTests.swift
//  AR-Poker-Hand-IdentifierTests
//
//  Created by Collin Dietz on 1/28/19.
//  Copyright © 2019 SDLC. All rights reserved.
//

import XCTest
@testable import AR_Poker_Hand_Identifier


class AR_Poker_Hand_IdentifierTests: XCTestCase {

    var pokerHand: Hand = Hand();
    var resultHand: HandValue!;
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Testing Royal Flush
    func testRoyalFlush() {
        pokerHand.addArray(["TH", "JH", "QH", "KH", "AH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Royal Flush", "Test for Royal Flush failed.");
    }
    
    // Testing Straight Flush
    func testStraightFlush() {
        pokerHand.addArray(["6H", "7H", "8H", "9H", "TH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Straight Flush", "Test for Straight Flush failed.");
    }
    
    // Testing Four-Of-A-Kind
    func testFourOfAKind() {
        pokerHand.addArray(["7H", "7D", "7C", "7S", "9H"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Four Of A Kind", "Test for Four-Of-A-Kind failed.");
    }
    
    // Testing Full House
    func testFullHouse() {
        pokerHand.addArray(["2D", "2S", "2H", "8C", "8H"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Full House", "Test for Full House failed.");
    }
    
    // Testing Flush
    func testFlush() {
        pokerHand.addArray(["3H", "7H", "9H", "JH", "KH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Flush", "Test for Flush failed.");
    }
    
    // Testing Straight
    func testStraight() {
        pokerHand.addArray(["6H", "7C", "8H", "9D", "TS"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Straight", "Test for Straight failed.");
    }
    
    // Testing Three-Of-A-Kind
    func testThreeOfAKind() {
        pokerHand.addArray(["2D", "2S", "2H", "KC", "8H"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Three Of A Kind", "Test for Three-Of-A-Kind failed.");
    }
    
    // Testing Two Pair
    func testTwoPair() {
        pokerHand.addArray(["TD", "TS", "5H", "5C", "3H"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Two Pair", "Test for Two Pair failed.");
    }
    
    // Testing One Pair
    func testOnePair() {
        pokerHand.addArray(["7D", "7S", "5H", "6C", "3D"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "One Pair", "Test for One Pair failed.");
    }
    
    // Testing High Card
    func testHighCard() {
        pokerHand.addArray(["7D", "8S", "5H", "JC", "KH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "High Card", "Test for High Card failed.");
    }
    
    // Testing Too Many Cards
    func testTooManyCards() {
        pokerHand.addArray(["TH", "JH", "QH", "KH", "AH", "9H"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "TooMany", "Test for Too Many Cards failed.");
    }
    
    // Testing Too Little Cards
    func testTooLittleCards() {
        pokerHand.addArray(["TH", "JH", "QH", "KH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "TooLittle", "Test for Too Little Cards failed.");
    }
    
    // Testing for Duplicates
    func testDuplicates() {
        pokerHand.addArray(["TH", "JH", "QH", "KH", "KH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "Duplicate", "Test for Duplicates failed.");
    }
    
    // Testing for invalid card
    func testBadCard() {
        pokerHand.addArray(["TH", "JH", "SH", "KH", "KH"]);
        resultHand = Evaluator(pokerHand);
        XCTAssert(resultHand.rawValue == "BadCard", "Test for Bad Card failed.");
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
