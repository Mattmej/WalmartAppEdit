//
//  ProductDetailsController.swift
//  SamsClub
//

import UIKit

class ProductDetailsController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    
    var product: Product?
    let baseImageURL = "https://mobile-tha-server.firebaseapp.com"
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    // MARK: - Helper Functions
    
    func setUpView() {
        guard let product = product else { return }
        nameLabel.text = product.productName
        ratingLabel.text = "\(product.reviewRating) / 5"
        priceLabel.text = product.price
        availabilityLabel.text = product.inStock ? "Availability: In Stock" : "Availability: Out of Stock"
        descriptionTextView.attributedText = convertToAttributedString(htmlString: product.longDescription)
        let imageURLString = baseImageURL + product.productImage
        if let image = ImageCache.shared.getAssetImageFromCache(identifier: imageURLString) {
            imageV.image = image
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
    
    /**
     This function is used to take the string, including html tags, that contains the description, and turn it into an NSAttributedSring.
     - Parameter htmlString: This a string containing html tags.
     - Returns: An optional NSAttributedString
    */
    private func convertToAttributedString(htmlString: String) -> NSAttributedString? {
        guard let data = htmlString.data(using: .utf8) else { return nil }
        do{
            let attributed = try NSMutableAttributedString(data: data,
                                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                                     .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            attributed.addAttributes([.font : UIFont.systemFont(ofSize: 17.0)],
                                     range: NSMakeRange(0, attributed.length))
            return attributed
        }catch{
            return NSAttributedString()
        }
    }
}
