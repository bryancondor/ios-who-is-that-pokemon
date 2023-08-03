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
    
    var pokemonAnswer: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.pokemonManagerDelegate = self
        pokemonManager.fetchAll()
        
        pokemonLabel.text = ""
    }
    
    @IBAction func pokemonButtonPress(_ sender: UIButton) {
        let pokemonChoosedLabel = sender.title(for: .normal)!
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
            timer in
            DispatchQueue.main.async { [self] in
                pokemonLabel.text = ""
                pokemonScoreLabel.text = "Puntaje: \(gameCounter.score)"
                pokemonManager.fetchAll()
            }
        }
        
        if pokemonChoosedLabel.lowercased() != pokemonAnswer?.name.lowercased() {
            self.performSegue(withIdentifier: "pokemonResultSegue", sender: self)
            gameCounter.reset()
            return;
        }
        
        gameCounter.increment()
        
        let url = URL(string: (pokemonAnswer?.imageUrl)!)
        pokemonImageView.kf.setImage(with: url)
        
        pokemonLabel.text = "Si, es un \(pokemonAnswer?.name ?? "")"
        pokemonScoreLabel.text = "Puntaje: \(gameCounter.score)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "pokemonResultSegue" {
            return;
        }
        
        let pokemonResultViewController = segue.destination as! PokemonResultViewController
        pokemonResultViewController.pokemonImageUrl = (pokemonAnswer?.imageUrl)!
        pokemonResultViewController.pokemonAnswerName = (pokemonAnswer?.name)!
        pokemonResultViewController.totalScoreObtained = self.gameCounter.score
        
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
        pokemonAnswer = randomPokemons.pickOneRandom()
        pokemonManager.fetchPokemonDetail(for: pokemonAnswer!)
    }
    
    func didUpdateChoosePokemon(pokemon: Pokemon) {
        DispatchQueue.main.async {
            self.pokemonAnswer = pokemon
            
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
