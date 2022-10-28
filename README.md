# AEP SDK Sample App for watchOS

## About this Project

This repository contains watchOS sample apps for the AEP SDK. Examples are provided for Swift implementation.

## Requirements

- Xcode 11.0 or newer
- Swift 5.1 or newer (Swift project only)
- Cocoapods 1.6 or newer

## Documentation
### Data Collection UI Prerequisites
Your tag property needs to be configured with the following extensions in Data Collection UI before it can be used: 
- [Edge](https://aep-sdks.gitbook.io/docs/foundation-extensions/experience-platform-extension)
- [Edge Identity](https://aep-sdks.gitbook.io/docs/foundation-extensions/identity-for-edge-network)
- [Consent](https://aep-sdks.gitbook.io/docs/foundation-extensions/consent-for-edge-network),
- [Adobe Journey Optimizer](https://aep-sdks.gitbook.io/docs/beta/adobe-journey-optimizer#configure-extension-in-launch)
 
 ### Running the app
Open the `aepsdk-sampleapp-watchOS.xcodeproj` inside the `aepsdk-sampleapp-watchOS` folder. Replace your `applicationId` from Data collection UI Tag Property in the `ExtensionDelegate.Swift`.
To connect to your Assurance session replace the `assuranceSessionUrl` in `AssuranceView.Swift` with your Assurance session url and `key` in `PinCodeView.Swift` with the Assurance session PIN.

## Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

## Licensing

This project is licensed under the MIT License. See [LICENSE](LICENSE) for more information.
