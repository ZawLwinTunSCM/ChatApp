import 'package:chat/entities/user.dart';
import 'package:chat/repositories/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final peopleStreamProvider = StreamProvider.autoDispose<List<User>>(
  (ref) => ref.watch(userRepositoryProvider).fetchAllUsers(),
);
