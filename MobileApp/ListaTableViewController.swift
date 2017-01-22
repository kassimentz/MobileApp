//
//  ListaTableViewController.swift
//  MobileApp
//
//  Created by Kassiane S Mentz on 17/01/17.
//  Copyright © 2017 Kassiane S Mentz. All rights reserved.
//

import UIKit
class ListaTableViewController: UITableViewController {
    
    var listaMenu = [String]()
    
    func loadData() {
        
        let listaManager = ListaManager()
        
        listaManager.loadListaMenu {(listaMenu, error) in
            if error == nil {
                self.listaMenu = listaMenu!
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pontos Turísticos"
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        self.title = "Pontos Turísticos"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMenu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell", for: indexPath)

        let listaMenu = self.listaMenu[indexPath.row]
        
        cell.textLabel?.text = listaMenu

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.title = ""
        self.performSegue(withIdentifier: "pontoTuristico", sender: self.listaMenu[indexPath.row])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pontoTuristico" {
            let mainViewController = segue.destination as! MainViewController
            if let idEscolhido = sender as? String {
                mainViewController.idEscolhido = idEscolhido
            }
        }
    }

}
