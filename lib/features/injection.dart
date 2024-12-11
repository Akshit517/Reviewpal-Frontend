import 'package:ReviewPal/core/network/internet/network_info.dart';
import 'package:ReviewPal/core/network/token/token_manager.dart';
import 'package:ReviewPal/features/auth/domain/repositories/user_repositories.dart';
import 'package:ReviewPal/features/auth/domain/usecases/login.dart';
import 'package:ReviewPal/features/auth/domain/usecases/get_token.dart';
import 'package:ReviewPal/features/auth/domain/usecases/register.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import 'auth/data/datasources/user_local_data_source.dart';
import 'auth/data/datasources/user_remote_data_source.dart';
import 'auth/data/repositories/user_repositories_impl.dart';
import 'auth/domain/usecases/login_status_usecase.dart';
import 'auth/presentation/bloc/auth_bloc.dart';
import 'auth/presentation/cubit/login_status_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await dotenv.load(fileName: ".env");
  //bloc
  sl.registerFactory(() => AuthBloc(
      registerUseCase: sl(), loginUseCase: sl(), getTokenUseCase: sl()));
  sl.registerFactory(() => LoginStatusCubit(
        loginStatusUseCase: sl(),
  ));

  //feature [auth]
  _init_auth();

  //core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));
  sl.registerLazySingleton(() => TokenManager(secureStorage: sl()));  

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

// feature [auth]
void _init_auth() {
  // Use Cases
  sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(userRepositories: sl()));
  sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(userRepositories: sl()));
  sl.registerLazySingleton<GetTokenUseCase>(
      () => GetTokenUseCase(userRepositories: sl()));
  sl.registerLazySingleton<LoginStatusUseCase>(
    () => LoginStatusUseCase(userRepositories: sl()),
  );

  //Repositories
  sl.registerLazySingleton<UserRepositories>(() => UserRepositoriesImpl(
      localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  //DataSources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(secureStorage: sl(), tokenManager: sl()));
}
