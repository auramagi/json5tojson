extension Optional {
    func unwrapOrThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case let .some(wrapped):
            return wrapped
            
        case .none:
            throw error()
        }
    }
}

extension String: Error { }
