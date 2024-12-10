import UIKit

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}

extension UIApplication {
    func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}
public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    //MARK: - Methods
    
    ///Returns JSON String
    func toJSONString() -> String? {
        return self.toJSONData()?.toString();
    } //F.E.
    
    ///Returns JSON Data
    func toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: []);
    } //F.E.
    
} //E.E.

// MARK: - Data extension for JSON serialization.
public extension Data {
    
    //MARK: - Methods
    
    ///Returns String from Data
    func toString() -> String? {
        return String(data: self, encoding: String.Encoding.utf8);
    } //F.E.
    
    ///Returns JSON Object from Data
    func toJSONObject() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableContainers);
        } catch let error as NSError {
            //print(error)
        }
        
        return nil
    } //F.E.
    
} //E.E.
