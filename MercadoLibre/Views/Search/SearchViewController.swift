//
//  SearchViewController.swift
//  MercadoLibre
//
//  Created by Andres Marin on 17/11/20.
//

import UIKit
import SDWebImage
import Alamofire

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
        
    var itemsSearch: ItemsSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Funciones
    
    public func buscarItems(busqueda: String) {

        //Hacemos Encoding agregando los %20 al texto para la busqueda atra vez del URL
        if let search = busqueda.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            searchBar.cargando = true

            obtenerJson(url: "\(Endpoint.searchItems)\(search)") { (itemsSearch) in

                if let items = itemsSearch {
                    self.itemsSearch = items
                    self.tableView.reloadData()
                    self.searchBar.cargando = false
                }
                
            }
        }
        
    }
    
    func obtenerJson(url: String, callback: @escaping (_ itemsSearch: ItemsSearch?) -> ()) {
                
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseString { response in

            guard let data = response.data else {
                callback(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(ItemsSearch.self, from: data)
                self.tableView.reloadData()
                
                callback(jsonResult)
                
            } catch let error {
                print(error)
                callback(nil)
            }
        }
        
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let items = self.itemsSearch {
            
            if items.results.count == 0 {
                self.tableView.setMensajeVacio()
            } else {
                self.tableView.restaurar()
            }
            return items.results.count

        } else {
            self.tableView.setMensajeVacio()
            return 0
        }
    }

      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
          
        if let items = self.itemsSearch {

            cell.lblItem.text = items.results[indexPath.row].title
            
            cell.imageItem.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageItem.sd_setImage(with: URL(string: items.results[indexPath.row].thumbnail), placeholderImage: UIImage(named: "placeholder"), options: [.progressiveLoad] )
            
        }
          
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let items = self.itemsSearch {
            performSegue(withIdentifier: "detailSegue", sender: items.results[indexPath.row])
        }
    }
    
    //MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let search = searchBar.text {
            buscarItems(busqueda: search)
        }
    }
    
    //MARK: - Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            
            let detailViewController = segue.destination as! DetailViewController
            
            //Enviamos el item seleccionado
            if let result = sender as? Results {
                detailViewController.results = result
            }
        }
    }
    
}
