//
//  Rating.swift
//  DepictionKit
//
//  Created by Andromeda on 25/08/2021.
//

import UIKit

/**
 Create a star rating
      
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - rating: `Int`; Rating value between 0 - 5
    - alignment: `Alignment? = "center"`; Set the alignment of the image.
 */
final public class Rating: UIView, DepictionViewDelegate {
    
    private let rating: Double
    private let star_size: CGFloat
    
    private enum Error: LocalizedError {
        case missing_rating
        case unknown_alignment_error
        
        public var errorDescription: String? {
            switch self {
            case .missing_rating: return "Rating is missing required argument: rating"
            case .unknown_alignment_error: return "Rating had unknown alignment error"
            }
        }
    }
    
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 2.5
        view.backgroundColor = .clear
        return view
    }()
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    
    init(for properties: [String: Any], theme: Theme, height: CGFloat) throws {
        guard let rating = properties["rating"] as? Double else { throw Error.missing_rating }
        
        var alignment: NSTextAlignment = .center
        if let _alignment = properties["alignment"] as? String {
            do {
                alignment = try Alignment.alignment(for: _alignment)
            } catch {
                throw error
            }
        }
        
        self.rating = rating
        self.theme = theme
        self.star_size = height - 10
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        var constraints = [NSLayoutConstraint]()
        for _ in 1...5 {
            let star = Star(star_size)
            contentView.addArrangedSubview(star)
        }
        
        constraints += [
            contentView.heightAnchor.constraint(equalToConstant: height),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        switch alignment {
        case .left:
            constraints.append(contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15))
            let lesserTrailing = contentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15)
            lesserTrailing.priority = UILayoutPriority(1)
            constraints.append(lesserTrailing)
        case .right:
            constraints.append(contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15))
            let lesserLeading = contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15)
            lesserLeading.priority = UILayoutPriority(1)
            constraints.append(lesserLeading)
        case .center:
            constraints.append(contentView.centerXAnchor.constraint(equalTo: centerXAnchor))
            let lesserLeading = contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15)
            lesserLeading.priority = UILayoutPriority(1)
            constraints.append(lesserLeading)
            let lesserTrailing = contentView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -15)
            lesserTrailing.priority = UILayoutPriority(1)
            constraints.append(lesserTrailing)
        default: throw Error.unknown_alignment_error
        }
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        contentView.isLayoutMarginsRelativeArrangement = true
        NSLayoutConstraint.activate(constraints)
        
        themeDidChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillInStars() {
        for (index, star) in contentView.subviews.enumerated() {
            let index = index + 1
            guard let star = star as? Star else { continue }
            
            if rating.isInt {
                if Double(index) <= rating {
                    star.fillColor = theme.tint_color
                    continue
                }
            } else {
                if floor(rating) >= Double(index) {
                    star.fillColor = theme.tint_color
                    continue
                } else if round(rating) == Double(index) {
                    star.fillColor = theme.tint_color
                    continue
                }
            }
             
            star.fillColor = .lightGray
        }
    }
    
    private func themeDidChange() {
        backgroundColor = theme.background_color
        fillInStars()
    }
    
}

// https://stackoverflow.com/a/57450421
private class Star: UIView {
    
    var cornerRadius: CGFloat = 1.5 { didSet { setNeedsDisplay() } }
    var rotation: CGFloat = 54 { didSet { setNeedsDisplay() } }
    var fillColor: UIColor = .clear { didSet { setNeedsDisplay() } }
    
    init(_ size: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalToConstant: size)
        ])
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let r = rect.width / 2
        let rc = cornerRadius
        let rn = r * 0.95 - rc

        var cangle = rotation
        for i in 1 ... 5 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * cos(cangle * .pi / 180), y: center.y + rn * sin(cangle * .pi / 180))

            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * cos((cangle - 72) * .pi / 180),
                            y: cc.y + rc * sin((cangle - 72) * .pi / 180))

            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }

            // add 144 degree arc to draw the corner
            path.addArc(withCenter: cc,
                        radius: rc,
                        startAngle: (cangle - 72) * .pi / 180,
                        endAngle: (cangle + 72) * .pi / 180,
                        clockwise: true)

            cangle += 144
        }

        path.close()
        fillColor.setFill()
        path.fill()
    }
}

extension CGPoint {
    func rotate(around center: CGPoint, with degrees: CGFloat) -> CGPoint {
        let dx = self.x - center.x
        let dy = self.y - center.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + degrees * CGFloat(.pi / 180.0) // convert it to radians
        let x = center.x + radius * cos(newAzimuth)
        let y = center.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
}

/// :nodoc:
extension Double {
    public var isInt: Bool { rounded() == self }
}
