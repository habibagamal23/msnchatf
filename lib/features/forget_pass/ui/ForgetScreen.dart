import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network_services/firebase_sevice.dart';
import '../../../core/widgets/backgroundwaves.dart';
import '../../../core/widgets/button_app.dart';
import '../../../core/widgets/custom_feild.dart';
import '../logic/resetpass_cubit.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetpassCubit(FirebaseService()),
      child: BlocListener<ResetpassCubit, ResetpassState>(
        listener: (context, state) {
          if (state is ResetpassSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ResetpassFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: BlocBuilder<ResetpassCubit, ResetpassState>(
                builder: (context, state) {
                  final cubit = context.read<ResetpassCubit>();
                  return Stack(
                    children: [
                      const CustomBackground(),
                      Positioned(
                        top: 20,
                        left: 10,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.of(context)
                                .pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 300),
                            Text(
                              "Reset Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Please enter your email address to receive a password reset link.",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 30),

                            // Email Form
                            Form(
                              key: cubit.formKey,
                              child: AppTextFormField(
                                hintText: 'Email',
                                controller: cubit
                                    .emailController,
                                validator: (value) {
                                  if (value == null || !value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            BlocBuilder<ResetpassCubit, ResetpassState>(
                              builder: (context, state) {
                                if (state is ResetpassLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return AppTextButton(
                                  buttonText: "Send Reset Email",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: Colors.white),
                                  onPressed: () {
                                    cubit.sendPasswordResetEmail();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
