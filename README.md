MatchMate - Matrimonial Card Interface

Overview
This project, MatchMate, is a matrimonial card interface application developed for iOS. It is designed to display profile matches with details such as name, age, location, and status (pending, accepted, or declined), utilizing Core Data for persistent storage.
Technology Stack

Language: Swift
Framework: UIKit
Dependency Management: CocoaPods
Persistent Storage: Core Data
Version: Built with Xcode 15.0 and iOS 15.0 deployment target (as specified in the Podfile).

Implementation Details
The application is implemented using the UIKit framework, providing a native iOS user interface with a table view to list profile matches. The project structure follows the MVVM (Model-View-ViewModel) architecture for better separation of concerns, with models managing data, view models handling business logic, and views displaying the UI. Core Data is used to persistently store profile information, ensuring data availability even offline, managed through a PersistenceController and the ProfileData entity.
Dependencies are managed through CocoaPods, allowing for easy integration of libraries. The initial plan included using SDWebImage for image loading, but due to permission issues, this was replaced with local assets.
Challenges Encountered
During development, an attempt was made to use SDWebImage for asynchronous image downloading and caching. However, permission issues arose, preventing successful integration. The specific error encountered was:

Error: mkpathat: Operation not permitted when building the project, linked to the SDWebImage.framework/SDWebImage.bundle/ path.
Cause: This issue stemmed from the project being stored in a OneDrive-synced directory (/Users/singhpal/Library/CloudStorage/OneDrive-adidas/Desktop/MatchMate), where file permissions restricted access. Attempts to copy the project to a local directory (e.g., ~/Desktop/MatchMate_local) failed with errors like cp: ... Permission denied due to nested Pods directory path length limitations (name too long) and ongoing OneDrive sync interference.
Resolution: SDWebImage was removed from the Podfile, and local images (e.g., profile_image in Assets.xcassets) were used instead to bypass the permission constraints.

Setup Instructions

Ensure CocoaPods is installed (gem install cocoapods).
Navigate to the project directory: /Users/singhpal/Library/CloudStorage/OneDrive-adidas/Desktop/MatchMate.
Run pod install to set up dependencies.
Open MatchMate.xcworkspace in Xcode.
Build and run the project (Cmd+R).

Future Improvements

Add support for dynamic image loading if permission issues are resolved.
Enhance the MVVM structure with additional view models or services.
Improve UI with custom cells or animations.

Author

Name: Singhal, Pallak
Date: September 28, 2025
