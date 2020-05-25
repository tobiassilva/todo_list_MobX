import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todo_mobx/stores/login_store.dart';
import 'package:todo_mobx/widgets/custom_icon_button.dart';
import 'package:todo_mobx/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginStore loginStore;

  ReactionDisposer disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loginStore = Provider.of<LoginStore>(context);

    //(valor monitorado, efeito que ela causa)
    disposer = reaction(
      (_)=>loginStore.loggedIn,//diferente do autorun elle espera uma troca desse valor para executar
        //recebe o valor que foi modificado acima
      (value){
        if(loginStore.loggedIn){ //Se o login for realizado
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ListScreen())
          );
        }
      }
    );
    ///ele ira continuar executando, por isso é necessário dar um dispose

    // aguarda mudanças na variavel e  executa uma ação
    /*autorun((_){
      if(loginStore.loggedIn){ //Se o login for realizado
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ListScreen())
        );
      }
      print(loginStore.loggedIn);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(
                        builder: (_){
                          return CustomTextField(
                            hint: 'E-mail',
                            prefix: Icon(Icons.account_circle),
                            textInputType: TextInputType.emailAddress,
                            onChanged: loginStore.setEmail,
                            enabled: !loginStore.loading,
                          );
                        }
                    ),
                    const SizedBox(height: 16,),
                   Observer(
                     builder: (_){
                       return CustomTextField(
                         hint: 'Senha',
                         prefix: Icon(Icons.lock),
                         obscure: !loginStore.passwordVisible,
                         onChanged: loginStore.setPassword,
                         enabled: !loginStore.loading,
                         suffix: CustomIconButton(
                           radius: 32,
                           iconData: loginStore.passwordVisible ?
                           Icons.visibility_off : Icons.visibility,
                           onTap: loginStore.tooglePasswordVisibility,
                         ),
                       );
                     },
                   ),
                    const SizedBox(height: 16,),
                    Observer(
                      builder: (_){
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: loginStore.loading ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ) : Text('Login'),
                            color: Theme.of(context).primaryColor,
                            disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                            textColor: Colors.white,
                            onPressed: loginStore.loginPressed,
                          ),
                        );
                      }
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposer(); //cancela o reaction quando sair da página
    super.dispose();

  }

}
