//
//  ProductCell.swift
//  SamsClub
//

import UIKit

class ProductCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    // MARK: - Properties
    
    private let baseImageURL = "https://mobile-tha-server.firebaseapp.com"
    
    // MARK: - Prepare for reuse
    
    override func prepareForReuse() {
        self.imageV.image = nil
        super.prepareForReuse()
    }
    
    // MARK: - Helper functions
    
    func setUpCell(with product: Product) {
        self.name.text = product.productName
        self.rating.text = String(product.reviewRating)
        self.price.text = product.price
        self.stock.text = product.inStock ? "In stock!" : "Not in stock."
        let imageURLString = baseImageURL + product.productImage
        if let image = ImageCache.shared.getAssetImageFromCache(identifier: imageURLString) {
            self.imageV.image = image
        } else {
            do {
                if let imageURL = URL(string: imageURLString) {
                    let imageData = try Data(contentsOf: imageURL)
                    if let image = UIImage(data: imageData) {
                        ImageCache.shared.saveAssetImageToCache(identifier: imageURLString, image: image)
                        DispatchQueue.main.async {
                            self.imageV.image = image
                        }
                    }
                }
            } catch let error {
                print("Error fetching image - \(error.localizedDescription)")
                NSLog("Error fetching image - \(error.localizedDescription)")
            }
        }
    }
}
