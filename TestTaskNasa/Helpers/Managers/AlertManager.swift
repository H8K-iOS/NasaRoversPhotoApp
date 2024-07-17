import UIKit

enum AlertType {
    case noData
    case saveFilter(completion: () -> Void)
    case applyFilter(useHandler: () -> Void, deleteHandler: () -> Void)
}

final class AlertManager {
    
    static func showAlert(on vc: UIViewController, ofType type: AlertType) {
        let alert: UIAlertController
        
        switch type {
        case .noData:
            alert = UIAlertController(title: "No Data", message: "No data available for the selected filters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
        case .saveFilter(let completion):
            alert = UIAlertController(title: "Save Filters", message: nil, preferredStyle: .alert)
            let alertConfirm = UIAlertAction(title: "Save", style: .default) { _ in
                completion()
            }
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(alertConfirm)
            alert.addAction(alertCancel)
            
        case .applyFilter(let useHandler, let deleteHandler):
            alert = UIAlertController(title: "Menu Filter", message: nil, preferredStyle: .actionSheet)
            let alertApply = UIAlertAction(title: "Use", style: .default) { _ in
                useHandler()
            }
            let alertDelete = UIAlertAction(title: "Delete", style: .destructive) { _ in
                deleteHandler()
            }
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(alertApply)
            alert.addAction(alertDelete)
            alert.addAction(alertCancel)
        }
        
        vc.present(alert, animated: true)
    }
}
