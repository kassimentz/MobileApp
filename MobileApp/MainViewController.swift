//
//  MainViewController.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 19/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage
import Alamofire

class MainViewController: UIViewController, MKMapViewDelegate  {
    
   
    @IBOutlet weak var mapView: MKMapView!
    
    var idEscolhido: String?
    var pontoTuristico : PontoTuristico?
    var annotation: MKPointAnnotation!
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var enderecoMapa: UILabel!
    
    
    
    func loadData(idEscolhido: String) {
        
        let pontoTuristicoManager = PontoTuristicoManager()
        
        pontoTuristicoManager.loadPontoTuristico(idPontoTuristico: idEscolhido,
                                                 callback: { (pontoTuristico, error) in
                                                    if error == nil {
                                                        self.pontoTuristico = pontoTuristico!
                                                    }
        })

    }
    
    func addMapAnnotation() {
        if let pontoTuristico = self.pontoTuristico {
            let latDelta: CLLocationDegrees = 0.001
            let lonDelta: CLLocationDegrees = 0.001
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let location = CLLocationCoordinate2D(latitude: pontoTuristico.latitude! , longitude: pontoTuristico.longitude!)
            
            annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            if let titulo = pontoTuristico.titulo {
                annotation.title = "Local: \(titulo)"
            } else {
                annotation.title = "Local -"
            }
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationview.pinTintColor = .purple
            pinAnnotationview.isDraggable = true
            pinAnnotationview.canShowCallout = true
            pinAnnotationview.animatesDrop = true
            
            return pinAnnotationview
        }
        return nil
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        addMapAnnotation()
        self.mapView.addAnnotation(annotation)
        loadImageFromUrl(url: (pontoTuristico?.urlFoto)!, img: foto)
        loadImageFromUrl(url: (pontoTuristico?.urlLogo)!, img: logo)
        if let txtTitulo = self.pontoTuristico?.titulo {
           titulo.text = txtTitulo
        }
        if let txtTexto = self.pontoTuristico?.texto {
            texto.text = txtTexto
        }
        if let txtEndereco = self.pontoTuristico?.endereco {
            enderecoMapa.text = txtEndereco
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let image = UIImage(named: "BARRA SUPERIOR.png")
        //self.navigationItem.titleView = UIImageView(image: image)
        print("idescolhido:",idEscolhido!)
        self.loadData(idEscolhido: idEscolhido!)
        //print(self.pontoTuristico.texto!)
        
        self.mapView.delegate = self
        
        
    }

    
    
    func loadImageFromUrl(url: String, img: UIImageView) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                img.image = image
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mostrarEndereco(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: pontoTuristico?.endereco, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func realizarLigacao(_ sender: Any) {
        print("realizar ligacao")
        let formatedNumber = self.pontoTuristico?.telefone?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
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

