import 'package:flutter/widgets.dart';
import 'package:university_modules/src/module_descriptor.dart';
import 'package:university_modules/src/module_host.dart';

abstract interface class UniversityModule {
  ModuleDescriptor get descriptor;
  Widget build(ModuleHost host);
}
