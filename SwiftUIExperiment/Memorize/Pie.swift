//
//  Pie.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/9/20.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwize: Bool = false
    
    var animatableData: AnimatablePair<Double, Double> {
        set {
            startAngle = Angle(radians: newValue.first)
            endAngle = Angle(radians: newValue.second)
        }
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(x: center.x + radius * cos(CGFloat(startAngle.radians )), y:  center.y + radius * sin(CGFloat(startAngle.radians)))
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwize)
        p.addLine(to: center)
        return p
    }
}

struct Pie_Previews: PreviewProvider {
    static var previews: some View {
        Pie(startAngle: Angle(degrees: -45), endAngle: Angle(degrees: 270)).padding()
            .foregroundColor(Color.yellow)
    }
}
