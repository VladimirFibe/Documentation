import CoreGraphics

func +(left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width + right.width, height: left.height + right.height)
}

extension CGSize {
    func scaleFactor(toFit rect: CGSize) -> Double {
        let scaleX = rect.width / self.width
        let scaleY = rect.height / self.height
        return min(scaleX, scaleY)
    }
}
