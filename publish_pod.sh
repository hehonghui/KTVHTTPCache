#! /bin/bash

# 参考文章: https://developer.aliyun.com/article/231391
# 1. 发布对应版本的tag到github
# 2. 执行:  pod spec lint KTVHTTPCacheV2.podspec  --verbose  命令校验pod
# 3. 发布pod:  pod trunk push  KTVHTTPCacheV2.podspec

echo "发布新的Pod..."

pod trunk push  KTVHTTPCacheV2.podspec
