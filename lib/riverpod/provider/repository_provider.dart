import 'package:flutter_base/riverpod/mvi/repository/home_repository.dart';
import 'package:flutter_base/riverpod/mvi/repository/login_repository.dart';
import 'package:flutter_base/riverpod/provider/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginRepository = Provider(
  (ref) => LoginRepository(apiService: ref.watch(apiServiceProvider)),
);

final homeRepository = Provider(
  (ref) => HomeRepository(apiService: ref.watch(apiServiceProvider)),
);
