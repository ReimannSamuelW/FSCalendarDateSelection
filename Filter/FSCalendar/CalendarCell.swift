//
//  CalendarCell.swift
//  CalendarExample
//
//  Created by Enrique Melgarejo on 28/03/22.
//

import FSCalendar
import UIKit

enum SelectionType {
    case none
    case today
    case single
    case leftBorder
    case leftCorner
    case middle
    case rightBorder
    case rightCorner
}

class CalendarCell: FSCalendarCell {
    
    private weak var circleImageView: UIImageView?
    private weak var selectionLayer: CAShapeLayer?
    private weak var roundedLayer: CAShapeLayer?
    private weak var todayLayer: CAShapeLayer?
    private weak var curvedRightLayer: CAShapeLayer?
    private weak var curvedLeftLayer: CAShapeLayer?
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor(red: 241 / 255.0, green: 228 / 255.0, blue: 251 / 255.0, alpha: 1.0).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel?.layer)
        self.selectionLayer = selectionLayer
        
        let roundedLayer = CAShapeLayer()
        let colors = UIColor(red: 76.0 / 255.0, green: 39.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        roundedLayer.fillColor =  colors.cgColor
        roundedLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(roundedLayer, below: self.titleLabel?.layer)
        self.roundedLayer = roundedLayer
        
        
        
        let curvedRightLayer = CAShapeLayer()
        curvedRightLayer.fillColor = UIColor(red: 241 / 255.0, green: 228 / 255.0, blue: 251 / 255.0, alpha: 1.0).cgColor
        curvedRightLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(curvedRightLayer, below: self.titleLabel?.layer)
        self.curvedRightLayer = curvedRightLayer
        
        
        let curvedLeftLayer = CAShapeLayer()
        curvedLeftLayer.fillColor = UIColor(red: 241 / 255.0, green: 228 / 255.0, blue: 251 / 255.0, alpha: 1.0).cgColor
        curvedLeftLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(curvedLeftLayer, below: self.titleLabel?.layer)
        self.curvedLeftLayer = curvedLeftLayer
        
        
        let todayLayer = CAShapeLayer()
        todayLayer.fillColor = UIColor.red.cgColor
        todayLayer.strokeColor = UIColor.orange.cgColor
        todayLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(todayLayer, below: self.titleLabel?.layer)
        self.todayLayer = todayLayer
    
        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionLayer?.frame = self.contentView.bounds
        self.roundedLayer?.frame = self.contentView.bounds
        self.todayLayer?.frame = self.contentView.bounds
        self.curvedRightLayer?.frame = self.contentView.bounds
        self.curvedLeftLayer?.frame = self.contentView.bounds
        
        let contentHeight = self.contentView.frame.height
        let contentWidth = self.contentView.frame.width
        
        let selectionLayerBounds = selectionLayer?.bounds ?? .zero
        let selectionLayerWidth = selectionLayer?.bounds.width ?? .zero
        
        let roundedLayerHeight = roundedLayer?.frame.height ?? .zero
        let roundedLayerWidth = roundedLayer?.frame.width ?? .zero
        
        switch selectionType {
        case .middle:
            print("middle")
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = true
            self.todayLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = true
            
            let selectionRect = selectionLayerBounds
                .insetBy(dx: 0.0, dy: 4.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
            
        case .leftBorder:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = false
            self.todayLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
            
            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 4, dy: 4)
                .offsetBy(dx: selectionLayerWidth / 4, dy: 0.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
            
            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
            
        case .leftCorner:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
            self.todayLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = false
            
            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 25, dy: 4)
                .offsetBy(dx: -selectionLayerWidth / -25, dy: 0.0)
            self.curvedLeftLayer?.path  =  UIBezierPath(roundedRect: selectionRect, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: contentWidth/3.5, height: contentHeight)).cgPath
            
        case .rightBorder:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = false
            self.todayLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 4, dy: 4)
                .offsetBy(dx: -selectionLayerWidth / 4, dy: 0.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
            
            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
            
        case .rightCorner:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
            self.todayLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = false
            
            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 25, dy: 4.0)
                .offsetBy(dx: -selectionLayerWidth / 25, dy: 0.0)
            self.curvedRightLayer?.path  =  UIBezierPath(roundedRect: selectionRect, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: selectionLayerWidth/3.5, height: contentHeight)).cgPath
             
        case .single:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = false
            self.todayLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
            
            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
            
        case .today:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
            self.todayLayer?.isHidden = false
            self.curvedLeftLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
            
            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.todayLayer?.path = UIBezierPath(ovalIn: rect).cgPath
            
        case .none:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
            self.todayLayer?.isHidden = true
            self.curvedLeftLayer?.isHidden = true
            self.curvedRightLayer?.isHidden = true
        }
    }
}
