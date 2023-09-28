import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thimar_app/core/design/app_button.dart';
import 'package:thimar_app/core/design/app_input.dart';
import 'package:thimar_app/core/design/auth_header.dart';
import 'package:thimar_app/core/logic/helper_methods.dart';
import 'package:thimar_app/features/login/cubit.dart';
import 'package:thimar_app/features/login/states.dart';
import 'package:thimar_app/views/auth/forget_password.dart';
import 'package:thimar_app/views/auth/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Builder(
          builder: (context) {
        LoginCubit cubit = BlocProvider.of(context);
        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/images/logo/bg.svg",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    children: [
                      const AuthHeader(
                        text1: "مرحبا بك مرة أخرى",
                        text2: "يمكنك تسجيل الدخول الأن",
                      ),
                      SizedBox(
                        height: 28.h,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppInput(
                              controller: cubit.phoneNumberController,
                              labelText: "رقم الجوال",
                              isPhone: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "حقل رقم الجوال مطلوب";
                                }
                                return null;
                              },
                              prefixIcon:
                                  "assets/images/icons/appInputIcons/call.svg",
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            AppInput(
                              controller: cubit.passwordController,
                              labelText: "كلمة المرور",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "حقل كلمة المرور مطلوب";
                                }
                                return null;
                              },
                              prefixIcon:
                                  "assets/images/icons/appInputIcons/lock.svg",
                              keyboardType: TextInputType.visiblePassword,
                              isPassword: true,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 19.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            navigateTo(
                              ForgetPassword(
                                phone: cubit.phoneNumberController.text,
                              ),
                            );
                          },
                          child: Text(
                            "هل نسيت كلمة المرور؟",
                            style: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      BlocBuilder(
                        bloc: cubit,
                        builder: (context, state) {
                          if(state is LoginLoadingState)
                          {
                            return Center(child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),);
                          } else {
                            return AppButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.userLogin();
                                }
                              },
                              text: "تسجيل الدخول",
                              radius: 15.r,
                              height: 60.h,
                              width: 343.w,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 45.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ليس لديك حساب ؟",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(
                                const RegisterScreen(),
                              );
                            },
                            child: Text(
                              "تسجيل الأن",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
