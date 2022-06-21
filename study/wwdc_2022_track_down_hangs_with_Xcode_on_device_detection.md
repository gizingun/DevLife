Track down hangs with Xcode and on-device detection
=============

### What are hangs

- Laggy & not respond to any of touches
- Apple call this period of unresponsiveness a "**hang**"
- App's main thread : responsible for processing user interaction and updating the view content
- Hang, unresponsive >= 250ms

![What is hang](/study/resources/what_is_hang.png)

- In hang, main thread is also unabailable to process new user action
- Frequently unresponsive app -> Force quits, Switch apps, Delete your app
- Ref. [[Understand and eliminate hangs from your app](https://developer.apple.com/videos/play/wwdc2021/10258)] from wwdc 2021
- Before iOS16 & Xcode 14
  - MetricKit : collect nonaggregated hang rate metrics and diagnostic reports from individuals (beta or public release app)
  - Xcode Metrics Organizer : collect aggregated hang rate maetric from public released app

![Before iOS16 & Xcode 14](/study/resources/before_ios_16.png)

- In iOS16 & Xcode
  - Thread Performance Checker
  - Instruments (Hang detection)

![In iOS16 & Xcode 14](/study/resources/in_iOS16.png)

### Development tooling

##### Thread Performance Checker
- Notifies in Xcode Issue navigator : priority inversion, non-UI work on the main thread
  - [Priority Inversion 참고](https://sujinnaljin.medium.com/ios-%EC%B0%A8%EA%B7%BC%EC%B0%A8%EA%B7%BC-%EC%8B%9C%EC%9E%91%ED%95%98%EB%8A%94-gcd-15-3fef697f9aab)

![Thread performance checker example in priority inversion](/study/resources/thread_performance_checker_example.png)

- Activate Thread performance checker
  - Edit Sheme > Run > Diagnostics > Thread performance checker on!
- More detail... know to the other thread was doing during the hang duration **Use "Time Profiler instruments"**
  - In Xcode 14, Time profiler instruments detect hangs and labels it directly

- Label hang

![Time profiler example](/study/resources/time_profiler_hang_label.png)

- Detail thread

![Time profiler example detail](/study/resources/time_profiler_hang_label_detail.png)

##### Hang tracing instruments
- hang detection & labeling
- configure a hang dration threshold

### Beta tooling
- on-device hang detection (without Xcode connection) in developer settings
- available for development-signed or TestFlight apps
- on/off, threshold, target, hang noti log
- these diagnostics are in the background at a low priority
- less information. but, give us an understanding of the hang at a glance

![On-device hang detection](/study/resources/on_device_hang_detection.png)


### Public release tooling
##### Xcode Organizer [Hang reports]
- The collected data is from customers which have consented to share app analytics
- Contain information about the main thread stack
- similar stack traces are collected -> grouped togerher [Signature]
- the code responsible for the hang, the hang duration, device and OS version
- each signature provides statistics (counts, a breakdown of those logs by OS Version and device)
- Hang log is readable (because App Store with symbol infomation)
- Can retrieve the same hang report data (through App Store Connect REST APIs)

![Hang report](/study/resources/hang_report.png)

##### Submitting symbols
- Improve Xcode Organizer experience
- Only essential information extracted
- Securely stored and never shared


### Wrap-up
- Fix hangs early
- Enable Thread Performance Checker
- Enable on-device hang detection
- Use hang report regularly
- Enable regression notification
- Submit symbols
