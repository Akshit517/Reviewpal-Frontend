import 'package:ReviewPal/core/network/internet/network_info.dart';
import 'package:ReviewPal/core/network/token/token_manager.dart';
import 'package:ReviewPal/core/network/token/token_refresher.dart';
import 'package:ReviewPal/features/auth/domain/repositories/user_repositories.dart';
import 'package:ReviewPal/features/auth/domain/usecases/login.dart';
import 'package:ReviewPal/features/auth/domain/usecases/get_token.dart';
import 'package:ReviewPal/features/auth/domain/usecases/register.dart';
import 'package:ReviewPal/features/workspaces/data/datasources/remote_data_source.dart';
import 'package:ReviewPal/features/workspaces/presentation/blocs/workspace/workspace_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../core/network/media/media_uploader.dart';
import '../core/network/token/token_http_client.dart';
import 'auth/data/datasources/user_local_data_source.dart';
import 'auth/data/datasources/user_remote_data_source.dart';
import 'auth/data/repositories/user_repositories_impl.dart';
import 'auth/domain/usecases/login_status_usecase.dart';
import 'auth/presentation/bloc/auth_bloc.dart';
import 'auth/presentation/cubit/login_status_cubit.dart';
import 'workspaces/data/repositories/repositories_impl.dart';
import 'workspaces/domain/repositories/workspace_repositories.dart';
import 'workspaces/domain/usecases/category/get_categories.dart';
import 'workspaces/domain/usecases/workspaces/create_worksapce.dart';
import 'workspaces/domain/usecases/workspaces/delete_workspace.dart';
import 'workspaces/domain/usecases/workspaces/get_joined_workspaces.dart';
import 'workspaces/domain/usecases/workspaces/get_workspace.dart';
import 'workspaces/domain/usecases/workspaces/update_workspace.dart';
import 'workspaces/presentation/blocs/category/category_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await dotenv.load(fileName: ".env");
  //bloc
  sl.registerFactory(() => AuthBloc(
      registerUseCase: sl(), loginUseCase: sl(), getTokenUseCase: sl()));
  sl.registerFactory(() => LoginStatusCubit(
        loginStatusUseCase: sl(),
  ));
  sl.registerFactory(() => WorkspaceBloc(
        getJoinedWorkspaces: sl(),
        getWorkspace: sl(),
        createWorkspace: sl(),
        updateWorkspace: sl(),
        deleteWorkspace: sl(),
  ));
  sl.registerFactory(() => CategoryBloc(
        getCategories: sl(),
  ));

  //feature [auth]
  initAuth();

  //feature [workspaces]
  initWorkspaces();

  //core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));
  sl.registerLazySingleton(() => TokenManager(secureStorage: sl()));  

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => TokenRefresher(tokenManager: sl(), client: sl()));
  sl.registerLazySingleton(() => TokenHttpClient(tokenManager: sl(), client: sl(), tokenRefresher: sl()));
  sl.registerLazySingleton(() => MediaUploader(tokenManager: sl(), tokenRefresher: sl()));

  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

// feature [auth]
void initAuth() {
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

// Feature [workspaces]
void initWorkspaces() {
  // Use Cases
  sl.registerLazySingleton<CreateWorkspace>(
      () => CreateWorkspace(sl()));
  sl.registerLazySingleton<DeleteWorkspace>(
      () => DeleteWorkspace(sl()));
  sl.registerLazySingleton<UpdateWorkspace>(
      () => UpdateWorkspace(sl()));
  sl.registerLazySingleton<GetWorkspace>(
      () => GetWorkspace(sl()));
  sl.registerLazySingleton<GetJoinedWorkspaces>(
      () => GetJoinedWorkspaces(sl()));
  sl.registerLazySingleton<GetCategories>(
      () => GetCategories(sl()));

  // Repositories
  sl.registerLazySingleton<WorkspaceRepositories>(() => WorkspaceRepositoryImpl(
        remoteDataSource: sl(),
        userLocalDataSource: sl()
      ));

  // DataSources
  sl.registerLazySingleton<WorkspaceRemoteDataSource>(
      () => WorkspaceRemoteDataSourceImpl(client: sl()));
}
