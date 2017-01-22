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
    
    
    
    /*
     Metodo para buscar as informacoes do ponto turistico
     Recebe o id do ponto desejado e realiza a busca no endpoint, retornando um objeto
     PontoTuristico com as informacoes desejadas
     */
    func loadPontoTuristico(idPontoTuristico: String, callback: @escaping(
        _ pontoTuristico: PontoTuristico?, _ error: Error?) -> ()){
        
        
        Alamofire.request("http://dev.4all.com:3003/tarefa/"+idPontoTuristico).responseJSON {response
            
            in
            
                let ponto = PontoTuristico()
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
            
                ponto.id = json["id"].string
                ponto.cidade = json["cidade"].string
                ponto.bairro = json["bairro"].string
                ponto.urlFoto = json["urlFoto"].string
                ponto.urlLogo = json["urlLogo"].string
                ponto.titulo = json["titulo"].string
                ponto.telefone = json["telefone"].string
                ponto.texto = json["texto"].string
                ponto.endereco = json["endereco"].string
                ponto.latitude = json["latitude"].double
                ponto.longitude = json["longitude"].double
                ponto.comentarios = comentarios
            
            callback(ponto, json.error)
            
            
        }
        
    }
    
}


