//
//  MoCutsAppButton.swift
//  MoCuts
//
//  Created by Muhammad Zawwar on 20/07/2021.
//

import UIKit

class MoCutsAppButton: CustomNibView {

    enum ButtonColor {
        case orange
        case clear
        case green
        case blue
    }
        
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var buttonText: UILabel!
    
    private var action : (() -> Void)? = nil
    
    var buttonColor: ButtonColor = .clear
    
    override func setupView() {
        self.backgroundColor = .clear
    }
    
    func setButtonView() {
        if buttonColor == .orange {
            self.bgView.backgroundColor = Theme.appOrangeColor
            self.buttonText.textColor = .white
            self.bgView.layer.borderColor = UIColor.clear.cgColor
            self.bgView.layer.borderWidth = 0
        } else if buttonColor == .green {
            self.bgView.backgroundColor = Theme.appButtonGreenColor
            self.buttonText.textColor = .white
            self.bgView.layer.borderColor = UIColor.clear.cgColor
            self.bgView.layer.borderWidth = 0
        } else if buttonColor == .clear {
            self.bgView.backgroundColor = UIColor.clear
            self.buttonText.textColor = UIColor(hex: "#04396C")
            self.bgView.layer.borderColor = UIColor(hex: "#04396C").cgColor
            self.bgView.layer.borderWidth = 1
        } else if buttonColor == .blue {
            self.bgView.backgroundColor = Theme.appButtonBlueColor
            self.buttonText.textColor = .white
            self.bgView.layer.borderColor = UIColor.clear.cgColor
            self.bgView.layer.borderWidth = 0
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.makeEdgesCircular()
        self.setButtonView()
    }
    
    func makeEdgesCircular(){
        self.bgView.layer.cornerRadius = 5
        self.bgView.clipsToBounds = true
    }
    
    func setAction(actionP: @escaping (() -> Void)){
        self.action = actionP
    }
    
    func setTextColor(color: UIColor){
        self.buttonText.textColor = color
    }
    
    func setText(text: String){
        self.buttonText.text = text
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let action = self.action {
            action()
        }
    }
}
