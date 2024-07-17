import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()

    private let dateFormatterForLabel: DateFormatter
    private let dateFormatterForReq: DateFormatter

    private init() {
        dateFormatterForLabel = DateFormatter()
        dateFormatterForLabel.dateFormat = "MMMM d, yyyy"

        dateFormatterForReq = DateFormatter()
        dateFormatterForReq.dateFormat = "yyyy-MM-dd"
    }

    func formattedDateString(from date: Date) -> String {
        return dateFormatterForLabel.string(from: date)
    }

    func formattedDateForReq(from date: Date) -> String {
        return dateFormatterForReq.string(from: date)
    }

    func convertToDate(dateString: String) -> Date? {
        return dateFormatterForReq.date(from: dateString)
    }

    func formatDateString(_ dateString: String) -> String {
        if let date = dateFormatterForReq.date(from: dateString) {
            return dateFormatterForLabel.string(from: date)
        }
        return dateString
    }
}
//
