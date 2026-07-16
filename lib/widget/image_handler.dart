import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

/// 图片处理
/// 根据预览页缩放原图
/// 根据预览框裁剪图片
/// 思路:1.根据预览页缩放原图获取Rect
///     2.根据预览框获取Rect
///     3.直接在原图上裁剪Rect

class ImageHandler {
  Future<String> cropImage({
    required String src,
    required String target,
    required Size previewSize,
    required Rect cropRect,
  }) async {
    try {
      img.Image? srcImage = await img.decodeImageFile(src);
      if (srcImage == null) {
        return src;
      }
      // 校正图片
      srcImage = img.bakeOrientation(srcImage);

      // 图片的宽高
      final imgWidth = srcImage.width;
      final imgHeight = srcImage.height;

      // 预览宽高
      final preWidth = previewSize.width;
      final preHeight = previewSize.height;

      // 计算预图片按 短边 等比缩放比例
      final scale2Preview = max(preWidth / imgWidth, preHeight / imgHeight);

      // 获取图片缩放后预览图宽高
      final scalePreviewWidth = preWidth / scale2Preview;
      final scalePreviewHeight = preHeight / scale2Preview;

      // 获取预览图坐标
      final previewLeft = (imgWidth - scalePreviewWidth) / 2;
      final previewTop = (imgHeight - scalePreviewHeight) / 2;

      // 获取裁剪框在预览界面中的比例
      final cropRatioLeft = cropRect.left / preWidth;
      final cropRatioTop = cropRect.top / preHeight;
      final cropRatioWidth = cropRect.width / preWidth;
      final cropRatioHeight = cropRect.height / preHeight;

      // 获取裁剪框在原图的坐标
      final cropX = (previewLeft + scalePreviewWidth * cropRatioLeft).toInt();
      final cropY = (previewTop + scalePreviewHeight * cropRatioTop).toInt();
      final cropWidth = (scalePreviewWidth * cropRatioWidth).toInt();
      final cropHeight = (scalePreviewHeight * cropRatioHeight).toInt();

      // 边界检查
      final safeX = cropX.clamp(0, imgWidth - 1);
      final safeY = cropY.clamp(0, imgHeight - 1);
      final safeWith = cropWidth.clamp(1, imgWidth - safeX);
      final safeHeight = cropHeight.clamp(1, imgHeight - safeY);

      //开始裁剪
      final cropImg = img.copyCrop(
        srcImage,
        x: safeX,
        y: safeY,
        width: safeWith,
        height: safeHeight,
      );
      final result = await img.encodeJpgFile(target, cropImg, quality: 80);
      if (result == true) {
        return target;
      }
    } catch (_) {}
    return src;
  }
}
