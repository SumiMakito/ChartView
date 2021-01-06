import SwiftUI

extension CGPoint {
    static func getStep(frame: CGRect, data: [Double], paddingTop: Double, paddingBottom: Double) -> CGPoint {
        // stepWidth
        var stepWidth: CGFloat = 0.0
        if data.count < 2 {
            stepWidth = 0.0
        }
        stepWidth = frame.size.width / CGFloat(data.count - 1)

        // stepHeight
        var stepHeight: CGFloat = 0.0

        var min: Double?
        var max: Double?
        if let minPoint = data.min(), let maxPoint = data.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        } else {
            return CGPoint(x: stepWidth, y: frame.size.height - CGFloat(paddingBottom))
        }
        if let min = min, let max = max, min != max {
            stepHeight = (frame.size.height - CGFloat(paddingBottom) - CGFloat(paddingTop)) / CGFloat(max - min)
        }

        return CGPoint(x: stepWidth, y: stepHeight)
    }
}
