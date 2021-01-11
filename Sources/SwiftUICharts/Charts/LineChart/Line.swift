import SwiftUI

public struct Line: View {
    @EnvironmentObject var chartValue: ChartValue
    @State var frame: CGRect = .zero
    @ObservedObject var chartData: ChartData

    var style: ChartStyle

    @State var touchLocation: CGPoint = .zero
    @State private var showFull: Bool = true
    @State var showBackground: Bool = true

    var paddingTopPercentage: Double = 0
    var paddingBottomPercentage: Double = 0
    var curvedLines: Bool = true

    private var paddingTop: Double {
        Double(frame.size.height) * paddingTopPercentage
    }

    private var paddingBottom: Double {
        Double(frame.size.height) * paddingBottomPercentage
    }

    var step: CGPoint {
        var points = chartData.data
        if points.count == 1 {
            points = [points[0], points[0]]
        }

        return CGPoint.getStep(frame: frame, data: points, paddingTop: paddingTop, paddingBottom: paddingBottom)
    }

    var path: Path {
        var points = chartData.data
        if points.count == 1 {
            points = [points[0], points[0]]
        }

        if curvedLines {
            return Path.quadCurvedPathWithPoints(points: points, step: step, paddingBottom: paddingBottom)
        }

        return Path.linePathWithPoints(points: points, step: step, paddingBottom: paddingBottom)
    }

    var closedPath: Path {
        var points = chartData.data
        if points.count == 1 {
            points = [points[0], points[0]]
        }

        if curvedLines {
            return Path.quadClosedCurvedPathWithPoints(points: points, step: step, paddingBottom: paddingBottom)
        }

        return Path.closedLinePathWithPoints(points: points, step: step, paddingBottom: paddingBottom)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.getBackgroundPathView()
                self.getLinePathView()
            }
            .onAppear {
                self.frame = geometry.frame(in: .local)
            }
        }
    }
}

// MARK: - Private functions

extension Line {
    private func getClosestPointOnPath(touchLocation: CGPoint) -> CGPoint {
        let closest = path.point(to: touchLocation.x)
        return closest
    }

    private func getClosestDataPoint(point: CGPoint) {
        var points = chartData.data
        if points.count == 1 {
            points = [points[0], points[0]]
        }

        let index = Int(round(point.x / step.x))
        if index >= 0, index < points.count {
            chartValue.currentValue = points[index]
        }
    }

    private func getBackgroundPathView() -> some View {
        closedPath
            .fill(LinearGradient(gradient: Gradient(colors: [
                    style.foregroundColor.first?.startColor ?? .white,
                    style.foregroundColor.first?.endColor.opacity(0) ?? .white
                ]),
                startPoint: .bottom,
                endPoint: .top))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            .opacity(1)
    }

    private func getLinePathView() -> some View {
        path
            .stroke(
                LinearGradient(
                    gradient: style.foregroundColor.first?.gradient ?? ColorGradient.orangeBright.gradient,
                    startPoint: .leading,
                    endPoint: .trailing),
                style: StrokeStyle(lineWidth: 3, lineJoin: .round))
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Line(chartData: ChartData([]), style: redLineStyle, paddingTopPercentage: 0.1, paddingBottomPercentage: 0.2)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 300))
            Line(chartData: ChartData([2]), style: redLineStyle, paddingTopPercentage: 0.1, paddingBottomPercentage: 0.2)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 300))
            Line(chartData: ChartData([2, 13, 65, 34, 9, -5, 5]), style: redLineStyle, paddingTopPercentage: 0.1, paddingBottomPercentage: 0.2)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 300))
        }
    }
}

private let blackLineStyle = ChartStyle(backgroundColor: ColorGradient(.white), foregroundColor: ColorGradient(.black))
private let redLineStyle = ChartStyle(backgroundColor: .whiteBlack, foregroundColor: ColorGradient(.red))
