import Foundation
import UIKit

class CountryTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    
    @IBOutlet weak var capitalLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var populationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        capitalLbl.text = ""
        currencyLbl.text = ""
        populationLbl.text = ""
        countryNameLbl.text = ""
        flagImageView.image = nil
        
    }
    
    func setupCell(country: Country) {
        capitalLbl.text = country.capital
        currencyLbl.text = country.currency
        populationLbl.text = String(country.population ?? 0)
        countryNameLbl.text = country.name
        flagImageView.image = nil
        ImageDownloader.downloadImage(from: country.media?.flag ?? "") { [weak self] (result) in
            switch result {
            case .success(let image):
                self?.flagImageView?.image = image
            case .failure(let error):
                self?.flagImageView?.image = UIImage()
            }
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


