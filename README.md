# KTVHTTPCache

KTVHTTPCache is a powerful media cache framework. It can cache HTTP request, and very suitable for media resources.


## Flow Chart

![KTVHTTPCache Flow Chart](http://libobjc-libs.oss-cn-beijing.aliyuncs.com/Resource/KTVHTTPCache-flow-chart-thin.jpeg)


## Features

- Thread safety.
- Keep proxy server alive when app enter background.
- Logging system, Support for console and file output.
- Accurate view caching information.
- Provide different levels of interface.
- Adjust the download configuration.


## Installation

#### Installation with CocoaPods

To integrate KTVHTTPCache into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
pod 'KTVHTTPCacheV2', '~> 2.0.4'
```

Run `pod install`




## Usage

- Start proxy.

```objc
[KTVHTTPCache proxyStart:&error];
```

- Generated proxy URL.

```objc
NSURL *proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:originalURL];
AVPlayer *player = [AVPlayer playerWithURL:proxyURL];
```

- Get the complete cache file URL if existed.

```objc
NSURL *completeCacheFileURL= [KTVHTTPCache cacheCompleteFileURLWithURL:originalURL];
```

- Set the URL filter processing mapping relationship.

```objc
[KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
    return URL;
}];
```


- Keep proxy server alive when app enter background.

```objc
// keep proxy server alive when app goes into background
[KTVHTTPCache keepAliveInBackground:YES];
```


- Download Configuration

```objc
// Timeout interval.
[KTVHTTPCache downloadSetTimeoutInterval:30];

// Accept Content-Type.
[KTVHTTPCache downloadSetAcceptableContentTypes:contentTypes];

// Set unsupport Content-Type filter.
[KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
    return NO;
}];

// Additional headers.
[KTVHTTPCache downloadSetAdditionalHeaders:headers];

// Whitelist headers.
[KTVHTTPCache downloadSetWhitelistHeaderKeys:headers];
```

- Log.

```objc
// Console.
[KTVHTTPCache logSetConsoleLogEnable:YES];

// File.
[KTVHTTPCache logSetRecordLogEnable:YES];
NSString *logFilePath = [KTVHTTPCache logRecordLogFilePath];
```


## License

KTVHTTPCache is released under the MIT license.


## Feedback

- GitHub : [Single](https://github.com/libobjc)
- Email : libobjc@gmail.com


## Developed by Single

- [SGPlayer](https://github.com/libobjc/SGPlayer) - A powerful media player framework for iOS, macOS, and tvOS.
- [KTVVideoProcess](https://github.com/ChangbaDevs/KTVVideoProcess) - A High-Performance video effects processing framework.

