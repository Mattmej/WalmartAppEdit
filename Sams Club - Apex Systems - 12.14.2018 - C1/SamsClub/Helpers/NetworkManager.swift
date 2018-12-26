//
//  NetworkManager.swift
//  ItemsList
//

import Foundation

class NetworkManager {
    
    // MARK: - Singleton
    
    static let shared = NetworkManager()
    
    // MARK: - Properties
    
    private var numberOfProductsToRequestPerPage = 10
//    private let baseURL = "https://mobile-tha-server.firebaseapp.com/walmartproducts/"
    let baseURL = "https://mobile-tha-server.firebaseapp.com/"
    private let session = URLSession.shared
    
    private init() { }
    
    /**
     This function fetches products from the server.
     
    - Parameter page: This the page number that is being requested
    - Parameter productCount: This is the number of products to request
    - Parameter completion: A completion handler to do some work after fetching the products, It completes with an optional ProductContainer
    */
    func getProducts(page: Int,
                     productCount: Int = NetworkManager.shared.numberOfProductsToRequestPerPage,
                     completion: @escaping (ProductContainer?)->()) {
        let tempURL = baseURL + "walmartproducts/" + "\(page)/\(productCount)"
        if let url = URL(string: tempURL) {
            let request = URLRequest(url: url)
            session.dataTask(with: request) {
                (data,response,error) in
                
                if let error = error {
                    print("Data task error - \(error)")
                    completion(nil)
                }
                
                if let response = response as? HTTPURLResponse {
                    if (200 ..< 300) ~= response.statusCode {
                        if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                let productList = try decoder.decode(ProductContainer.self, from: data)
                                
                                completion(productList)
                            } catch let error {
                                print("Error fetching product list data - \(error)")
                                completion(nil)
                            }
                        }
                    }
                }
                }.resume()
        }
    }
}
