import SwiftUI

public struct Line: View {
    @EnvironmentObject var chartValue: ChartValue
    @State var frame: CGRect = .zero
    @ObservedObject var chartData: ChartData

    var style: ChartStyle

    @State var touchLocation: CGPoint = .zero
    @State private var showFull: Bool = true
    @State var showBackground: Bool = true

    var paddingBottomPercentage: Double = 0
    var curvedLines: Bool = true

    private var paddingBottom: Double {
        Double(frame.size.height) * paddingBottomPercentage
    }

    var step: CGPoint {
        return CGPoint.getStep(frame: frame, data: chartData.data, paddingBottom: paddingBottom)
    }

    var path: Path {
        let points = chartData.data

        if curvedLines {
            return Path.quadCurvedPathWithPoints(points: points, step: step, paddingBottom: paddingBottom)
        }

        return Path.linePathWithPoints(points: points, step: step, paddingBottom: paddingBottom)
    }

    var closedPath: Path {
        let points = chartData.data

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
        let index = Int(round(point.x / step.x))
        if index >= 0, index < chartData.data.count {
            chartValue.currentValue = chartData.data[index]
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
            Line(chartData: ChartData([8, 23, 32, 7, 23, 43]), style: redLineStyle)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 300))
        }
    }
}

private let blackLineStyle = ChartStyle(backgroundColor: ColorGradient(.white), foregroundColor: ColorGradient(.black))
private let redLineStyle = ChartStyle(backgroundColor: .whiteBlack, foregroundColor: ColorGradient(.red))
