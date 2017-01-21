//
//  ComentarioTableViewCell.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 21/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit

class ComentarioTableViewCell: UITableViewCell {

    @IBOutlet weak var usuarioImagem: UIImageView!
    @IBOutlet weak var usuarioNome: UILabel!
    @IBOutlet weak var comentarioTitulo: UILabel!
    @IBOutlet weak var comentario: UILabel!
    @IBOutlet weak var comentarioNota: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
