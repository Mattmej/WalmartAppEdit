//
//  ViewController.swift
//  ItemsList
//

import UIKit

class ProductListTableViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var productPage: Int {
        return productsList.count / 10
    }
    var productsList: [Product] = [Product]()
    var totalNumberOfProducts = 0
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInitialProjects()
    }
    
    // MARK: - Helper Functions
    private func fetchInitialProjects() {
        NetworkManager.shared.getProducts(page: self.productPage + 1,
                                          completion: { productsContainer in
                                            guard let productsContainer = productsContainer else { return }
                                            self.totalNumberOfProducts = productsContainer.totalProducts
                                            if let products = productsContainer.products {
                                                self.productsList = products
                                                DispatchQueue.main.async {
                                                    self.tableView.reloadData()
                                                }
                                            }
        })
    }
}

/// This extension implements the proper methods to conform to UITableViewDelegate and UITableViewDataSource
extension ProductListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "productCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ProductCell
        let product = productsList[indexPath.row]
        cell.setUpCell(with: product)
        return cell
    }
    
    /// This function was implemented so that I could load the next batch of 10 products before the user scrolls to the end of the tableview
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == productsList.count - 1 && productsList.count % 10 == 0 && productsList.count < totalNumberOfProducts {
            NetworkManager.shared.getProducts(page: self.productPage + 1,
                                              completion: { productsContainer in
                                                guard let productsContainer = productsContainer else { return }
                                                if let products = productsContainer.products {
                                                    self.productsList.append(contentsOf: products)
                                                    DispatchQueue.main.async {
                                                        self.tableView.reloadData()
                                                    }
                                                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailsSegue" {
            if let viewController = segue.destination as? ProductDetailsController {
                guard let currentRow = tableView.indexPathForSelectedRow?.row else {
                    return
                }
                viewController.product = productsList[currentRow]
            }
        }
    }
}
