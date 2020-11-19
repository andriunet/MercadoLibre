//
//  MercadoLibreTests.swift
//  MercadoLibreTests
//
//  Created by Andres Marin on 18/11/20.
//

import XCTest
@testable import MercadoLibre

class MercadoLibreTests: XCTestCase {

    //Test para probar el API que este retornando bien
    func testBusquedaAPI() {
        
        let busqueda = "iphone"
        
        guard let vURL = URL(string: "https://api.mercadolibre.com/sites/MLA/search?q=\(busqueda)") else { return }
        let expe = expectation(description: "Busqueda por nombre API")
        
        URLSession.shared.dataTask(with: vURL) { (data, response
            , error) in
                guard let data = data else { return }
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    if let result = json as? NSDictionary {
                        
                        //Comparamos que la busqueda sea igual al resultado
                        XCTAssertEqual(result["query"] as! String, busqueda)
                        
                        XCTAssertNotNil(result["results"])
                        
                        //Compara si el results tenga items.
                        if let results = result["results"] as? Array<Any> {
                            XCTAssertTrue(results.count > 0)
                            expe.fulfill()
                        }
                        
                    }
                } catch let err {
                    print("Error", err)
                }
            }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //Test que nos prueba la deserializacion del json en SearchViewController
    func testBusquedaSearchViewController() {
        
        let busqueda = "celular"
        
        let searchViewController = SearchViewController()
        let _ = searchViewController.view

        let expe = expectation(description: "Busqueda por nombre SearchViewController")
        
        searchViewController.obtenerJson(url: "https://api.mercadolibre.com/sites/MLA/search?q=\(busqueda)") { (items) in
            
            XCTAssertNotNil(items!)
            XCTAssertNotNil(items!.results)
            XCTAssertEqual(items!.query, busqueda)
            XCTAssertTrue(items!.results.count > 0)
            
            expe.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }


}
