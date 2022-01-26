
class DioResponse<T> {

  /// 消息(例如成功消息文字/错误消息文字)
  final String? message;
  /// 自定义code(可根据内部定义方式)
  final int? code;
  /// 接口返回的数据
  final T? data;
  /// 需要添加更多
  /// .........

  DioResponse({
    this.message,
    this.data,
    this.code,
  });

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"message\":\"$message\"");
    sb.write(",\"errorMsg\":\"$code\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}

class DioResponseCode {
  /// 成功
  static const int SUCCESS = 0;
  /// 错误
  static const int ERROR = 1;
  /// 更多
}