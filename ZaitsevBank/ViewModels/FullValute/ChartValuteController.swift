//
//  ChartValuteController.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 16.11.2021.
//

import UIKit

class ChartValuteController: UIViewController, ChartDelegate,CardPickDelegate {
    
    func CardPick(Cards: [Cards]?,indexPickCard: Int?) {
        if let CardsUser = Cards {
            
            let MenuBuyPayValute = self.storyboard?.instantiateViewController(withIdentifier: "BuyPayValute") as! MenuBuyPayValuteController
            MenuBuyPayValute.cardBuy = CardsUser
            MenuBuyPayValute.TypeValuteEnrollment = valuteSymbol
            MenuBuyPayValute.IndexFirstCard = indexPickCard!
            MenuBuyPayValute.BuySaleToogle = valuteBuySaleToogle
            self.navigationController?.pushViewController(MenuBuyPayValute, animated: true)
        }
        else {
            let loader = self.EnableLoader()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                Task(priority: .medium) {
                    
                    if let data = await AccountManager().GetUserData(){
                        DispatchQueue.main.async {
                            let storyboardMainMenu : UIStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
                            let AddNewCardController = storyboardMainMenu.instantiateViewController(withIdentifier: "NewCardMenu") as! NewCardController
                            AddNewCardController.nameFamilyOwner = "\(data.firstName) \(data.lastName)"
                            if (self.valuteBuySaleToogle == false){
                            AddNewCardController.ValutePick = self.valuteSymbol
                            }
                            
                            self.DisableLoader(loader: loader)
                            self.navigationController?.pushViewController(AddNewCardController, animated: true)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.DisableLoader(loader: loader)
                            self.showAlert(withTitle: "Произошла ошибка", withMessage: "Не удалось получить данные с сервера о пользователе")
                        }
                    }
                    
                }
            }
        }
    }
    

    @IBOutlet weak var ButtonMenuDate: UIButton!
    
    public var dinamicValute : DinamicValute!
    public var valuteName : String!
    public var valuteSymbol: String!
    public var idValute : String!
        
    @IBOutlet weak var BuySaleStack: UIStackView!
    
    public var valuteToogle : Bool!
    public var valuteBuySaleToogle: Bool = false
    
    @IBOutlet weak var MainLabel: UILabel!
    
    @IBOutlet weak var StackChart: UIStackView!
    @IBOutlet weak var LabelChart: UILabel!
    @IBOutlet weak var ImageControlChart: UIImageView!
    @IBOutlet weak var SubLabelChart: UILabel!
    
    @IBOutlet weak var ChartChartLeading: NSLayoutConstraint!
    
    @IBOutlet weak var ViewChart: Chart!
    
    
    @IBOutlet weak var NumberMinimum: UILabel!
    @IBOutlet weak var NumberMax: UILabel!
    @IBOutlet weak var NumberStart: UILabel!
    @IBOutlet weak var NumberNow: UILabel!
    
    
    
    fileprivate var marginLabelChart: CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getMenuData()
        getView()
    }
    
    @IBAction func ClickedBuy(_ sender: Any) {
        valuteBuySaleToogle = true
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardPick") as! CardPickController
        CardPick.textMainLable = "покупки валюты."
        CardPick.buySaleToogle = valuteBuySaleToogle
        CardPick.valuteSymbol = valuteSymbol
        CardPick.delegate = self
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
    }
    
    @IBAction func ClickedSale(_ sender: Any) {
        valuteBuySaleToogle = false
        let CardPick = storyboard?.instantiateViewController(withIdentifier: "CardPick") as! CardPickController
        CardPick.textMainLable = "продажи валюты."
        CardPick.valuteSymbol = valuteSymbol
        CardPick.buySaleToogle = valuteBuySaleToogle
        CardPick.delegate = self
        CardPick.sheetPresentationController?.detents = [.medium()]
        present(CardPick, animated: true)
    }
    
    private func getMenuData() {
        self.setNavigationBar("Динамика \(valuteName ?? "none") за месяц.")
        
        marginLabelChart = ChartChartLeading.constant
        
        let menuDate = UIMenu(title: "", children: [
            UIAction(title: "По месяцам", image: UIImage(systemName: "arrow.forward.circle.fill")) { action in
                self.getDataFromMenu(datavalute: .month)
                },
            UIAction(title: "По кварталам", image: UIImage(systemName: "arrow.forward.circle.fill")) { action in
                self.getDataFromMenu(datavalute: .quarter)
                },
            UIAction(title: "По полугодиям", image: UIImage(systemName: "arrow.forward.circle.fill")) { action in
                self.getDataFromMenu(datavalute: .halfYear)
                },
            UIAction(title: "По годам", image: UIImage(systemName: "arrow.forward.circle.fill")) { action in
                self.getDataFromMenu(datavalute: .year)
                }
            
        ])
        ButtonMenuDate.menu = menuDate
        
    }
    
    private func getView() {
        LabelChart.text = " "
        SubLabelChart.text = ""
        ImageControlChart.image = nil
        
        switch ValuteZaitsevBank(rawValue: valuteSymbol){
        case .USD :
            BuySaleStack.isHidden = false
        case .EUR :
            BuySaleStack.isHidden = false
        case .BTC :
            BuySaleStack.isHidden = false
        case .ETH :
            BuySaleStack.isHidden = false
        case .none:
            BuySaleStack.isHidden = true
        case .some(_):
            BuySaleStack.isHidden = true
        }
        
        let valute = valuteToogle ? " ₽" : " $"
        
        NumberMinimum.text = "\(String(format: "%.2f",dinamicValute.min).replacingOccurrences(of: ".", with: ","))" + valute
        NumberMax.text = "\(String(format: "%.2f",dinamicValute.max).replacingOccurrences(of: ".", with: ","))" + valute
        NumberStart.text = "\(String(format: "%.2f",dinamicValute.start).replacingOccurrences(of: ".", with: ","))" + valute
        NumberNow.text = "\(String(format: "%.2f",dinamicValute.now).replacingOccurrences(of: ".", with: ","))" + valute
        
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
        series.area = false
        
        series.colors = (
          above: ChartColors.greenColor(),
          below: ChartColors.redColor(),
          zeroLevel: dinamicValute.start
        )
        
        ViewChart.showYLabelsAndGrid = false
        
        // Configure chart layout
    
        ViewChart.labelFont = UIFont.systemFont(ofSize: 12)

        ViewChart.xLabels = labels
        ViewChart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelsAsString[labelIndex]
        }
        ViewChart.xLabelsTextAlignment = .center
        ViewChart.yLabelsOnRightSide = true
        // Add some padding above the x-axis
        //ViewChart.minY = serieData.min()! - 5
        
        ViewChart.add(series)
    }
    
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat){
        print()
        if let value = ViewChart.valueForSeries(0, atIndex: indexes[0]) {
            
            let valute = valuteToogle ? " ₽" : " $"
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            LabelChart.text = numberFormatter.string(from: NSNumber(value: value))! + valute
                            
            let changes = (value - dinamicValute.start) >= 0
            ImageControlChart.image = UIImage(systemName: changes ? "chevron.up" : "chevron.down")?.withRenderingMode(.alwaysOriginal).withTintColor(changes ? .green : .red)
            let changesValue = (value - dinamicValute.start) / ((value + dinamicValute.start) / 2) * 100
            SubLabelChart.text = " " + numberFormatter.string(from: NSNumber(value: fabs(changesValue) ))! + " % "
            SubLabelChart.textColor = changesValue >= 0 ? UIColor.green : UIColor.red
                
            // Align the label to the touch left position, centered
            var constant = marginLabelChart + left - (StackChart.frame.width / 2)
            
            // Avoid placing the label on the left of the chart
            if constant < marginLabelChart {
                constant = marginLabelChart
            }
            
            // Avoid placing the label on the right of the chart
            let rightMargin = chart.frame.width - StackChart.frame.width
            if constant > rightMargin {
                constant = rightMargin
            }
            
            ChartChartLeading.constant = constant
            
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        LabelChart.text = ""
        SubLabelChart.text = ""
        ImageControlChart.image = nil
        ChartChartLeading.constant = marginLabelChart
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    private func getDataFromMenu(datavalute: DataDinamicValute) {
        let loader = self.EnableLoader()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { [self] in
            Task{
                
                guard let data = valuteToogle ?
                        await API_DinamicValute().GetDinamicValute(idValute: idValute, datavalute) :
                            await API_DinamicValute().GetDinamicCriptoValute(nameValute: valuteName,datavalute) else {
                                return
                            }
                dinamicValute = data
                DispatchQueue.main.async { [self] in
                    ViewChart.removeAllSeries()
                    getView()
                    navigationItem.title = "Динамика \(valuteName ?? "none") \(datavalute.description)."
                }
            }
        }
        DisableLoader(loader: loader)
    }
}

