import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_feild.dart';
import '../../logic/login_cubit.dart';

class EmailAndPassword extends StatelessWidget {
  const EmailAndPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("E-mail",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(
            height: 8,
          ),
          AppTextFormField(
            controller: context.read<LoginCubit>().email,
            hintText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text("Password",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(
            height: 8,
          ),
          BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
            bool ispass = false;
            if (state is LoginpassToggle) {
              ispass = state.isPassvisable;
            }
            return AppTextFormField(
              hintText: "pass ",
              validator: (value) {
                if (value == null || value.length < 6) {
                  return "Password is empty or less than 6 characters";
                }
                return null; // Add this for valid inputs
              },
              controller: context.read<LoginCubit>().pass,
              isObscureText: !ispass,
              suffixIcon: IconButton(
                  onPressed: () {
                    context.read<LoginCubit>().togglepass();
                  },
                  icon: Icon(ispass ? Icons.visibility : Icons.visibility_off)),
            );
          })
        ],
      ),
    );
  }
}
