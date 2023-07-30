//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    lazy var pokemonManager = PokemonManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonManager.fetchAll()
    }
    
}
