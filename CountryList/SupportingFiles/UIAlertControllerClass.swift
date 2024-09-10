
import Foundation
import UIKit

class UIAlertControllerClass {
    static func showAlert(title: String, message: String, inViewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        inViewController.present(alertController, animated: true, completion: nil)
    }
}
