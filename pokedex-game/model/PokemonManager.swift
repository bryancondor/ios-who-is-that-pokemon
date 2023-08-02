//
//  PokemonManager.swift
//  pokedex-game
//
//  Created by Bryan Condor on 29/07/23.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemons(pokemons: [Pokemon])
    func didFail(withError error: Error)
    func didUpdateChoosePokemon(pokemon: Pokemon)
}

class PokemonManager {
    
    let pokemonEndpointUrl = "https://pokeapi.co/api/v2/pokemon"
    var pokemonManagerDelegate: PokemonManagerDelegate?
    var pokemons: [Pokemon]?
    
    func fetchAll() {
        
        if(self.pokemons != nil){
            self.pokemonManagerDelegate?.didUpdatePokemons(pokemons: self.pokemons!)
            return;
        }
        
        guard let url = URL(string: "\(pokemonEndpointUrl)?limit=151&offset=0") else {
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
                
                self.pokemonManagerDelegate?.didUpdatePokemons(pokemons: pokemons)
                
                self.pokemons = pokemons
            } catch {
                self.pokemonManagerDelegate?.didFail(withError: error)
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
                
                self.pokemonManagerDelegate?.didUpdateChoosePokemon(pokemon: pokemonPopulated)
            } catch {
                self.pokemonManagerDelegate?.didFail(withError: error)
            }
            
        }
        
        task.resume()
    }
}
