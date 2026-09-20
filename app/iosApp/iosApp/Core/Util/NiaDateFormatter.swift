import Foundation

enum NiaDateFormatter {
    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
        return formatter
    }()

    static func mediumDateString(epochMilliseconds: Int64) -> String {
        mediumDateFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(epochMilliseconds) / 1000)
        )
    }
}
