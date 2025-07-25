import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../comman/bold_text_style.dart';
import '../widgets/cus_text_field.dart';
import '../../../comman/elevated_button_style.dart';
import '../../../comman/simple_text_style.dart';
import '../../../constant/AppColour.dart';
import '../../../constant/ConPath.dart';
import '../bloc/auth_bloc.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _emailController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    setStatusBarColor();
  }

  void setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is ForgotPasswordState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Link sent to ${_emailController.text}',
                style: simple_text_style(color: AppColour.white,fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColour.green,
            ),
          );
        } else if (state is UserError) {
          setState(() => _error = state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColour.background,
        body: Stack(
          children: [
            Align(
              alignment: Alignment(-2.5, -1.4),
              child: SvgPicture.asset(
                back_vector_svg,
                color: AppColour.lightGrey.withOpacity(0.2),
                height: 250,
                width: 250,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(top: 20, left: 20),
                            decoration: BoxDecoration(
                              color: AppColour.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                size: 16,
                                Icons.arrow_back_ios_rounded,
                                color: AppColour.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Forgot Password',
                            style: bold_text_style(AppColour.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Please enter your email to reset your password',
                            style: simple_text_style(color: AppColour.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColour.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    padding: const EdgeInsets.all(22),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          cus_text_field(
                            'EMAIL',
                            _emailController,
                            'example@gmail.com',
                          ),
                          const SizedBox(height: 20),
                          if (_error != null)
                            Text(
                              _error!,
                              style: simple_text_style(color: AppColour.red),
                            ),
                          if (_error != null) const SizedBox(height: 20),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              if (state is UserLoading) {
                                return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: const CircularProgressIndicator(),
                                );
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<UserBloc>(
                                    context,
                                  ).add(SendVerificationCode(_emailController.text));
                                },
                                style: elevated_button_style(),
                                child: Text(
                                  'FORGOT PASSWORD',
                                  style: simple_text_style(
                                    color: AppColour.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
