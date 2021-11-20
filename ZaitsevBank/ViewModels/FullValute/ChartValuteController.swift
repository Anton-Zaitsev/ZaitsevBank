//
//  ChartValuteController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import UIKit

class ChartValuteController: UIViewController, ChartDelegate {
    
    public var dinamicValute : DinamicValute!
    public var valuteName : String!
    
    public var valuteToogle : Bool!
    
    @IBOutlet weak var MainLabel: UILabel!
    
    @IBOutlet weak var LabelChart: UILabel!
    @IBOutlet weak var ViewChart: Chart!
    @IBOutlet weak var LabelChartLeading: NSLayoutConstraint!
    
    
    @IBOutlet weak var NumberMinimum: UILabel!
    @IBOutlet weak var NumberMax: UILabel!
    @IBOutlet weak var NumberStart: UILabel!
    @IBOutlet weak var NumberNow: UILabel!
    
    
    
    fileprivate var marginLabelChart: CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getView()
    }
    
    private func getView() {
        MainLabel.text = "Динамика \(valuteName ?? "none") за 6 месяцев."
        
        let valute = valuteToogle ? " ₽" : " $"
        
        NumberMinimum.text = "\(String(format: "%.2f",dinamicValute.min).replacingOccurrences(of: ".", with: ","))" + valute
        NumberMax.text = "\(String(format: "%.2f",dinamicValute.max).replacingOccurrences(of: ".", with: ","))" + valute
        NumberStart.text = "\(String(format: "%.2f",dinamicValute.start).replacingOccurrences(of: ".", with: ","))" + valute
        NumberNow.text = "\(String(format: "%.2f",dinamicValute.now).replacingOccurrences(of: ".", with: ","))" + valute
        
        
        marginLabelChart = LabelChartLeading.constant
        
        ViewChart.delegate = self
                
        let serieData: [Double] = dinamicValute.value
        
        var labels: [Double] = []
        var labelsAsString: Array<String> = []
        
        // Date formatter to retrieve the month names
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        for (i, value) in dinamicValute.data.enumerated() {
                        
            let format = DateFormatter()
            format.dateFormat = "dd.MM.yyyy"
            // Use only one label for each month
            let month = Int(dateFormatter.string(from: format.date(from: value)!))!
            let monthAsString:String = dateFormatter.monthSymbols[month - 1]
            if (labels.count == 0 || labelsAsString.last != monthAsString) {
                labels.append(Double(i))
                labelsAsString.append(monthAsString)
            }
        }
        
        let series = ChartSeries(serieData)
        series.area = true
        
        series.color = ChartColors.greenColor()
        // Configure chart layout
        
        ViewChart.lineWidth = 0.5
        ViewChart.labelFont = UIFont.systemFont(ofSize: 12)

        ViewChart.xLabels = labels
        ViewChart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        ViewChart.xLabelsTextAlignment = .center
        ViewChart.yLabelsOnRightSide = true
        // Add some padding above the x-axis
        ViewChart.minY = serieData.min()! - 5
        
        ViewChart.add(series)
    }
    
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        if let value = ViewChart.valueForSeries(0, atIndex: indexes[0]) {
            
            let valute = valuteToogle ? " ₽" : " $"
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            LabelChart.text = numberFormatter.string(from: NSNumber(value: value))! + valute
            
            // Align the label to the touch left position, centered
            var constant = marginLabelChart + left - (LabelChart.frame.width / 2)
            
            // Avoid placing the label on the left of the chart
            if constant < marginLabelChart {
                constant = marginLabelChart
            }
            
            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - LabelChart.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }
            
            LabelChartLeading.constant = constant
            
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        LabelChart.text = ""
        LabelChartLeading.constant = marginLabelChart
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
}
