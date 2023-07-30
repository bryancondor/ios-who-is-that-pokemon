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
                
//                func getResult(result: PokemonResultDTO) -> Pokemon {
//                     Pokemon(name: result.name, imageUrl: "image URL")
//                }

//                let pokemons = response.results.map({
//                    (result: PokemonResultDTO) -> Pokemon in Pokemon(name: result.name, imageUrl: "image URL")
//                })
                
//                let pokemons = response.results.map({
//                    result in Pokemon(name: result.name, imageUrl: "image URL")
//                })
                
//                let pokemons = response.results.map({
//                    Pokemon(name: $0.name, imageUrl: "image URL")
//                })
                                
                let pokemons = response.results.map{ result in
                    Pokemon(name: result.name, imageUrl: "image URL")
                }
                
                print(pokemons)
            } catch {
                print("error \(error)")
            }

        }
        
        task.resume()
    }
    
    func exampleTrailingClosure() {
        
        func myMethod(name: String, nameLengthCounter: (String) -> Int){
            print("Hello, \(name) your name have \(nameLengthCounter(name)) letters")
        }
        
        func anotherMethod(nameLengthCounter: (String) -> Int){
            print("Hello, Condor your lastname have \(nameLengthCounter("Condor")) letters")
        }
        
        myMethod(name: "Bryan", nameLengthCounter: { name in name.count})
        
        myMethod(name: "Alexander") { name in
            name.count
        }
        
        myMethod(name: "Mirella", nameLengthCounter: { $0.count })
        
        anotherMethod { lastname in
            lastname.count
        }
        
        anotherMethod() { lastname in
            lastname.count
        }
        
    }
}
