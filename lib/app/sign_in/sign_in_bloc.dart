import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:neighborhood/services/auth.dart';


class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>(); //init stream
  Stream<bool> get isLoadingStream => _isLoadingController.stream; //input stream for the streambuilder

  void dispose() {
    _isLoadingController.close();
  }

  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);//add value of isLoading to stream

  Future<User> signInWithGoogle() async {
    try{
      setIsLoading(true);
      return await auth.signInWithGoogle();
    } catch(e){
      rethrow;
    }finally {
      setIsLoading(false);
    }
  }

  Future<User> signInWithFacebook() async{
    try{
      setIsLoading(true);
      return await auth.signInWithFacebook();
    } catch(e){
      rethrow;
    }finally {
      setIsLoading(false);
    }
  }

}