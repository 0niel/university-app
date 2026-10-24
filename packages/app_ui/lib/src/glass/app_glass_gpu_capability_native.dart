import 'package:flutter_gpu/gpu.dart' as gpu;

bool supportsFlutterGpu() {
  try {
    gpu.gpuContext.defaultColorFormat;
    return true;
  } on Object {
    return false;
  }
}
