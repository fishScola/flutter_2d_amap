abstract class AMap2DController {
  /// city：cityName（中文或中文全拼）、cityCode均可
  Future<void> search(String keyWord, {String city = ''});

  Future<void> move(String lat, String lon);

  Future<void> location();

  /// 设置地图缩放级别
  /// [zoomLevel] 缩放级别，范围：[2, 20]
  Future<void> setZoom(double zoomLevel);

  /// 放大地图
  Future<void> zoomIn();

  /// 缩小地图
  Future<void> zoomOut();
}
