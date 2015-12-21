# SwiftRequests
Simple, yet powerful, network requester for Swift.

## Usage
```swift
// request url as string
SwiftRequests.send("http://www.asdf.com", thru: SwiftRequests.StringParser, to: { response in
    switch response {
    case .success(let string):
        print("got: \(string)")
    case .error(let message, let code):
        print("error: \(message), code:\(code)")
    }
})

// request url as image
SwiftRequests.send("http://bit.ly/1P9l8ys", thru: SwiftRequests.ImageParser, to: { response in
    switch response {
        case .success(let image):
        print("got: \(image)")
    case .error(let message, let code):
        print("error: \(message), code:\(code)")
    }
})
```
