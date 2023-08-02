//
//  GameCounter.swift
//  pokedex-game
//
//  Created by Bryan Condor on 1/08/23.
//

import Foundation

struct GameCounter {
    
    var score: Int = 0
    
    mutating func increment() {
        self.score += 1
    }
    
    mutating func reset() {
        self.score = 0
    }
}
