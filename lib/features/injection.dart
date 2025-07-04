import 'package:ReviewPal/features/workspaces/data/datasources/chat_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../core/infrastructure/http/token_manager.dart';
import '../core/infrastructure/http/token_refresher.dart';
import '../core/infrastructure/media/media_uploader.dart';
import '../core/infrastructure/http/token_http_client.dart';
import '../core/network/network_info.dart';
import 'auth/data/datasources/user_local_data_source.dart';
import 'auth/data/datasources/user_remote_data_source.dart';
import 'auth/data/repositories/user_repositories_impl.dart';
import 'auth/domain/repositories/user_repositories.dart';
import 'auth/domain/usecases/get_token.dart';
import 'auth/domain/usecases/login.dart';
import 'auth/domain/usecases/login_status_usecase.dart';
import 'auth/domain/usecases/logout.dart';
import 'auth/domain/usecases/profile.dart';
import 'auth/domain/usecases/register.dart';
import 'auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'auth/presentation/cubit/login_status_cubit.dart';
import 'workspaces/data/datasources/remote_data_source.dart';
import 'workspaces/data/repositories/chat_repository.dart';
import 'workspaces/data/repositories/repositories_impl.dart';
import 'workspaces/domain/repositories/chat_repository.dart';
import 'workspaces/domain/repositories/workspace_repositories.dart';
import 'workspaces/domain/usecases/category/category_member.dart';
import 'workspaces/domain/usecases/category/create_category.dart';
import 'workspaces/domain/usecases/category/delete_category.dart';
import 'workspaces/domain/usecases/category/get_categories.dart';
import 'workspaces/domain/usecases/category/update_category.dart';
import 'workspaces/domain/usecases/channels/channel_member.dart';
import 'workspaces/domain/usecases/channels/create_channel.dart';
import 'workspaces/domain/usecases/channels/delete_channel.dart';
import 'workspaces/domain/usecases/channels/get_channels.dart';
import 'workspaces/domain/usecases/channels/update_channel.dart';
import 'workspaces/domain/usecases/chat/chat_usecase.dart';
import 'workspaces/domain/usecases/iteration/create_review_iteration.dart';
import 'workspaces/domain/usecases/iteration/get_reviewee_iteration.dart';
import 'workspaces/domain/usecases/iteration/get_reviewer_iteration.dart';
import 'workspaces/domain/usecases/submission/create_submission.dart';
import 'workspaces/domain/usecases/submission/submission.dart';
import 'workspaces/domain/usecases/workspaces/create_worksapce.dart';
import 'workspaces/domain/usecases/workspaces/delete_workspace.dart';
import 'workspaces/domain/usecases/workspaces/get_joined_workspaces.dart';
import 'workspaces/domain/usecases/workspaces/get_workspace.dart';
import 'workspaces/domain/usecases/workspaces/update_workspace.dart';
import 'workspaces/domain/usecases/workspaces/workspace_member.dart';
import 'workspaces/presentation/blocs/category/category_bloc/category_bloc.dart';
import 'workspaces/presentation/blocs/category/member/category_member_bloc.dart';
import 'workspaces/presentation/blocs/channel/channel_bloc/channel_bloc.dart';
import 'workspaces/presentation/blocs/channel/member/channel_member_bloc.dart';
import 'workspaces/presentation/blocs/channel/single_member/single_channel_member_cubit.dart';
import 'workspaces/presentation/blocs/chat/chat_bloc.dart';
import 'workspaces/presentation/blocs/iteration/iteration_bloc.dart';
import 'workspaces/presentation/blocs/submission/submission_bloc.dart';
import 'workspaces/presentation/blocs/workspace/member/workspace_member_bloc.dart';
import 'workspaces/presentation/blocs/workspace/single_member/single_workspace_member_cubit.dart';
import 'workspaces/presentation/blocs/workspace/workspace_bloc/workspace_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //bloc
  sl.registerFactory(() => AuthBloc(
      registerUseCase: sl(),
      loginUseCase: sl(),
      getTokenUseCase: sl(),
      logoutUseCase: sl()));
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
  sl.registerFactory(() => WorkspaceMemberBloc(
      getWorkspaceMembersUseCase: sl(),
      addWorkspaceMemberUseCase: sl(),
      deleteWorkspaceMemberUseCase: sl(),
      updateWorkspaceMemberUseCase: sl()));
  sl.registerFactory(
      () => SingleWorkspaceMemberCubit(getWorkspaceMemberUseCase: sl()));
  sl.registerFactory(() => CategoryBloc(
        getCategories: sl(),
        createCategory: sl(),
        updateCategoryUseCase: sl(),
        deleteCategoryUseCase: sl(),
      ));
  sl.registerFactory(() => CategoryMemberBloc(
        addCategoryMemberUseCase: sl(),
        getCategoryMembersUseCase: sl(),
        deleteCategoryMemberUseCase: sl(),
      ));
  sl.registerFactory(() => ChannelBloc(
      getChannels: sl(),
      createChannel: sl(),
      updateChannel: sl(),
      deleteChannel: sl()));
  sl.registerFactory(
      () => SingleChannelMemberCubit(getChannelMemberUseCase: sl()));
  sl.registerFactory(() => ChannelMemberBloc(
      getChannelMembersUseCase: sl(),
      addChannelMemberUseCase: sl(),
      deleteChannelMemberUseCase: sl(),
      updateChannelMemberUseCase: sl()));
  sl.registerFactory(() => SubmissionBloc(
        getSubmission: sl(),
        createSubmission: sl(),
        getSubmissionByTeamId: sl(),
      ));
  sl.registerFactory(() => IterationBloc(
        createReviewerIteration: sl(),
        getReviewerIterations: sl(),
        getRevieweeIterations: sl(),
      ));
  //feature [auth]
  initAuth();

  //feature [workspaces]
  initWorkspaces();

  initChat();

  //core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));
  sl.registerLazySingleton(() => TokenManager(secureStorage: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(
      () => TokenRefresher(tokenManager: sl(), client: sl()));
  sl.registerLazySingleton(() =>
      TokenHttpClient(tokenManager: sl(), client: sl(), tokenRefresher: sl()));
  sl.registerLazySingleton(
      () => MediaUploader(tokenManager: sl(), tokenRefresher: sl()));
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
  sl.registerLazySingleton<FetchProfileUseCase>(
    () => FetchProfileUseCase(userRepositories: sl()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(userRepositories: sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(userRepositories: sl()),
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
  sl.registerLazySingleton<CreateWorkspace>(() => CreateWorkspace(sl()));
  sl.registerLazySingleton<DeleteWorkspace>(() => DeleteWorkspace(sl()));
  sl.registerLazySingleton<UpdateWorkspace>(() => UpdateWorkspace(sl()));
  sl.registerLazySingleton<GetWorkspace>(() => GetWorkspace(sl()));
  sl.registerLazySingleton<GetJoinedWorkspaces>(
      () => GetJoinedWorkspaces(sl()));
  sl.registerLazySingleton<GetWorkspaceMemberUseCase>(
      () => GetWorkspaceMemberUseCase(repository: sl()));
  sl.registerLazySingleton<GetWorkspaceMembersUseCase>(
      () => GetWorkspaceMembersUseCase(repository: sl()));
  sl.registerLazySingleton<AddWorkspaceMemberUseCase>(
      () => AddWorkspaceMemberUseCase(repository: sl()));
  sl.registerLazySingleton<DeleteWorkspaceMemberUseCase>(
      () => DeleteWorkspaceMemberUseCase(repository: sl()));
  sl.registerLazySingleton<UpdateWorkspaceMemberUseCase>(
      () => UpdateWorkspaceMemberUseCase(repository: sl()));
  sl.registerLazySingleton<GetCategories>(() => GetCategories(sl()));
  sl.registerLazySingleton<UpdateCategoryUseCase>(
      () => UpdateCategoryUseCase(repository: sl()));
  sl.registerLazySingleton<DeleteCategory>(() => DeleteCategory(sl()));
  sl.registerLazySingleton<CreateCategory>(() => CreateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategoryMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryMembersUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddCategoryMemberUseCase(repository: sl()));

  sl.registerLazySingleton<CreateChannelUseCase>(
      () => CreateChannelUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateChannelUseCase(workspaceRepositories: sl()));
  sl.registerLazySingleton(() => DeleteChannelUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChannelsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChannelMembersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChannelMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddChannelMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteChannelMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateChannelMemberUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateSubmissionUseCase(repository: sl()));
  sl.registerLazySingleton(
      () => GetSubmissionByTeamIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSubmissionUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetReviewerIteration(sl()));
  sl.registerLazySingleton(() => GetRevieweeIterations(sl()));
  sl.registerLazySingleton(() => CreateReviewIteration(sl()));
  // Repositories
  sl.registerLazySingleton<WorkspaceRepositories>(() => WorkspaceRepositoryImpl(
      remoteDataSource: sl(), userLocalDataSource: sl()));

  // DataSources
  sl.registerLazySingleton<WorkspaceRemoteDataSource>(
      () => WorkspaceRemoteDataSourceImpl(client: sl()));
}

void initChat() {
  sl.registerLazySingleton<GroupChatRemoteDataSource>(
    () => GroupChatRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
        remoteDataSource: sl(), networkInfo: sl(), userLocalDataSource: sl()),
  );
  sl.registerLazySingleton<ChatUsecase>(
    () => ChatUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => ChatBloc(
      chatUsecase: sl(),
    ),
  );
}
