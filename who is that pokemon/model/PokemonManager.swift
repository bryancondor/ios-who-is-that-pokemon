//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Bryan Condor on 29/07/23.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemons(pokemons: [Pokemon])
    func didFail(withError error: Error)
    func didUpdateChoosePokemon(pokemon: Pokemon)
}

struct PokemonManager {
    
    let pokemonEndpointUrl = "https://pokeapi.co/api/v2/pokemon"
    var pokemonManagerDelegate: PokemonManagerDelegate?
    
    func fetchAll() {
        guard let url = URL(string: pokemonEndpointUrl) else {
            print("error trying to get the url")
            return
        }
        
        print(url)
        
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error != nil {
                print(error!)
            }
            
            if data == nil {
                print("empty data")
            }
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(PokemonResponseDTO.self, from: data!)
                let pokemons = response.results.map{ result in Pokemon(name: result.name)}
                
                pokemonManagerDelegate?.didUpdatePokemons(pokemons: pokemons)
            } catch {
                pokemonManagerDelegate?.didFail(withError: error)
            }
            
        }
        
        task.resume()
    }
    
    func fetchPokemonDetail(for pokemon: Pokemon) {
        guard let url = URL(string: "\(pokemonEndpointUrl)/\(pokemon.name)") else {
            print("error trying to get the url")
            return
        }
        
        print(url)
        
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error != nil {
                print(error!)
            }
            
            if data == nil {
                print("empty data")
            }
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(PokemonDetailResponseDTO.self, from: data!)
                let pokemonImageUrl = response.sprites.other?.officialArtwork.frontDefault
                let pokemonPopulated = Pokemon(name: pokemon.name, imageUrl: pokemonImageUrl)
                
                pokemonManagerDelegate?.didUpdateChoosePokemon(pokemon: pokemonPopulated)
            } catch {
                pokemonManagerDelegate?.didFail(withError: error)
            }
            
        }
        
        task.resume()
    }
}
