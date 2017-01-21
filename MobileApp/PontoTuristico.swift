//
//  PontoTuristico.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 16/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit

class PontoTuristico: NSObject {
    var id : String?
    var cidade: String?
    var bairro: String?
    var urlFoto: String?
    var urlLogo: String?
    var titulo: String?
    var telefone: String?
    var texto: String?
    var endereco: String?
    var latitude: Double?
    var longitude: Double?
    var comentarios : [Comentario]?
    
    override init() {
        
    }
}
