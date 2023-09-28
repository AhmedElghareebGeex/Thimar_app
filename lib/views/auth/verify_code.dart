import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thimar_app/core/design/app_button.dart';
import 'package:thimar_app/core/design/auth_header.dart';
import 'package:thimar_app/core/logic/helper_methods.dart';
import 'package:thimar_app/features/confirm_code/cubit.dart';
import 'package:thimar_app/features/confirm_code/states.dart';
import 'package:thimar_app/views/auth/login.dart';

class VerifyCode extends StatefulWidget {
  final bool isActive;
  final String phone;

  const VerifyCode({super.key, required this.isActive, required this.phone});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyCodeCubit(),
      child: Builder(
        builder: (context) {
          VerifyCodeCubit cubit = BlocProvider.of(context);
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
                        AuthHeader(
                          text1: widget.isActive
                              ? "تفعيل الحساب"
                              : "نسيت كلمة المرور",
                          text2: "أدخل الكود المكون من 4 أرقام المرسل علي رقم",
                        ),
                        Row(
                          children: [
                            Text(
                              "الجوال ${widget.phone}+",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF707070),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "تغيير رقم الجوال",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Form(
                          key: _formKey,
                          child: PinCodeTextField(
                            appContext: context,
                            length: 4,
                            controller: cubit.pinCodeController,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(15.r),
                              fieldHeight: 60.h,
                              fieldWidth: 70.w,
                              inactiveColor: const Color(0xffF3F3F3),
                              selectedColor: Theme.of(context).primaryColor,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "الحقل مطلوب";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          height: 37.h,
                        ),
                        BlocBuilder(
                          bloc: cubit,
                          builder: (context, state) {
                            if(state is VerifyCodeLoadingState){
                              return const Center(child: CircularProgressIndicator(),);
                            } else {
                              return AppButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.verify(
                                      isActive: widget.isActive,
                                      phone: widget.phone,
                                    );
                                  }
                                },
                                text: "تأكيد الكود",
                                radius: 15.r,
                                width: 343.w,
                                height: 60.h,
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
                        Text(
                          "لم تستلم الكود؟ \n يمكنك اعادة ارسال الكود بعد",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF707070),
                          ),
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        cubit.isTimerFinished
                            ? Center(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await cubit.resend(
                                      phone: widget.phone,
                                    );
                                    cubit.isTimerFinished = false;
                                    setState(() {});
                                  },
                                  child: Text(
                                    "إعادة إرسال",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : CircularCountDownTimer(
                                isReverse: true,
                                width: 66.w,
                                height: 69.h,
                                duration: 90,
                                fillColor: const Color(0xffD8D8D8),
                                ringColor: Theme.of(context).primaryColor,
                                strokeWidth: 3.w,
                                textFormat: CountdownTextFormat.MM_SS,
                                textStyle: TextStyle(
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor,
                                ),
                                isReverseAnimation: true,
                                onComplete: () {
                                  cubit.isTimerFinished = true;
                                  setState(() {});
                                },
                              ),
                        SizedBox(
                          height: 45.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "لديك حساب بالفعل ؟",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                  const LoginScreen(),
                                );
                              },
                              child: Text(
                                "تسجيل الدخول",
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
        },
      ),
    );
  }
}
