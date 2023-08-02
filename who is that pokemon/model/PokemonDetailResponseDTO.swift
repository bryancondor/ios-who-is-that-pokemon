//
//  PokemonDetailResponseDTO.swift
//  who is that pokemon
//
//  Created by Bryan Condor on 30/07/23.
//

import Foundation

struct PokemonDetailResponseDTO: Codable {
    let sprites: Sprite
}

struct Sprite: Codable {
    let other: Other?
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault, frontShiny: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
