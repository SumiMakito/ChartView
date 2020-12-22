import SwiftUI

public struct LineChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle
    var vpHeightPercent: CGFloat

    public var body: some View {
        Line(chartData: data, style: style, vpHeightPercent: vpHeightPercent)
    }

    public init(vpHeightPercent: CGFloat? = nil) {
        self.vpHeightPercent = vpHeightPercent ?? 0.8
    }
}
