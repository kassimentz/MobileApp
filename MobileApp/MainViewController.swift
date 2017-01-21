//
//  MainViewController.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 19/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var idEscolhido: String?
    var pontoTuristico = PontoTuristico()
    
    func loadData(idEscolhido: String) {
        
        let pontoTuristicoManager = PontoTuristicoManager()
        
        pontoTuristicoManager.loadPontoTuristico(idPontoTuristico: idEscolhido,
                                                 callback: { (pontoTuristico, error) in
                                                    if error == nil {
                                                        self.pontoTuristico = pontoTuristico!
                                                    }
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let image = UIImage(named: "BARRA SUPERIOR.png")
        //self.navigationItem.titleView = UIImageView(image: image)
        print("idescolhido:",idEscolhido!)
        self.loadData(idEscolhido: idEscolhido!)
        //print(self.pontoTuristico.texto!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mostrarEndereco(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: self.pontoTuristico.endereco, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func realizarLigacao(_ sender: Any) {
        print("realizar ligacao")
        let formatedNumber = self.pontoTuristico.telefone?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if let url = URL(string: "telprompt://" + formatedNumber!) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}

