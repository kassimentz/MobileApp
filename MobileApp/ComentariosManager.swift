//
//  ComentariosManager.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 21/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ComentariosManager: NSObject {
    
    /*
     Metodo para buscar as informacoes do comentário referente ao ponto turistico
     Recebe o id do ponto desejado e realiza a busca no endpoint, retornando um objeto com um array de objetos de Comentarios
     */

    func loadComentarios(idPontoTuristico: String, callback: @escaping(
        _ comentarios: [Comentario]?, _ error: Error?) -> ()) {
    
        Alamofire.request("http://dev.4all.com:3003/tarefa/"+idPontoTuristico).responseJSON {response
            
            in
            
            var comentarios = [Comentario]()
            
            let json = JSON(data: response.data!)
            
            for(_, subJSON): (String, JSON) in json["comentarios"] {
                let comentario = Comentario(urlFoto: subJSON["urlFoto"].string,
                                            nome: subJSON["nome"].string,
                                            nota: subJSON["nota"].int,
                                            titulo: subJSON["titulo"].string,
                                            comentario: subJSON["comentario"].string)
                
                comentarios.append(comentario)
            }
            
            callback(comentarios, json.error)
        }
    }
}
