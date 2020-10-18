//
//  TripleToggle.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/11/20.
//

import SwiftUI

// https://gist.github.com/swiftui-lab/4469338fd099285aed2d1fd00f5da745
// MARK: - TripleToggle View
public struct TripleToggle: View {
    @Environment(\.tripleToggleStyle) var style: AnyTripleToggleStyle
    
    let label: Text
    @Binding var tripleState: TripleState
    
    public var body: some View {
        
        let configuration = TripleToggleStyleConfiguration(tripleState: self._tripleState, label: label)
        
        return style.makeBody(configuration: configuration)
    }
}

// MARK: - Custom Environment Key
extension EnvironmentValues {
    var tripleToggleStyle: AnyTripleToggleStyle {
        get {
            return self[TripleToggleKey.self]
        }
        set {
            self[TripleToggleKey.self] = newValue
        }
    }
}

public struct TripleToggleKey: EnvironmentKey {
    public static let defaultValue: AnyTripleToggleStyle = AnyTripleToggleStyle(DefaultTripleToggleStyle())
}

// MARK: - View Extension
extension View {
    public func tripleToggleStyle<S>(_ style: S) -> some View where S : TripleToggleStyle {
        self.environment(\.tripleToggleStyle, AnyTripleToggleStyle(style))
    }
}

// MARK: - Type Erased TripleToggleStyle
public struct AnyTripleToggleStyle: TripleToggleStyle {
    private let _makeBody: (TripleToggleStyle.Configuration) -> AnyView
    
    init<ST: TripleToggleStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }
    
    public func makeBody(configuration: TripleToggleStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

// MARK: - TripleToggleStyle Protocol
public protocol TripleToggleStyle {
    associatedtype Body : View
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = TripleToggleStyleConfiguration
}

extension TripleToggleStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

public struct TripleToggleStyleConfiguration {
    @Binding var tripleState: TripleState
    var label: Text
}

public enum TripleState: Int {
    case low
    case med
    case high
}

// MARK: - DefaultTripleToggleStyle
public struct DefaultTripleToggleStyle: TripleToggleStyle {
    
    public func makeBody(configuration: Self.Configuration) -> DefaultTripleToggleStyle.DefaultTripleToggle {
        DefaultTripleToggle(state: configuration.$tripleState, label: configuration.label)
    }
    
    public struct DefaultTripleToggle: View {
        let width: CGFloat = 50

        @Binding var state: TripleState
        var label: Text
        
        var stateAlignment: Alignment {
            switch self.state {
            case .low: return .leading
            case .med: return .center
            case .high: return .trailing
            }
        }

        var stateColor: Color {
            switch self.state {
            case .low: return .green
            case .med: return .yellow
            case .high: return .red
            }
        }

        public var body: some View {
            VStack(spacing: 10) {
                label
                                
                ZStack(alignment: self.stateAlignment) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: self.width, height: self.width / 2)
                        .foregroundColor(self.stateColor)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: (self.width / 2) - 4, height: self.width / 2 - 6)
                        .padding(4)
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                switch self.state {
                                case .low:
                                    self.$state.wrappedValue = .med
                                case .med:
                                    self.$state.wrappedValue = .high
                                case .high:
                                    self.$state.wrappedValue = .low
                                }
                            }
                    }
                }
            }
        }
    }
}

// MARK: - KnobTripleToggleStyle
public struct KnobTripleToggleStyle: TripleToggleStyle {
    let dotColor: Color
    
    public func makeBody(configuration: Self.Configuration) -> KnobTripleToggleStyle.KnobTripleToggle {
        KnobTripleToggle(dotColor: dotColor, state: configuration.$tripleState, label: configuration.label)
    }
    
    public struct KnobTripleToggle: View {
        let dotColor: Color

        @Binding var state: TripleState
        var label: Text
        
        var angle: Angle {
                switch self.state {
                case .low: return Angle(degrees: -30)
                case .med: return Angle(degrees: 0)
                case .high: return Angle(degrees: 30)
            }
        }

        public var body: some View {
            let g = Gradient(colors: [.white, .gray, .white, .gray, .white, .gray, .white])
            let knobGradient = AngularGradient(gradient: g, center: .center)
            
            return VStack(spacing: 10) {
                label
                                
                ZStack {
                    
                    Circle()
                        .fill(knobGradient)
                    
                    DotShape()
                        .fill(self.dotColor)
                        .rotationEffect(self.angle)
                    
                }.frame(width: 150, height: 150)
                    .onTapGesture {
                        withAnimation {
                            switch self.state {
                            case .low:
                                self.$state.wrappedValue = .med
                            case .med:
                                self.$state.wrappedValue = .high
                            case .high:
                                self.$state.wrappedValue = .low
                            }
                        }
                }
            }
        }
    }
    
    struct DotShape: Shape {
        func path(in rect: CGRect) -> Path {
            return Path(ellipseIn: CGRect(x: rect.width / 2 - 8, y: 8, width: 16, height: 16))
        }
    }
}
