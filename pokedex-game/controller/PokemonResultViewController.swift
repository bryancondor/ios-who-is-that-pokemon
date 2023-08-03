//
//  PokemonResultViewController.swift
//  pokedex-game
//
//  Created by Bryan Condor on 2/08/23.
//

import UIKit
import Kingfisher

class PokemonResultViewController: UIViewController {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var pokemonScoreLabel: UILabel!
    
    var pokemonAnswerName = ""
    var pokemonImageUrl = ""
    var totalScoreObtained = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonImageView.kf.setImage(with: URL(string: pokemonImageUrl))
        pokemonLabel.text = "No, era \(pokemonAnswerName)"
        pokemonScoreLabel.text = "Puntaje máximo obtenido: \(totalScoreObtained)"
        
    }
    
    @IBAction func pressPlayAgain(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
