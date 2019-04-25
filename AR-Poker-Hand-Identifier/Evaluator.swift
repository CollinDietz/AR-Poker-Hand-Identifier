//
//  Evaluator.swift
//  PokerHandEvaluator
//
//  Created by Jacob Chen on 4/8/19.
//  Copyright © 2019 SDLC. All rights reserved.
//

import Foundation

// Create a rank type.
public enum Rank: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace;
}

// Create a suit type.
public enum Suit: String {
    case clubs = "C";
    case diamonds = "D";
    case hearts = "H";
    case spades = "S";
}

// Create a hand type.
public enum HandValue: String {
    case HighCard = "High Card";
    case OnePair = "One Pair";
    case TwoPair = "Two Pair";
    case ThreeOfAKind = "Three Of A Kind";
    case Straight;
    case Flush;
    case FullHouse = "Full House";
    case FourOfAKind = "Four Of A Kind";
    case StraightFlush = "Straight Flush";
    case RoyalFlush = "Royal Flush";
    case TooMany;
    case TooLittle;
    case Duplicate;
    case BadCard;
}

// Class Card that contains both a rank and suit.
public class Card {
    let rank: Int;
    let suit: String;
    let position: [Float];
    init(_ rank: Int, _ suit: String) { // Initializer
        self.rank = rank;
        self.suit = suit;
        self.position = [0, 0, 0];
    }
    
    func getLabel() -> String
    {
        
        if(rank == -1)
        {
            return "--"
        }
        var rankS:String;
        switch rank {
        case 11:
            rankS = "J";
        case 12:
            rankS = "Q";
        case 13:
            rankS = "K";
        case 14:
            rankS = "A";
        default:
            rankS = String(rank)
        }
        
        var unicodeSuit:String = ""
        if suit == "h" ||  suit == "H"{
            unicodeSuit = "♥"
        }
        else if  suit == "c" ||  suit == "C"{
            unicodeSuit = "♣"
        }
        else if  suit == "s" ||  suit == "S"{
            unicodeSuit = "♠"
        }
        else if  suit == "d" ||  suit == "D"{
            unicodeSuit = "♦"
        }
        
        
        return rankS + unicodeSuit;
    }
    
    // Function for checking if a card is valid. Returns boolean.
    func isValid() -> Bool {
        if (rank >= 1 && rank <= 14) {
            if (suit == "C" || suit == "D" || suit == "H" || suit == "S") {
                return true;
            }
        }
        return false;
    }
}

// Extension for Card. "Hashable" allows a card object to be stored as a key
// value in a dictionary by giving it a hash value. Also makes card objects
// "Equatable" - two objects can be compared to determine if they are equivalent.
extension Card: Hashable {
    public var hashValue: Int {
        return rank.hashValue ^ suit.hashValue;
    }
    
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit;
    }
}

// Class Hand that contains an array of Cards in a hand.
public class Hand {
    var cards: [Card] = [];
    
    // Function to add a Card.
    // Parameters: Card - card object to add to hand only if not in hand already
    func addCard(_ card: Card) -> Bool{
        let needToAddToList:Bool = !cards.contains(where: {$0 == card})
        if (needToAddToList) {
            cards.append(card);
        }
        
        return needToAddToList
    }
    
    func clear()
    {
        cards.removeAll();
    }
    
    func count() -> Int {
        return cards.count
    }
    
    // Function to allow creation of hand from array of strings.
    // Parameters: handArray - array of Strings designating a card
    func addArray(_ handArray: [String]) {
        for cardString in handArray {
            let temp = cardString.map(String.init);
            let rank = String(temp[0]);
            let suit = String(temp[1]);
            var rankValue: Int;
            switch rank {
                case "T":
                    rankValue = 10;
                case "J":
                    rankValue = 11;
                case "Q":
                    rankValue = 12;
                case "K":
                    rankValue = 13;
                case "A":
                    rankValue = 14;
                default:
                    rankValue = Int(rank) ?? 0;
            }
            cards.append(Card(rankValue, suit));
        }
    }
    
    // Function to sort current hand by suit.
    // "clubs" < "diamonds" < "hearts" < "spades"
    func sortBySuit() {
        cards.sort {$0.suit < $1.suit};
    }
    
    // Function to sort current hand by rank. Ace is high.
    func sortByRank() {
        cards.sort {$0.rank < $1.rank};
    }
    
    // Function to determine if hand is valid size (5 cards, no duplicates)
    // Returns boolean.
    func isValid() -> Bool {
        if (self.numCards() == 5) {
            var cardCounts: [Card: Int] = [:];
            for card in cards {
                cardCounts[card] = (cardCounts[card] ?? 0) + 1;
                if (cardCounts[card] ?? 0 > 1) {
                    return false;
                }
            }
            return true;
        }
        return false;
    }
    
    // Function to determine if cards are valid. Returns boolean.
    func checkCards() -> Bool {
        var isValid = true;
        for card in cards {
            if (!card.isValid()) {
                isValid = false;
            }
        }
        return isValid;
    }
    
    // Function to count number of cards in hand. Returns integer.
    func numCards() -> Int {
        return cards.count;
    }
    
    // Function to determine the highest card in hand.
    // Returns rank of highest card as integer.
    func highCardValue() -> Int {
        self.sortByRank();
        return cards[4].rank;
    }
    
    // Function to determine if hand is a Flush. Returns boolean.
    func isFlush() -> Bool {
        self.sortBySuit();
        if (cards[0].suit == cards[cards.endIndex - 1].suit) {
            return true;
        }
        else {
            return false;
        }
    }
    
    // Function to determine if hand is a Straight. Returns boolean.
    func isStraight() -> Bool {
        self.sortByRank();
        if (cards[4].rank == 14) {
            let highAce = cards[0].rank == 10 &&
                cards[1].rank == 11 &&
                cards[2].rank == 12 &&
                cards[3].rank == 13 ;
            let lowAce = cards[0].rank == 2 &&
                cards[1].rank == 3 &&
                cards[2].rank == 4 &&
                cards[3].rank == 5 ;
            return (highAce || lowAce);
        }
        else {
            var testRank = cards[0].rank;
            for card in cards {
                if card.rank != testRank {
                    return false;
                }
                testRank += 1;
            }
        }
        return true;
    }
    
    // Function to determine if hand is a Four-Of-A-Kind. Returns boolean.
    func isFourKind() -> Bool {
        self.sortByRank();
        let lowMatch = cards[0].rank == cards[1].rank &&
            cards[1].rank == cards[2].rank &&
            cards[2].rank == cards[3].rank ;
        let highMatch = cards[1].rank == cards[2].rank &&
            cards[2].rank == cards[3].rank &&
            cards[3].rank == cards[4].rank ;
        return (lowMatch || highMatch);
    }
    
    // Function to determine if hand is a Full House. Returns boolean.
    func isFullHouse() -> Bool {
        self.sortByRank();
        let lowThree = cards[0].rank == cards[1].rank &&
            cards[1].rank == cards[2].rank &&
            cards[3].rank == cards[4].rank ;
        let highThree = cards[0].rank == cards[1].rank &&
            cards[2].rank == cards[3].rank &&
            cards[3].rank == cards[4].rank ;
        return (lowThree || highThree);
    }
    
    // Function to determine if hand is a Three-Of-A-Kind. Returns boolean.
    func isThreeKind() -> Bool {
        if (self.isFourKind() || self.isFullHouse()) {
            return false;
        }
        self.sortByRank();
        let lowThree = cards[0].rank == cards[1].rank &&
            cards[1].rank == cards[2].rank ;
        let midThree = cards[1].rank == cards[2].rank &&
            cards[2].rank == cards[3].rank ;
        let highThree = cards[2].rank == cards[3].rank &&
            cards[3].rank == cards[4].rank ;
        return (lowThree || midThree || highThree);
    }
    
    // Function to determine if hand is a Two Pair. Returns boolean.
    func isTwoPair() -> Bool {
        if (self.isFourKind() || self.isFullHouse() || self.isThreeKind()) {
            return false;
        }
        self.sortByRank();
        let lowThird = cards[1].rank == cards[2].rank &&
            cards[3].rank == cards[4].rank ;
        let midThird = cards[0].rank == cards[1].rank &&
            cards[3].rank == cards[4].rank ;
        let highThird = cards[0].rank == cards[1].rank &&
            cards[2].rank == cards[3].rank ;
        return (lowThird || midThird || highThird);
    }
    
    // Function to determine if hand is a One Pair. Returns boolean.
    func isOnePair() -> Bool {
        if (self.isFourKind() || self.isFullHouse() || self.isThreeKind() || self.isTwoPair()) {
            return false;
        }
        self.sortByRank();
        let lowPair = cards[0].rank == cards[1].rank;
        let lowMidPair = cards[1].rank == cards[2].rank;
        let highMidPair = cards[2].rank == cards[3].rank;
        let highPair = cards[3].rank == cards[4].rank;
        return (lowPair || lowMidPair || highMidPair || highPair);
    }
}

// Evaluator function for determined the type of Hand.
// Parameters: Hand - the hand of cards to be evaluated.
public func Evaluator(_ hand: Hand) -> HandValue {
    var typeHand: HandValue;
    if (hand.isValid()) { // Check if hand is valid first.
        
        // If hand is a flush, a straight, and high card is Ace, must be a Royal Flush.
        if (hand.isFlush() && hand.isStraight() && hand.highCardValue() == 14) {
            typeHand = .RoyalFlush;
        }
            // If hand is a flush and a straight, must be a Straight Flush.
        else if (hand.isFlush() && hand.isStraight()){
            typeHand = .StraightFlush;
        }
        else if (hand.isFourKind()) {
            typeHand = .FourOfAKind;
        }
        else if (hand.isFullHouse()) {
            typeHand = .FullHouse;
        }
        else if (hand.isFlush()) {
            typeHand = .Flush;
        }
        else if (hand.isStraight()) {
            typeHand = .Straight;
        }
        else if (hand.isThreeKind()) {
            typeHand = .ThreeOfAKind;
        }
        else if (hand.isTwoPair()) {
            typeHand = .TwoPair;
        }
        else if (hand.isOnePair()) {
            typeHand = .OnePair;
        }
        else {
            typeHand = .HighCard;
        }
    }
    else { // If not valid, return type inferring reason why.
        if (hand.numCards() < 5) {
            typeHand = .TooLittle;
        }
        else if (hand.numCards() > 5) {
            typeHand = .TooMany;
        }
        else {
            if (hand.checkCards()) {
                typeHand = .Duplicate;
            }
            else {
                typeHand = .BadCard;
            }
        }
    }
    return typeHand;
}

// For testing purposes. COPY INTO PLAYGROUND TO TEST; Will not work in module.
/*
// Create a hand
var pokerHand: Hand = Hand();

// Add five cards
var card1 = Card(1, "hearts");
pokerHand.addCard(card1);
card1 = Card(1, "clubs");
pokerHand.addCard(card1);
card1 = Card(11, "hearts");
pokerHand.addCard(card1);
card1 = Card(11, "clubs");
pokerHand.addCard(card1);
card1 = Card(11, "diamonds");
pokerHand.addCard(card1);

// Run through evaluator
var typeOfHand: HandValue = Evaluator(pokerHand);

// Print result
print(typeOfHand);
*/
