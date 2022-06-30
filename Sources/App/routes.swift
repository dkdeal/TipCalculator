import Vapor

func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        
        let context = CalculationData(
            billAmount: 0.0,
            tipPercent: 15.0,
            tipAmount: 0.0,
            totalAmount: 0.0)
        
        return req.view.render("index", context)
    }
    
    app.post { req -> EventLoopFuture<View> in
        
        let data = try req.content.decode(CalculationData.self)
        
        let result = calculateTip(data: data)
        
        return req.view.render("index", result)
    }
    
    app.post("api", "calculate") { req -> CalculationData in
        let data = try req.content.decode(CalculationData.self)
        
        let result = calculateTip(data: data)

        return result
    }
}

func calculateTip(data: CalculationData) -> CalculationData {
    
    let tipPercent = data.tipPercent / 100.0
    let tipAmount = data.billAmount * tipPercent
    let totalAmount = data.billAmount + tipAmount
    

    let result = CalculationData(
        billAmount: data.billAmount,
        tipPercent: data.tipPercent,
        tipAmount: tipAmount.round(to: 2),
        totalAmount: totalAmount.round(to: 2)
    )
    
    return result
}

struct CalculationData: Content {
    let billAmount: Double
    let tipPercent: Double
    let tipAmount: Double?
    let totalAmount: Double?
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

