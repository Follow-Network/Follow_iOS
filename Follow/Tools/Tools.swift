//
//  Tools.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - URLParametersListSerializable protocol

protocol URLParametersSerializable {
    
    var asURLParameters: [URLParameter] { get }
}

// MARK: - NSUserDefault

extension UserDefaults {
    
    class func performOnce(forKey key: String, perform: () -> Void, elsePerform: (() -> Void)? = nil) {
        let once = self.standard.object(forKey: key)
        self.standard.set(true, forKey: key)
        self.standard.synchronize()
        if once == nil { perform() }
        else { elsePerform?() }
    }
}

// MARK: - Reactive protocol

protocol ReactiveDisposable {
    
    var disposeBag: DisposeBag { get }
}

// MARK: - TextStyle extension

extension TextStyle {
    
    var attributes: [NSAttributedString.Key: AnyObject] {
        return [NSAttributedString.Key.font: self.font, NSAttributedString.Key.foregroundColor: self.color]
    }
}

// MARK: - UILabel extension

extension UILabel {
    
    func apply(style: TextStyle) {
        self.font = style.font
        self.textColor = style.color
    }
}

// MARK: - Key window

extension UIApplication {
    
    static var window: UIWindow? {
        guard let delegate = self.shared.delegate else { return nil }
        return delegate.window ?? nil
    }
}

func unique<S: Sequence, E: Hashable>(source: S) -> [E] where E==S.Iterator.Element {
    var seen: [E:Bool] = [:]
    return source.filter { seen.updateValue(true, forKey: $0) == nil }
}

// MARK: - UIEdgeInsets

extension UIEdgeInsets {
    
    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
}
