import UIKit

final class AlertManager {
    private static func showAlert(on vc: UIViewController,
                                  title: String,
                                  message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

extension AlertManager {
    public static func showNoSuchDataAlert(on vc: UIViewController) {
        self.showAlert(on: vc, title: "No Data", message: "No data available for the selected filters.")
    }
}
