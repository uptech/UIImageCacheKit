import Foundation

internal class WeakWrapper<T> {
    internal var value: T?

    internal init(_ value: T?) {
        self.value = value
    }
}
