import UIKit

extension UIColor {
    static var ypBlack: UIColor {
        guard let color = UIColor(named: "YP Black") else { // с пробелом!
            fatalError("Не удалось загрузить цвет 'YP Black' из Assets")
        }
        return color
    }
    
    static var ypRed: UIColor {
        guard let color = UIColor(named: "YP Red") else { // с пробелом!
            fatalError("Не удалось загрузить цвет 'YP Red' из Assets")
        }
        return color
    }
    
    static var ypWhite: UIColor {
        guard let color = UIColor(named: "YP White") else { // с пробелом!
            fatalError("Не удалось загрузить цвет 'YP White' из Assets")
        }
        return color
    }
    
    static var ypGreen: UIColor {
        guard let color = UIColor(named: "YP Green") else { // с пробелом!
            fatalError("Не удалось загрузить цвет 'YP Green' из Assets")
        }
        return color
    }
    
    static var ypGray: UIColor {
        guard let color = UIColor(named: "YP Gray") else { // с пробелом!
            fatalError("Не удалось загрузить цвет 'YP Gray' из Assets")
        }
        return color
    }
}
