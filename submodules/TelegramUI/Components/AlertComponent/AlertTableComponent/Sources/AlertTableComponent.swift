import Foundation
import UIKit
import AsyncDisplayKit
import Display
import ComponentFlow
import TelegramPresentationData
import AlertComponent
// import TableComponent // LEAN: removed

// LEAN: TableComponent stub (removed module)
public struct TableComponent: Component {
    public typealias EnvironmentType = Empty
    
    public struct Item: Equatable {
        public static func == (lhs: Item, rhs: Item) -> Bool {
            return false // stub
        }
    }
    
    let theme: Any
    let items: [Item]
    let semiTransparent: Bool
    
    public init(theme: Any, items: [Item], semiTransparent: Bool) {
        self.theme = theme
        self.items = items
        self.semiTransparent = semiTransparent
    }
    
    public static func ==(lhs: TableComponent, rhs: TableComponent) -> Bool {
        return lhs.items == rhs.items
    }
    
    public final class View: UIView {
        func update(component: TableComponent, availableSize: CGSize, state: EmptyComponentState, environment: Environment<Empty>, transition: ComponentTransition) -> CGSize {
            return CGSize(width: availableSize.width, height: 0)
        }
    }
    
    public func makeView() -> View {
        return View()
    }
    
    public func update(view: View, availableSize: CGSize, state: State, environment: Environment<EnvironmentType>, transition: ComponentTransition) -> CGSize {
        return view.update(component: self, availableSize: availableSize, state: state, environment: environment, transition: transition)
    }
}

public final class AlertTableComponent: Component {
    public typealias EnvironmentType = AlertComponentEnvironment
    
    let items: [TableComponent.Item]
    
    public init(
        items: [TableComponent.Item]
    ) {
        self.items = items
    }
    
    public static func ==(lhs: AlertTableComponent, rhs: AlertTableComponent) -> Bool {
        if lhs.items != rhs.items {
            return false
        }
        return true
    }
    
    public final class View: UIView {
        private let table = ComponentView<Empty>()
        
        private var component: AlertTableComponent?
        private weak var state: EmptyComponentState?
        
        func update(component: AlertTableComponent, availableSize: CGSize, state: EmptyComponentState, environment: Environment<AlertComponentEnvironment>, transition: ComponentTransition) -> CGSize {
            self.component = component
            self.state = state
            
            let environment = environment[AlertComponentEnvironment.self]
            
            let tableSize = self.table.update(
                transition: transition,
                component: AnyComponent(
                    TableComponent(
                        theme: environment.theme,
                        items: component.items,
                        semiTransparent: true
                    )
                ),
                environment: {},
                containerSize: CGSize(width: availableSize.width + 20.0, height: availableSize.height)
            )
            let tableFrame = CGRect(origin: CGPoint(x: -10.0, y: 5.0), size: tableSize)
            if let tableView = self.table.view {
                if tableView.superview == nil {
                    self.addSubview(tableView)
                }
                transition.setFrame(view: tableView, frame: tableFrame)
            }
            return CGSize(width: availableSize.width, height: tableSize.height + 10.0)
        }
    }
    
    public func makeView() -> View {
        return View(frame: CGRect())
    }
    
    public func update(view: View, availableSize: CGSize, state: EmptyComponentState, environment: Environment<AlertComponentEnvironment>, transition: ComponentTransition) -> CGSize {
        return view.update(component: self, availableSize: availableSize, state: state, environment: environment, transition: transition)
    }
}
