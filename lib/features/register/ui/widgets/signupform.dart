import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_feild.dart';
import '../../logic/register_cubit.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<RegisterCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          AppTextFormField(
            hintText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
            controller: context.read<RegisterCubit>().emailController,
          ),
          SizedBox(height: 8,),
          AppTextFormField(
            hintText: 'username',
            validator: (value) {
              if (value == null || value.isEmpty ) {
                return 'Please enter a valid username';
              }
              return null;
            },
            controller: context.read<RegisterCubit>().usernameController,
          ),
          SizedBox(height: 8,),
          AppTextFormField(
            hintText: 'phone ',
            validator: (value) {
              if (value == null || value.isEmpty ) {
                return 'Please enter a valid phone';
              }
              return null;
            },
            controller: context.read<RegisterCubit>().phoneController,
          ),


          SizedBox(height: 8,),
          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              bool isPasswordVisible = false;

              if (state is RegisterPasswordVisibilityToggled) {
                isPasswordVisible = state.isPasswordVisible;
              }

              return AppTextFormField(
                controller: context.read<RegisterCubit>().passwordController,
                hintText: 'Password',
                isObscureText: !isPasswordVisible,
                suffixIcon: GestureDetector(
                  onTap: () {
                    context
                        .read<RegisterCubit>()
                        .togglePasswordVisibility();
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    size: 24,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Please enter a valid password (at least 6 characters)';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
