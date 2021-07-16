Pod::Spec.new do |s|
  s.name                = "KTVHTTPCacheV2"
  s.version             = "2.0.2"
  s.summary             = "A powerful media cache framework."
  s.homepage            = "https://github.com/hehonghui/KTVHTTPCache"
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.author              = { "Single" => "simplecoder.h@gmail.com" }
  s.social_media_url    = "https://github.com/hehonghui"
  s.platform            = :ios, "8.0"
  s.source              = { :git => "https://github.com/hehonghui/KTVHTTPCache.git", :tag => "#{s.version}" }
  s.source_files        = "KTVHTTPCache", "KTVHTTPCache/**/*.{h,m}"
  s.public_header_files =
                          "KTVHTTPCache/KTVHTTPCache.h",
                          "KTVHTTPCache/Classes/KTVHCCommon/KTVHCRange.h",
                          "KTVHTTPCache/Classes/KTVHCDataStorage/KTVHCDataReader.h",
                          "KTVHTTPCache/Classes/KTVHCDataStorage/KTVHCDataLoader.h",
                          "KTVHTTPCache/Classes/KTVHCDataStorage/KTVHCDataRequest.h",
                          "KTVHTTPCache/Classes/KTVHCDataStorage/KTVHCDataResponse.h",
                          "KTVHTTPCache/Classes/KTVHCDataStorage/KTVHCDataCacheItem.h",
                          "KTVHTTPCache/Classes/KTVHCDataStorage/KTVHCDataCacheItemZone.h"
  s.frameworks          = "UIKit", "Foundation"
  s.requires_arc        = true
  s.dependency 'KTVCocoaHTTPServer'
end
