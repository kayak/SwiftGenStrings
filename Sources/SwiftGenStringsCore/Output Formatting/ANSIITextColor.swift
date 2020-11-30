import Foundation

public enum ANSIITextColor: Int {

    case none = 0
    case red = 31
    case green = 32
    case yellow = 33

    var escapeSequence: String {
        "\u{001B}[0;\(rawValue)m"
    }

}

extension String {

    func formattedStringWithColor(_ color: ANSIITextColor) -> String {
        color.escapeSequence + self + ANSIITextColor.none.escapeSequence
    }

}
