import 'package:flutter_base/riverpod/mvi/http/api_service.dart';
import 'package:flutter_base/riverpod/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider((_) => AppRouter());

final apiServiceProvider = Provider((_) => ApiService());
