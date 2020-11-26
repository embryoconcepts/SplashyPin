import UIKit

extension UIColor {
    /// Returns true if the image is considered "dark". To be used to determine the appropriate font color for overlying text.
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum <= 0.50
    }
}
