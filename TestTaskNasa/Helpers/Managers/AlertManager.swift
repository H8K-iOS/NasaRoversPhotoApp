import UIKit

final class AlertManager {
    private static func showAlert(on vc: UIViewController,
                                  title: String,
                                  message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    private static func confitmatonAllert(on vc: UIViewController,
                                              title: String,
                                              message: String?,
                                              saveHandler: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertConfirm = UIAlertAction(title: "Save", style: .default) { _ in
            saveHandler()
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(alertConfirm)
        alert.addAction(alertCancel)
        vc.present(alert, animated: true)
    }
    
    private static func applyFilterAlert(on vc: UIViewController,
                                             title: String,
                                             message: String?,
                                             useHandler: @escaping() -> Void,
                                             deleteHandler: @escaping()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let alertAply = UIAlertAction(title: "Use", style: .default) { _ in
            useHandler()
        }
        
        let alertDelete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            deleteHandler()
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAply)
        alert.addAction(alertDelete)
        alert.addAction(alertCancel)
        vc.present(alert, animated: true)
    }
}

extension AlertManager {
    public static func showNoSuchDataAlert(on vc: UIViewController) {
        self.showAlert(on: vc, 
                       title: "No Data",
                       message: "No data available for the selected filters."
        )
    }
}

extension AlertManager {
    public static func showSaveFilterAlert(on vc: UIViewController, completion: @escaping() -> Void) {
        self.confitmatonAllert(on: vc,
                               title: "Save Filters",
                               message: nil,
                               saveHandler: completion
        )
       
    }
}

extension AlertManager {
    public static func showApplyFilterAllert(on vc: UIViewController, completionApply: @escaping() -> Void, completionDelete: @escaping() -> Void ) {
        self.applyFilterAlert(on: vc,
                              title: "Menu Filter",
                              message: nil,
                              useHandler: completionApply,
                              deleteHandler: completionDelete)
    }
}
