import Foundation

extension Array {
  @inlinable
  init(reserveCapacity: Int) {
    self = [Element]()
    self.reserveCapacity(reserveCapacity)
  }

  @inlinable
  var slice: ArraySlice<Element> {
    self[self.startIndex ..< self.endIndex]
  }
}

extension Array where Element == UInt8 {
    public init(hex: String) {
        var buffer: UInt8? = nil
        let hexicodeScalars = hex.unicodeScalars.lazy.underestimatedCount

        self = Array(reserveCapacity: hexicodeScalars / 2 + 1)

        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
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

public extension Array where Element == UInt8 {
  func toBase64() -> String {
    Data(self).base64EncodedString()
  }

  init(base64: String) {
    self.init()

    guard let decodedData = Data(base64Encoded: base64) else {
      return
    }

    append(contentsOf: decodedData.bytes)
  }
}
