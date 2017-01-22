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
import Cosmos

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
    
    
    /*
     Utiliza a classe PontoTuristicoManager para buscar o ponto turistico selecionado.
     Devolve um Objeto PontoTuristico
     */

    func loadPontosTuristicos(idEscolhido: String) {
        
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
        self.loadPontosTuristicos(idEscolhido: idEscolhido!)
        configScroll()
        configStatusBar()
        setNavBarConfiguration()
        
        print("idescolhido:",idEscolhido!)
        
        self.mapView.delegate = self
        
    }
    /*
     Configura o scroll da tela
     */
    func configScroll() {
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height+800)
    }
    
    //Troca a cor da status bar
    func configStatusBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black;
    }
    
    //Seta as configuracoes da barra de navegacao, como cor e imagem
    func setNavBarConfiguration() {
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backImage = UIImage(named: "left-arrow.png")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Cria a annotation do mapa, configurando com uma informacao de titulo e com o zoom adequado no mapa
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
    
    //Configura o estilo da annotation
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
    
    // Após o final da renderizacao do mapa, adiciona a annotation e busca os dados do ponto turistico
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {

        addMapAnnotation()

        if(annotation != nil) {
            self.mapView.addAnnotation(annotation)
        }
        if let ponto = pontoTuristico {
            fillData(ponto: ponto)
        }
        
        tableview.reloadData()
    }
    
    //Preenche os dados do ponto turistico na tela
    func fillData(ponto: PontoTuristico) {
        
        if let urlFoto = ponto.urlFoto {
            loadImageFromUrl(url: urlFoto, img: foto)
        }
        
        if let urlLogo = ponto.urlLogo {
            loadImageFromUrl(url: urlLogo, img: logo)
        }
        
        if let txtTitulo = ponto.titulo {
            titulo.text = txtTitulo
        }
        if let txtTexto = ponto.texto {
            texto.text = txtTexto
        }
        if let txtEndereco = ponto.endereco {
            enderecoMapa.text = txtEndereco
        }
        
        var cidade = "";
        var bairro = "";
        if let txtCidade = ponto.cidade {
            cidade = txtCidade
        }
        if let txtBairro = ponto.bairro {
            bairro = txtBairro
        }
        
        setTitleBarConfiguration(title: cidade + " - " + bairro)
    }
    
    //Configura o titulo da navigation bar, setando a imagem e o texto
    func setTitleBarConfiguration(title: String) {
        let navView = UIView()
        
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        let fontSize = CGFloat(12.0)
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        let image = UIImageView()
        image.image = UIImage(named: "placeholder-2.png")
        let imageAspect = image.image!.size.width/image.image!.size.height
        image.frame = CGRect(x: label.frame.origin.x - label.frame.size.height+20 * imageAspect,
                             y: label.frame.origin.y,
                             width: label.frame.size.height * imageAspect,
                             height: label.frame.size.height)
        
        image.contentMode = UIViewContentMode.scaleAspectFit
        navView.addSubview(label)
        navView.addSubview(image)
        self.navigationItem.titleView = navView
        let searchImage = UIImage(named: "search.png")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchImage, style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        navView.sizeToFit()
    }

    //Dada uma URL, converte em imagem e seta no componente
    func loadImageFromUrl(url: String, img: UIImageView) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                img.image = image
            }
        }
    }
    

    //Mostra o endereco em um alert
    @IBAction func mostrarEndereco(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: pontoTuristico?.endereco, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Realiza uma ligacao. Pergunta ao usuario se ele deseja que a ligacao seja efetuada
    @IBAction func realizarLigacao(_ sender: Any) {
        
        if let telefone = self.pontoTuristico?.telefone {
            
            let formatedNumber = telefone.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            
            if let url = URL(string: "telprompt://" + formatedNumber) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        
        }
        
    }
    
    //Leva o focus para os comentarios, somente se existir comentarios na tabela
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
            
            if let nota = comentario.nota {
                switch (nota){
                case 1: cell.cosmos.rating = 1
                case 2: cell.cosmos.rating = 2
                case 3: cell.cosmos.rating = 3
                case 4: cell.cosmos.rating = 4
                default: cell.cosmos.rating = 5
                    
                }
            }
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

}

