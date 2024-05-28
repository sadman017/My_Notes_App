import 'package:bloc/bloc.dart';
import 'package:practice_app/Services/auth/auth_provider.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';
import 'package:practice_app/Services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(AuthProvider provider) 
  : super(const AuthStateUninitialized(isLoading: true)){
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
          emit(const AuthStateNeedsVerification(isLoading: false,));
      } on Exception catch(e){
        emit(AuthStateRegistering(exception: e, isLoading: false,));
      } 
    });
    on<AuthEventShouldRegister>((event, emit) async{
      
    });
    on<AuthEventInitialize>((event, emit )async{
      await provider.initialize();
      final user = provider.currentUser;
      if(user == null){
        emit(const AuthStateLoggedOut(exception: null, isLoading:false,));
      } else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification(isLoading: false,));
      } else{
        emit(AuthStateLoggedIn(user:user, isLoading: false,));
      }
    });

    on<AuthEventLogIn>((event, emit) async{
      emit(const AuthStateLoggedOut(
       exception: null,
       isLoading: true,
       loadingText: "Please wait until log in",
       ));
      final email = event.email;
      final password =  event.password;
      try{
        final user = await provider.logIn(
          email: email, 
          password: password,
          );
          if(!user.isEmailVerified){
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else{
            emit(const AuthStateLoggedOut(exception: null, isLoading: false,));
             emit(AuthStateLoggedIn(user:user, isLoading: false,));
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