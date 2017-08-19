//
//  CSegmented
//
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit

@IBDesignable
class CSegmented: UIControl {
    
    private var buttons = [UIButton]()
    private var selectView:UIView = UIView()
    var selectedSegmentIndex = 0
    
    @IBInspectable var oval:Bool = true
    
    @IBInspectable var titles:String = "" {
        didSet {
           self.update()
        }
    }
    
    @IBInspectable var titlesColor:UIColor? {
        didSet {
            buttons.forEach { (b) in
                b.setTitleColor(titlesColor, for: .normal)
            }
        }
    }
    
    @IBInspectable var selectColor:UIColor? {
        didSet {
            selectView.backgroundColor = selectColor
        }
    }
    
    @IBInspectable var backColor:UIColor? {
        didSet {
            backgroundColor = backColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        if oval {
            layer.cornerRadius = frame.height / 2
            clipsToBounds = true
        } else {
            layer.cornerRadius = 0
            clipsToBounds = false
            selectView.layer.cornerRadius = 0
        }
    }
 
    func update() {
        
        buttons = []
        
        subviews.forEach { (i) in
            i.removeFromSuperview()
        }
        
        let buttonTitles = titles.components(separatedBy: ",")
        
        for i in 0..<buttonTitles.count {
            
            let button = UIButton()
            button.setTitle(buttonTitles[i], for: .normal)
            button.setTitleColor(titlesColor ?? UIColor.black, for: .normal)
            button.titleLabel?.font = UIFont(name: "Avenir", size: 17)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            self.buttons.append(button)
       
        }
        
        let sWidth = frame.width / CGFloat(buttonTitles.count)
        selectView.frame = CGRect(x: 0, y: 0, width: sWidth, height: frame.height)
        selectView.layer.cornerRadius = frame.height / 2
        selectView.backgroundColor = selectColor ?? UIColor.lightGray
        addSubview(selectView)
        
        let buttonStack = UIStackView(arrangedSubviews: buttons)
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillProportionally
        addSubview(buttonStack)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        buttonStack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        buttonStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    func buttonAction(_ sender:UIButton) {
       
        for (index,button) in buttons.enumerated() {
            if button == sender {
                self.selectedSegmentIndex = index
                UIView.animate(withDuration: 0.3, animations: {
                    let sPos = self.frame.width / CGFloat(self.buttons.count) * CGFloat(index)
                    self.selectView.frame.origin.x = sPos
                })
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
}//
