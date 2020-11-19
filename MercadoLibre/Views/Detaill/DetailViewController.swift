//
//  DetailViewController.swift
//  MercadoLibre
//
//  Created by Andres Marin on 17/11/20.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var imagenItem: UIImageView!
    
    var results: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let result = results {
            lblTitle.text = result.title
            lblPrice.text = "Precio: \(result.price.formatoMoneda())"
            lblCondition.text = "Estado: \(result.condition)"
            
            imagenItem.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imagenItem.sd_setImage(with: URL(string: result.thumbnail), placeholderImage: UIImage(named: "placeholder"), options: [.progressiveLoad] )
        }
    }
    
}
