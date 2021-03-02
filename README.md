# SocketIOClient

[![Rz Rasel](https://raw.githubusercontent.com/arzrasel/svg/main/rz-rasel-blue.svg)](https://github.com/rzrasel)
[![CI Status](https://img.shields.io/travis/Rashed/SocketIOClient.svg?style=flat)](https://travis-ci.org/Rashed/SocketIOClient)
[![Version](https://img.shields.io/cocoapods/v/SocketIOClient.svg?style=flat)](https://cocoapods.org/pods/SocketIOClient)
[![License](https://img.shields.io/cocoapods/l/SocketIOClient.svg?style=flat)](https://cocoapods.org/pods/SocketIOClient)
[![Platform](https://img.shields.io/cocoapods/p/SocketIOClient.svg?style=flat)](https://cocoapods.org/pods/SocketIOClient)
[![GitHub release](https://img.shields.io/github/tag/arzrasel/SocketIOClient.svg)](https://github.com/arzrasel/SocketIOClient/releases)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-11.4-blue.svg)](https://developer.apple.com/xcode)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 11
- Swift 5
- Xcode 12

## Installation

SocketIOClient is available through [CocoaPods](https://cocoapods.org/pods/SocketIOClient). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SocketIOClient'
```

or

```SocketIOClientMain
pod 'SocketIOClient', '~> 0.1'
```

## Integration In Project

```IntegrationInProject
import SocketIOClient
```

## SocketIOClient declaration

```SocketIOClientDeclaration
let socketIOManager = SocketIOManager(isLog: true)
```

## SocketIOClient setup

```
func setupIncoming() {
    //Initial setup
    socketIOManager.params(key: "SOCKET_AUTH_KEY", value: "SOCKET_AUTH_TOKEN")
        .with(url: AppConstant.HTTP.API.SOCKET_IO)
    socketIOManager.prepareConnection()
    //Socket response setup
    //Response One
    socketIOManager.socketOn(name: "SOCKET_KEY_ONE") {name, data, ack in
        print("Socket key name: \(name), socket data: \(data)")
    }
    socketIOManager.socketOn(name: "SOCKET_KEY_TWO") {name, data, ack in
        print("Socket key name: \(name), socket data: \(data)")
    }
    //...
    /*
    //As many as you have need
    */
}
```

## SocketIOClient setup

```
let emitData = [
    "key": "value",
    "key": "value",
    "key": "value",
    "key": "value"
    //....
]
socketIOManager.emit(name: "SOCKET_KEY_ONE", params: emitData)
```

## Author

Md. Rashed - Uz - Zaman (Rz Rasel)

## License

SocketIOClient is available under the MIT license. See the LICENSE file for more info.
