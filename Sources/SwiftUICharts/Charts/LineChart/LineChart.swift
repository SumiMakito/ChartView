import SwiftUI

public struct LineChart: View, ChartBase {
    public var chartData = ChartData()

    @EnvironmentObject var data: ChartData
    @EnvironmentObject var style: ChartStyle
    var paddingTopPercentage: Double = 0
    var paddingBottomPercentage: Double = 0

    public var body: some View {
        Line(chartData: data, style: style, paddingTopPercentage: paddingTopPercentage, paddingBottomPercentage: paddingBottomPercentage)
    }

    public init(paddingTopPercentage: Double = 0, paddingBottomPercentage: Double = 0) {
        self.paddingTopPercentage = paddingTopPercentage
        self.paddingBottomPercentage = paddingBottomPercentage
    }
}
