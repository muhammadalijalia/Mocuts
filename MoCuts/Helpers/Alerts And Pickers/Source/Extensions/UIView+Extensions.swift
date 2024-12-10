import UIKit
import MaterialComponents

extension UIView {
    func dlgpicker_setupRoundCorners() {
        self.layer.cornerRadius = min(bounds.size.height, bounds.size.width) / 2
    }
    func roundCorners(_ cornerRadius: CGFloat) {
       self.layer.cornerRadius = cornerRadius
       self.clipsToBounds = true
       self.layer.masksToBounds = true
   }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIView {
    /// Loads nib from Bundle
    ///
    /// - Parameters:
    ///   - nibName: Nib Name
    ///   - viewIndex: View Index
    ///   - owner: Nib Owner AnyObject
    /// - Returns: UIView
    class func loadWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)![viewIndex];
    } //F.E.
}

extension UITableView {
    var contentSizeHeight: CGFloat {
        var height = CGFloat(0)
        for section in 0..<numberOfSections {
            height = height + rectForHeader(inSection: section).height
            let rows = numberOfRows(inSection: section)
            for row in 0..<rows {
                height = height + rectForRow(at: IndexPath(row: row, section: section)).height
            }
        }
        return height
    }
}
// MARK: - UITableView extension for Utility Method
public extension UITableView {
    
    func scrollToBottom(_ animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1));
                
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    } //F.E
    
    
    
    func scrollToTop(_ animated: Bool = true) {
        self.setContentOffset(CGPoint.zero, animated: animated);
    } //F.E.
    
} //E.E.

extension UIView {

    func AddMaterialTextField(frame: CGRect, labelText: String, placeholder: String, assistiveText: String) -> MDCFilledTextField {
        let textField = MDCFilledTextField(frame: frame)
        textField.label.text = labelText
        textField.placeholder = placeholder
        textField.leadingAssistiveLabel.text = assistiveText
        addSubview(textField)
        textField.sizeToFit()
        return textField
    }
}
