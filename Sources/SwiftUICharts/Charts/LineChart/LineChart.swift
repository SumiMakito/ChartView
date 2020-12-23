import SwiftUI

public struct LineChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle
    var paddingBottomPercentage: Double = 0

    public var body: some View {
        Line(chartData: data, style: style, paddingBottomPercentage: paddingBottomPercentage)
    }

    public init(paddingBottomPercentage: Double = 0) {
        self.paddingBottomPercentage = paddingBottomPercentage
    }
}
