# Pets

Hello,
I'm Cristian, an iOS developer boasting 8 years of experience in mobile development.
Pets is an iOS mobile app developed using the MVVM architecture pattern and RxSwift framework, integrating with the functionalities of the Petfinder API.

I crafted this sample app leveraging Xcode 15 and Swift 5.0. Throughout this assignment, I integrated various technologies and programming concepts, such as:
1. MVVM architecture
2. Coordinator pattern
3. Fundamental data structures
4. Server communication using URLSession
5. JSON parsing and decodable
6. Reactive programming using RxSwift and RxCocoa
7. Protocols delegates
8. Auto-layout (utilizing both XIB and programmatic constraints)
9. RxCocoa layout delegates
10. SwiftUI layout
11. Loaders implementation, load data, pull to refresh and load more
12. Unit testing with session mocking techniques
13. UI testing
14. Gernerics functions
15. Error handing
16. Dark and light theme
17. Keychain for safety local data management
18. Localizable strings for app internationalization
19. Dependency management using CocoaPods and Swift Package Manager (SPM)
20. GitHub for efficient version control
21. Media handling, pictures and videos

The sample Pets app showcases four distinct screens:
1. The Pets page: Upon opening the app, users are greeted with a list of pets, each displaying concise information alongside an optional image. By tapping on a pet cell, users are directed to a detailed page for that pet. At the top right corner of the screen, a settings button is conveniently located to navigate to the Settings page.
2. The Settings page: Here, users have access to various sorting and filtering options. Pets can be sorted by date and distance in ascending or descending order, and filtered by type, gender, location, and distance. The distance options are enabled only after selecting a specific location. After saving a set of sorting and filtering preferences, users are returned to the Pets page, where the pet list is adjusted according to the selected criteria. A placeholder text is displayed if no pets match the selected settings. Additionally, users have the option to reset the settings to their default values.
3. The Pet details page: This page provides comprehensive information about a specific pet. At the top, a carousel showcases all available media, including videos and images. Below the carousel is the header section, featuring the pet's title and posting date. The contact details section follows, displaying the full address, distance, and interactive contact options such as phone and email buttons. Next, pet tags are presented in a horizontal scroll view, followed by a detailed section containing all the pet's attributes.

For this project, I adopted diverse layout loading techniques - using SwiftUI, XIBs, RxCocoa, and programmatic constraints. While this may seem unconventional, my objective was to demonstrate versatility across varied methods. Typically, in a mainstream project, adhering to a singular standard and architectural pattern is essential.
Please note, due to specific Xcode configuration constraints, I recommend employing an Xcode version post 14 for optimal performance.

Thanks in advance.
