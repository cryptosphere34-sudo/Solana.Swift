import Foundation

// Safe reserve capacity init (if library needs it)
extension Array {
    @inlinable
    init(reserveCapacity: Int) {
        self = [Element](reserveCapacity: reserveCapacity)
    }
}

// Fixed hex init for UInt8 array – no type mismatch, safe append
extension Array where Element == UInt8 {
    public init(hex: String) {
        var buffer: UInt8? = nil
        let hexScalars = hex.unicodeScalars.lazy

        self = Array(reserveCapacity: hexScalars.underestimatedCount / 2 + 1)

        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hexScalars {
            guard skip == 0 else {
                skip -= 1
                continue
            }

            guard char.value >= 48 && char.value <= 102 else { continue }

            let v: UInt8
            switch UInt8(char.value) {
            case 48...57: v = UInt8(char.value) - 48
            case 65...70: v = UInt8(char.value) - 55
            case 97...102: v = UInt8(char.value) - 87
            default: continue
            }

            if let b = buffer {
                let combined = UInt8((UInt16(b) << 4) | UInt16(v))
                append(combined)
                buffer = nil
            } else {
                buffer = v
            }
        }

        if let b = buffer {
            append(b)
        }
    }

    public func toHexString() -> String {
        map { String(format: "%02x", $0) }.joined()
    }
}
