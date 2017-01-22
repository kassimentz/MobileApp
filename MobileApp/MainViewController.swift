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

/**
 TODO
 COLOCAR COR NA BARRA DE NAVEGACAO AO INVES DA IMAGEM E ADD AS IMAGENS DE VOLTAR E DE BUSCA E DE PIN, JUNTO COM O NOME DO LOCAL (CIDADE - BAIRRO)
 **/

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate  {
    
    @IBOutlet weak var tableview: UITableView!
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height+800)
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont(name: "Roboto-Regular", size: 14)!]
        print("idescolhido:",idEscolhido!)
        self.loadData(idEscolhido: idEscolhido!)
        //print(self.pontoTuristico.texto!)
        
        self.mapView.delegate = self
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        print(annotation)
        if(annotation != nil) {
            self.mapView.addAnnotation(annotation)
        }
        
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
        
        var cidade = "";
        var bairro = "";
        if let txtCidade = self.pontoTuristico?.cidade {
            cidade = txtCidade
        }
        if let txtBairro = self.pontoTuristico?.bairro {
            bairro = txtBairro
        }
        
        self.navigationItem.title = cidade + " - " + bairro
        tableview.reloadData()
    }

    
    func loadImageFromUrl(url: String, img: UIImageView) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                img.image = image
            }
        }
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
    
    @IBAction func mostrarComentarios(_ sender: UIButton) {
        if (self.pontoTuristico?.comentarios?.count)! > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableview.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
    }
    
    // MARK: - Table functions
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ComentarioTableViewCell = tableView.dequeueReusableCell(withIdentifier: "comentarioCell", for: indexPath) as! ComentarioTableViewCell
        if let comentario = self.pontoTuristico?.comentarios?[indexPath.row] {
            loadImageFromUrl(url: (comentario.urlFoto)!, img: cell.usuarioImagem)
            cell.usuarioNome.text = comentario.nome
            cell.comentarioTitulo.text = comentario.titulo
            cell.comentario.text = comentario.comentario
            
            var image = UIImage(named: "NOTA5.png")
            var size = CGSize(width: 150.0, height: 30.0)
            
            if let nota = comentario.nota {
                switch (nota){
                case 1:
                    image = UIImage(named: "NOTA1.png")
                    size = CGSize(width: 30.0, height: 30.0)
                    image = image?.imageResize(sizeChange: size)
                
                case 2:
                    image = UIImage(named: "NOTA2.png")
                    size = CGSize(width: 60.0, height: 30.0)
                    image = image?.imageResize(sizeChange: size)
                    
                case 3:
                    image = UIImage(named: "NOTA3.png")
                    size = CGSize(width: 90.0, height: 30.0)
                    image = image?.imageResize(sizeChange: size)
                    
                case 4:
                    image = UIImage(named: "NOTA4.png")
                    size = CGSize(width: 120.0, height: 30.0)
                    image = image?.imageResize(sizeChange: size)
                    
                default:
                    image = UIImage(named: "NOTA5.png")
                    size = CGSize(width: 150.0, height: 30.0)
                    image = image?.imageResize(sizeChange: size)
                }
            }
            
            cell.comentarioNota.image = image
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.pontoTuristico?.comentarios?.count {
            return count
        } else {
            return 0
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
extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}
