import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msnchat/features/login/logic/login_cubit.dart';
import 'package:msnchat/features/login/ui/widgets/donthaveacc.dart';
import 'package:msnchat/features/login/ui/widgets/emailandpassweord.dart';
import '../../../core/network_services/firebase_sevice.dart';
import '../../../core/utils/routes.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/backgroundwaves.dart';
import '../../../core/widgets/button_app.dart';
import '../../../core/widgets/button_google.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(FirebaseService()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFeliuer) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.errom),
              backgroundColor: Colors.red,
            ));
          }
          if (state is LoginSuces) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("succes"),
              backgroundColor: Colors.green,
            ));
            Navigator.pushReplacementNamed(context, Routes.homeScreen);
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
              child: SafeArea(
                  child: Stack(children: [
            const CustomBackground(),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 300),
                    Text("Login your Account",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            )),
                    const SizedBox(height: 20),
                    EmailAndPassword(),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.forgetpass);
                          },
                          child: Text("Forget Password ?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsManager.mainBlue))),
                    ),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Column(
                          children: [
                            AppTextButton(
                              buttonText: "Login",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                              onPressed: () {
                                final formKey =
                                    context.read<LoginCubit>().formKey;
                                if (formKey.currentState != null &&
                                    formKey.currentState!.validate()) {
                                  context.read<LoginCubit>().login();
                                }
                              },
                            ),
                            GoogleSignInButton(
                              onPressed: () {
                                context.read<LoginCubit>().loginWithGoogle();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    DontHaveAccountText(),
                  ],
                )),
          ]))),
        ),
      ),
    );
  }
}
