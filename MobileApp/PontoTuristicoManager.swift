//
//  PontoTuristicoManager.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 21/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PontoTuristicoManager: NSObject {
    
    var comentarios = [Comentario]()
    
    /*
     Metodo para buscar os comentarios referente ao ponto turistico
     Recebe o id do ponto turistico e retorna um array de comentarios
     Utiliza a classe comentarios manager, que faz a busca diretamente no endpoint
     */
    func loadComentarios(idPontoTuristico: String) {
        let comentariosManager = ComentariosManager()
        comentariosManager.loadComentarios(idPontoTuristico: idPontoTuristico,
                                           callback: { (comentarios, error) in
                                            if error == nil {
                                                self.comentarios = comentarios!
                                            }
        })
    }
    
    /*
     Metodo para buscar as informacoes do ponto turistico
     Recebe o id do ponto desejado e realiza a busca no endpoint, retornando um objeto
     PontoTuristico com as informacoes desejadas
     */
    func loadPontoTuristico(idPontoTuristico: String, callback: @escaping(
        _ pontoTuristico: PontoTuristico?, _ error: Error?) -> ()){
        
        loadComentarios(idPontoTuristico: idPontoTuristico)
        
        
        Alamofire.request("http://dev.4all.com:3003/tarefa/"+idPontoTuristico).responseJSON {response
            
            in
            
            let ponto = PontoTuristico()
            
            let json = JSON(data: response.data!)
            
                ponto.id = json["id"].string
                ponto.cidade = json["cidade"].string
                ponto.urlFoto = json["urlFoto"].string
                ponto.urlLogo = json["urlLogo"].string
                ponto.titulo = json["titulo"].string
                ponto.telefone = json["telefone"].string
                ponto.texto = json["texto"].string
                ponto.endereco = json["endereco"].string
                ponto.latitude = json["latitude"].double
                ponto.longitude = json["longitude"].double
                ponto.comentarios = self.comentarios
                
                callback(ponto, json.error)
            
            
        }
        
    }
    
}


