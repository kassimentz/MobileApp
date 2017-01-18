//
//  ListaManager.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 16/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListaManager: NSObject {
    
    func loadListaMenu(callback: @escaping(
        _ stringArr:[String]?, _ error: Error?) -> ()) {
        
        Alamofire.request("http://dev.4all.com:3003/tarefa").responseJSON {response
            in
            
            var values = [String]()
            
            let json = JSON(data: response.data!)
            
            for stringInArray in json["lista"] {
                let value = stringInArray.1.stringValue
                values.append(value)
            }
            
            callback(values, json.error)
        }
    
    }
}
