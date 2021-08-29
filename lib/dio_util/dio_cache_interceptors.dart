import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter_dio/dio_util/dio_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class DioCacheInterceptors extends Interceptor {
  // 为确保迭代器顺序和对象插入时间一致顺序一致，我们使用LinkedHashMap
  var cache = LinkedHashMap<String, CacheObject>();
  // sp
  SharedPreferences preferences;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!DioUtil.CACHE_ENABLE) return super.onRequest(options, handler);
    // 是否刷新缓存
    bool refresh = options.extra["refresh"] == true;

    if (refresh) {
      // 删除本地缓存
      delete(options.uri.toString());
    }
    // 只有get请求才开启缓存
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        // 内存缓存
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            DioUtil.MAX_CACHE_AGE) {
          return handler.resolve(cache[key].response);
        } else {
          //若已过期则删除缓存，继续向服务器请求
          cache.remove(key);
        }

        // 磁盘缓存
      }

    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 把响应的数据保存到缓存
    if (DioUtil.CACHE_ENABLE) {
      _saveCache(response);
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
  }


  _saveCache(Response object) {
    RequestOptions options = object.requestOptions;
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // 如果缓存数量超过最大数量限制，则先移除最早的一条记录
      if (cache.length == DioUtil.MAX_CACHE_COUNT) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}