# Tinkoff Messenger [![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/komour/TinkoffMessenger/blob/master/LICENSE)

## Educational project for [Fintech Tinkoff iOS course](https://fintech.tinkoff.ru/study/fintech/ios/).

1. Application and ViewController LifeCycle (to run in debug mode (with logs) select TinkoffMessengerDebug scheme, otherwise - TinkoffMessenger scheme)
2. Profile screen UI
3. Chat list and dialogue screen UI via `UITableView`
4. Memory Management playground (understanding how to work without retain cycles)  
5. Read/Write data from files (profile picture, name, description) using `GCD` and `Operation`  
6. Fetching/Adding data to `Firebase`, creating new channels
7. Save/Load profile data using CoreData
8. Channel and message caching via CoreData. NSFetchedResultsController - in process
9. Architecture (SOA, MVC) - ?
10. Ability to select avatars from the network via `UICollectionView` and `URLSessionTask`  
11. SendButton state transition animations. (animation effect with Tinkoff logo during touching the screen in any area - not done)
12. Sorting channels Unit tests via `XCTest`