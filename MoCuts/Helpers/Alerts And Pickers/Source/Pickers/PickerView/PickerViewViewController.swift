//import UIMultiPicker
import UIKit

extension UIAlertController {
    
    /// Add a picker view
    ///
    /// - Parameters:
    ///   - values: values for picker view
    ///   - initialSelection: initial selection of picker view
    ///   - action: action for selected value of picker view
    public func addPickerView(values: PickerViewViewController.Values,  initialSelection: [PickerViewViewController.Index]? = nil, action: PickerViewViewController.Action?) {
        let pickerView = PickerViewViewController(values: values, initialSelection: initialSelection, action: action)
        set(vc: pickerView, height: 216)
    }
    
    public func addMultiPickerView(values: PickerViewViewController.Values,  initialSelection: [PickerViewViewController.Index]? = nil, action: PickerViewViewController.Action?) {
        let pickerView = PickerViewViewController(values: values, initialSelection: initialSelection, action: action, isMulti: true)
        set(vc: pickerView, height: 216)
    }
}

final public class PickerViewViewController: UIViewController {
    
    public typealias Values = [[String]]
    public typealias Index = (column: Int, row: Int)
    public typealias Action = (_ vc: UIViewController, _ picker: UIView, _ index: [Index], _ values: Values) -> ()
    
    fileprivate var action: Action?
    fileprivate var values: Values = [[]]
    fileprivate var initialSelection: [Index]?
    fileprivate var isMultiSelect: Bool = false
    
    fileprivate lazy var pickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
//    fileprivate lazy var multiPickerView: UIMultiPicker = {
//        return $0
//    }(UIMultiPicker())
    
    public init(values: Values, initialSelection: [Index]? = nil, action: Action?, isMulti: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.values = values
        self.initialSelection = initialSelection
        self.action = action
        self.isMultiSelect = isMulti
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override public func loadView() {
//        if isMultiSelect{
//            view = multiPickerView
//        }
//        else{
            view = pickerView
//        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
//        if isMultiSelect{
//            // Model
//            multiPickerView.options = values[0]
//            var selectedIndexes = [Int]()
//            if let initialSelection = initialSelection {
//                for index in initialSelection {
//                    selectedIndexes.append(index.row)
//                }
//            }
//            multiPickerView.selectedIndexes = selectedIndexes
//            // Styling
//            multiPickerView.color = .gray
//            multiPickerView.tintColor = .blue
//            multiPickerView.font = UIFont.systemFont(ofSize: 13)
//
//            // Add selection listener
//            multiPickerView.addTarget(self, action: #selector(PickerViewViewController.selected(_:)), for: .valueChanged)
//
//            multiPickerView.highlight(0, animated: false) // centering "Bitter"
//        }
//        else{
            pickerView.dataSource = self
            pickerView.delegate = self
//        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !isMultiSelect {
            if let initialSelections = initialSelection {
                if initialSelections.count > 0 {
                    let initialSelection = initialSelections[0]
                    if values.count > initialSelection.column, values[initialSelection.column].count > initialSelection.row{
                    pickerView.selectRow(initialSelection.row, inComponent: initialSelection.column, animated: true)
                    }
                }
                
            }
        }
        else{
            
        }
    }
    
//    @objc func selected(_ sender: UIMultiPicker) {
//        print(sender.selectedIndexes)
//        var indexes = [Index]()
//        for index in sender.selectedIndexes {
//            indexes.append(Index(column: 0, row: index))
//        }
//        action?(self, pickerView, indexes, values)
//    }
}

extension PickerViewViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return values.count
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values[component].count
    }
    /*
     // returns width of column and height of row for each component.
     public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
     
     }
     
     public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
     
     }
     */
    
    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    /*public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
    }*/
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: pickerView.frame.size.width-20, height: 40))
            pickerLabel?.numberOfLines = 0
            pickerLabel?.font = UIFont.systemFont(ofSize: 13)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = values[component][row]
        pickerLabel?.textColor = UIColor.black

        return pickerLabel!
    }
    /*
     public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
     // attributed title is favored if both methods are implemented
     }
     
     
     public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     
     }
     */
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        action?(self, pickerView, [Index(column: component, row: row)], values)
    }
}

