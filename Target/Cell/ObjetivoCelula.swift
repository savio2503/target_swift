//
//  ObjetivoCelula.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import UIKit

class ObjetivoCelula: UITableViewCell {
    
    
    @IBOutlet weak var tituloObjetivo: UILabel!
    @IBOutlet weak var valorAtual: UILabel!
    @IBOutlet weak var valorFinal: UILabel!
    @IBOutlet weak var porcetagemTexto: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
