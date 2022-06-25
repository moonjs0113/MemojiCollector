<h1 align="center">
    <img style="height:50px; vertical-align:middle; border-radius:10px;" src="readmeSource/AppIcon.png"/> Memoji Collector
</h1>

[![Swift Version][swift-image]](https://swift.org/)
[![Platform][Platform-image]](https://developer.apple.com/kr/ios/)
![Version][Version-image]

[swift-image]:https://img.shields.io/badge/swift-5.6-orange.svg?style=flat
[Platform-image]: https://img.shields.io/badge/Platform-ios-lightgray.svg?style=flat
[Version-image]: https://img.shields.io/badge/Version-1.0-blue.svg?style=flat


<center>

| <div style="height:500px"> ![AppStoreImage](readmeSource/AppImage_0.PNG)</div> | <div style="height:500px"> ![AppStoreImage](readmeSource/AppImage_1.PNG) </div> | 
| - | - |   

</center>

# App Description
```
당신의 미모지를 공유하세요!
여러 사람들과 소통하고, 미모지를 교환하면서 내적 친밀감을 향상 시킬 수 있습니다!
```

# Requirments
- iOS 15.0+
- Xcode 13.0+

# Dependency
<table width=100%>
    <thead>
        <tr>
            <th><strong>Manager</strong></th>
            <th><strong>Dependecy</strong></th>
            <th><strong>Version</strong></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="5">Swift Package Manager</td>
            <td>Firebase(firebase-ios-sdk)</td>
            <td>8.9.1</td>
        </tr>
    </tbody>
</table>

# Features
## Project Structure
```
MemojiCollector
├── App
│   ├── AppDelegate.swift
│   ├── AppStorageKey.swift
│   ├── Launch Screen.storyboard
│   └── MemojiCollectorApp.swift
├── Delegate
│   └── MemojiTextViewDelegate.swift
├── Extension
│   ├── IntroView+Extension.swift
│   ├── NSTextAttachment+Extension.swift
│   ├── String+Extension.swift
│   └── UITextView+Extension.swift
├── Manager
│   └── JsonManager.swift
├── Model
│   └── MemojiCardModel.swift
├── View
│   ├── CardDetail
│   │   ├── MemojiDetailView.swift
│   │   └── SelectGroupView.swift
│   ├── CardView
│   │   ├── DeletedCardView.swift
│   │   ├── EmptyCardView.swift
│   │   ├── MakeCardView.swift
│   │   ├── MemojiCardView.swift
│   │   └── TempMemojiCardView.swift
│   ├── Main
│   │   ├── FilterGroupView.swift
│   │   ├── GridCardView.swift
│   │   ├── GuideView.swift
│   │   ├── IntroView.swift
│   │   └── MainView.swift
│   ├── MyMemoji
│   │   ├── ActivityViewController.swift
│   │   ├── MakeMemojiCardView.swift
│   │   ├── MyMemojiView.swift
│   │   ├── QRCodeView.swift
│   │   └── RegisterUserView.swift
│   └── Setting
│       ├── ChangeNameView.swift
│       ├── GroupView.swift
│       ├── Password
│       │   ├── LockView.swift
│       │   ├── PasswordView_.swift
│       │   └── SetPasswordView.swift
│       ├── ResetView.swift
│       └── SettingView.swift
└── ViewModel
    ├── CardDetailViewModel
    │   └── MemojiDetaillViewModel.swift
    ├── MainViewModel.swift
    ├── MemojiCardViewModel.swift
    ├── MyMemojiViewModel
    │   ├── MakeMemojiViewModel.swift
    │   └── MyMemojiViewModel.swift
    ├── PasswordViewModel.swift
    └── SettingViewModel
        ├── GroupViewModel.swift
        └── SettingViewModel.swift
```

# API
## Document
[Firebase Cloud Storage](https://firebase.google.com/docs/storage/ios/start?hl=ko) 
