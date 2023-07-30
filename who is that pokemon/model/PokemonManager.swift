//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Bryan Condor on 29/07/23.
//

import Foundation

struct PokemonManager {
    
    let pokemonEndpointUrl = "https://pokeapi.co/api/v2/pokemon"
    
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
                print(response)
            } catch {
                print("error \(error)")
            }

        }
        
        task.resume()
    }
}
