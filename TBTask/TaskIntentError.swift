import Foundation

enum TaskIntentError: LocalizedError, CustomLocalizedStringResourceConvertible {
    case taskNotFound

    var localizedStringResource: LocalizedStringResource {
        switch self {
            case .taskNotFound: return "I couldn't find any task to delete"
        }
    }
}
