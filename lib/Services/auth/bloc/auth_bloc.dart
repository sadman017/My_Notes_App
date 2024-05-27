import 'package:bloc/bloc.dart';
import 'package:practice_app/Services/auth/auth_provider.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';
import 'package:practice_app/Services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()){
    on<AuthEventSendEmailVerification>((event, emit) async{
      await provider.sendEmailVerification();
    });
    on<AuthEventRegister>((event, emit) async{
      final email =event.email;
      final password = event.password;
      try{
        await provider.createUser(
          email: email, 
          password: password,
          );
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification());
      } on Exception catch(e){
        emit(AuthStateRegistering(e));
      } 
    });
    on<AuthEventInitialize>((event, emit )async{
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null){
        emit(const AuthStateLoggedOut(exception: null, isLoading:false,));
      } else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification());
      } else{
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async{
      emit(const AuthStateLoggedOut(exception: null, isLoading: true,));
      final email = event.email;
      final password =  event.password;
      try{
        final user = await provider.logIn(
          email: email, 
          password: password,
          );
          if(!user.isEmailVerified){
            emit(const AuthStateNeedsVerification());
          } else{
            emit(const AuthStateLoggedOut(exception: null, isLoading: false,));
             emit(AuthStateLoggedIn(user));
          }
      }on Exception catch(e){
        emit(AuthStateLoggedOut(isLoading: false, exception: e,));
      }
    });

    on<AuthEventLogOut>((event, emit) async{
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut(
        exception: null, 
        isLoading:false,
        ));
      }on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e,  isLoading: false,));
      }
    });
  }
}