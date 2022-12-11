part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}
class AvailableSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
class AvailableFailure extends AuthState {
  final String error;
  AvailableFailure({required this.error});
}
