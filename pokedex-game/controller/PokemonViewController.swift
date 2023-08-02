//
//  ViewController.swift
//  pokedex-game
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var pokemonScoreLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet var pokemonButtons: [UIButton]!
    
    lazy var pokemonManager = PokemonManager()
    lazy var gameCounter = GameCounter()
    
    var randomPokemons: [Pokemon] = [] {
        didSet{
            for (index, pokemonButton) in pokemonButtons.enumerated() {
                DispatchQueue.main.async {
                    pokemonButton.setTitle(self.randomPokemons[index].name, for: .normal)
                }
            }
        }
    }
    
    var pokemonChoosed: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.pokemonManagerDelegate = self
        pokemonManager.fetchAll()
        
        pokemonLabel.text = ""
    }
    
    @IBAction func pokemonButtonPress(_ sender: UIButton) {
        let pokemonButtonLabel = sender.title(for: .normal)!
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
            timer in
            DispatchQueue.main.async { [self] in
                pokemonLabel.text = ""
                pokemonScoreLabel.text = "Puntaje: \(gameCounter.score)"
                pokemonManager.fetchAll()
            }
        }
        
        if pokemonButtonLabel.lowercased() != pokemonChoosed?.name.lowercased() {
            gameCounter.reset()
            return;
        }
            
        gameCounter.increment()
        
        let url = URL(string: (pokemonChoosed?.imageUrl)!)
        pokemonImageView.kf.setImage(with: url)
        
        pokemonLabel.text = "Si, es un \(pokemonChoosed?.name ?? "")"
        pokemonScoreLabel.text = "Puntaje: \(gameCounter.score)"
    }
}

extension Collection {
    func choose(_ size: Int) -> Array<Element> {
        return Array(shuffled().prefix(size))
    }
    
    func pickOneRandom() -> Element {
        return shuffled().prefix(1).first!;
    }
}

extension PokemonViewController: PokemonManagerDelegate{
    func didUpdatePokemons(pokemons: [Pokemon]) {
        randomPokemons = pokemons.choose(4)
        pokemonChoosed = randomPokemons.pickOneRandom()
        pokemonManager.fetchPokemonDetail(for: pokemonChoosed!)
    }
    
    func didUpdateChoosePokemon(pokemon: Pokemon) {
        print("pokemon detail \(pokemon)")
        
        DispatchQueue.main.async {
            self.pokemonChoosed = pokemon
            
            let url = URL(string: pokemon.imageUrl!)
            self.pokemonImageView.kf.setImage(
                with: url,
                options: [
                    .processor(ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0))
                ]
            )
        }
    }
    
    func didFail(withError error: Error) {
        print(error)
    }
}
