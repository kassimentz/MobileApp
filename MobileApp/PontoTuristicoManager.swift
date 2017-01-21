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
            
            let json = JSON(data: response.data!)
            print(" json",json)
            
            for(_, subJSON): (String, JSON) in json {

                let ponto = PontoTuristico()
                
                ponto.id = subJSON["id"].string
                ponto.cidade = subJSON["cidade"].string
                ponto.urlFoto = subJSON["urlFoto"].string
                ponto.urlLogo = subJSON["urlLogo"].string
                ponto.titulo = subJSON["titulo"].string
                ponto.telefone = subJSON["telefone"].string
                ponto.texto = subJSON["texto"].string
                ponto.endereco = subJSON["endereco"].string
                ponto.latitude = subJSON["latitude"].double
                ponto.longitude = subJSON["longitude"].double
                ponto.comentarios = self.comentarios
                
                print(ponto)
                
                callback(ponto, json.error)
            }
            
        }
        
    }
    
}

