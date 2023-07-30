//
//  PokemonApi.swift
//  who is that pokemon
//
//  Created by Bryan Condor on 29/07/23.
//

import Foundation

struct PokemonResponseDTO: Codable {
    let results: [PokemonResultDTO]
    let count: Int
}

struct PokemonResultDTO: Codable {
    let name: String
    let url: String
}
    
