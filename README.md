# Mono Prove iOS SDK

The Mono Prove SDK is a quick and secure way to onboard your users from within your iOS app. Mono Prove is a customer onboarding product that offers businesses faster customer onboarding and prevents fraudulent sign-ups, powered by the MDN and facial recognition technology.

For accessing customer accounts and interacting with Mono's API (Identity, Transactions, Income, DirectPay) use the server-side [Mono API](https://docs.mono.co/docs).

## Documentation

For complete information about Mono Prove, head to the [docs](https://docs.mono.co/docs).


## Getting Started

1. Register on the [Mono](https://app.mono.com) website and get your public and secret keys.
2. Retrieve a `sessionId` for a customer by calling the [initiate endpoint](https://docs.mono.co/api) 

## Installation

### Manual

Get the latest version of ProveKit and embed it into your application.

Go to File -> Add Package Dependencies...

Then enter the URL for this package `https://github.com/withmono/prove-ios.git` and select the most recent version.

## Requirements

- Xcode 12.5 or greater
- iOS 12.0 or greater
- The latest version of the ProveKit
- Add the key `Privacy - Camera Usage Description` and a usage description to your `Info.plist`.

If editing `Info.plist` as text, add:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
```

## To build without Rosetta
To resolve the missing architecture issue when building on M1 and M2 Macs, please follow these instructions, particularly when building for simulator devices:

    1. Add the two architectures, i386 and x86_64, to your project's settings.
    2. Set the "Build Active Architecture Only" flag to "Yes".

By adding these architectures and configuring the "Build Active Architecture Only" setting, you ensure that your project is compatible with both the Intel-based and Apple Silicon-based Macs, enabling successful builds on simulator devices.

## Usage

#### Import ProveKit
```swift
import ProveKit
```

#### Create a ProveConfiguration
```swift
let configuration = ProveConfiguration(
  sessionId: "PRV...",
  onSuccess: {
    print("Success")
 })
```

#### Initialize a ProveKit Widget
```swift
let widget = ProveKit.create(configuration: configuration)
```

#### Show the Widget
```swift
self.present(widget, animated: true, completion: nil)
```
## Configuration Options

- [`sesssionId`](#sesssionId)
- [`onSuccess`](#onSuccess)
- [`onClose`](#onClose)
- [`onEvent`](#onEvent)
- [`reference`](#reference)

### <a name="sesssionId"></a> `sesssionId`
**String: Required**

This is the session ID returned after calling the [initiate endpoint](https://docs.mono.co/api).

```swift
let configuration = ProveConfiguration(
  sessionId: "PRV...",
  onSuccess: {
    print("Success")
 })
```

### <a name="onSuccess"></a> `onSuccess`
**(() -> Void): Required**

The closure is called when a user has successfully verified their identity.

```swift
let configuration = ProveConfiguration(
  sessionId: "PRV...",
  onSuccess: {
    print("Successfully verified")
  }
)
```

### <a name="onClose"></a> `onClose`
**(() -> Void): Optional**

The optional closure is called when a user has specifically exited the Mono Prove flow. It does not take any arguments.

```swift
configuration.onClose = { () in
  print("Widget closed.")
}
```
### <a name="onEvent"></a> `onEvent`
**((_ event: ProveEvent) -> Void): Optional**

This optional closure is called when certain events in the Mono Prove flow have occurred, for example, when the user opens or closes the widget. This enables your application to gain further insight into what is going on as the user goes through the Mono Prove flow.

See the [ProveEvent](#ProveEvent) object below for details.

```swift
configuration.onEvent = { (event) -> Void in
  print(event.eventName)
}
```

### <a name="reference"></a> `reference`
**String: Optional**

When passing a reference to the configuration it will be provided back to you on all onEvent calls.

```swift
configuration.reference = "random_reference_string"
```

## API Reference

### ProveKit Object

The ProveKit Object exposes the `ProveKit.create(config: ProveConfiguration)` method that takes a [ProveConfiguration](#ProveConfiguration) for easy interaction with the Mono Prove Widget.

### <a name="ProveConfiguration"></a> ProveConfiguration

The configuration option is passed to ProveKit.create(config: ProveConfiguration).

```swift
sessionId: String // required
onSuccesss: () -> Void // required
onClose: (() -> Void?)? // optional
onEvent: ((_ event: ProveEvent) -> Void?)? // optional
reference: String // optional
```
#### Usage

```swift
let configuration = ProveConfiguration( // required parameters go in the initializer
  sessionId: "PRV...",
  onSuccess: {
    print("Success")
  }
)
// optional parameters can be added as so
configuration.onEvent = { (event) -> Void in
  print(event.eventName)
}
configuration.onClose = { () -> Void in
  print("Widget closed.")
}
configuration.reference = "random_string"

````

### <a name="proveEvent"></a> ProveEvent

#### <a name="eventName"></a> `eventName: String`

Event names correspond to the `type` key returned by the event data. Possible options are in the table below.

| Event Name           | Description                                                   |
|----------------------|---------------------------------------------------------------|
| OPENED               | Triggered when the user opens the Prove Widget.               |
| CLOSED               | Triggered when the user closes the Prove Widget.              |
| IDENTITY_VERIFIED     | Triggered when the user successfully verifies their identity. |
| ERROR                | Triggered when the widget reports an error.                   |


#### <a name="dataObject"></a> `data: ProveData`
The data object of type ProveData returned from the onEvent callback.

```swift
type: String // type of event mono.prove.xxxx
reference: String? // reference passed through the prove config
pageName: String? // name of page the widget exited on
errorType: String? // error thrown by widget
errorMessage: String? // error message describing the error
timestamp: Date // timestamp of the event as a Date object
```


## Examples

#### Usage with UIKit

```swift
import UIKit
import ProveKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func ShowProveWidget(_ sender: UIButton) {
    let configuration = ProveConfiguration(
      sessionId: "PRV...",
      onSuccess: {
        print("Successfully verified")
      })

    configuration.onEvent = { (event) -> Void in
      print(event.eventName)
      print(event.data.timestamp)
    }

    configuration.onClose = { () in
      print("Widget closed.")
    }

    let widget = ProveKit.create(configuration: configuration)

    self.present(widget, animated: true, completion: nil)
  }
}
```

#### Usage with SwiftUI

```swift
import SwiftUI
import UIKit
import ProveKit

struct ContentView: View {
    @State private var isPresented: Bool = false

    var body: some View {
        VStack {
            Text("Mono Prove")
                .font(.title)
                .bold()

            Button("Open Mono Prove") {
                isPresented = true
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $isPresented) {
            ProveWidgetView(onSuccess: {
                dismiss()
                print("Successfully verified")
            }) {
                dismiss()
            }
        }
    }

    func dismiss() {
        isPresented = false
    }
}

struct ProveWidgetView: UIViewControllerRepresentable {
    let onSuccess: (() -> Void?)
    let onClose: (() -> Void?)?

    func makeUIViewController(context: Context) -> UIViewController {
        let configuration = ProveConfiguration(
            sessionId: "PRV...",
            onSuccess: onSuccess,
            onClose: onClose
        )

        let widget = ProveKit.create(configuration: configuration)

        return widget
    }

    func updateUIViewController(
        _ uiViewController: UIViewController, context: Context
    ) {}
}
```

## Support
If you're having general trouble with Mono Prove iOS SDK or your Mono integration, please reach out to us at <support@mono.co> or come chat with us on [Slack](https://join.slack.com/t/devwithmono/shared_invite/zt-gvkqczzk-Ldt4FQpHtOL7FFTqh4Ux6A). We're proud of our level of service, and we're more than happy to help you out with your integration to Mono.

## Contributing
If you would like to contribute to the Mono Prove iOS SDK, please make sure to read our [contributor guidelines](https://github.com/withmono/prove-ios/tree/main/CONTRIBUTING.md).


## License

[MIT](https://github.com/withmono/prove-ios/tree/main/LICENSE) for more information.
