import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/screens/signup_screen.dart';

import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_input_field.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController =TextEditingController();

bool _isLoading = false;

@override
  void dispose() {
   
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser()async{

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);

    if(res == "success"){

         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout())));

 
    }else{
     
      showSnackBar(res, context);
   
    }
    
    setState(() {
      _isLoading = false;
    });

  }

  void navigateToSignup(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Container(),
          flex: 2,),
          // svg image
          SvgPicture.asset('assets/ic_instagram.svg',
          color: primaryColor, height: 64,),
          // text field input for email
          const SizedBox(height: 64,),
          TextInputField(
            textEditingController: _emailController, 
            hintText: 'Enter your email',
             textInputType: TextInputType.emailAddress
             ),
const SizedBox(height: 24,),
          // text field input for password
           TextInputField(
            textEditingController: _passwordController, 
            hintText: 'Enter your password',
             textInputType: TextInputType.text,
             isPass: true
             ),
             const SizedBox(height: 24,),
          // button login
          InkWell(
            onTap: loginUser,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4)
                )
              ),
               color: blueColor,
              ),
             
              child: _isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),): const Text('Log in'),
            ),
          ),
          const SizedBox(height: 24,),
          // Transitioning to signing up
            Flexible(child: Container(),
          flex: 2,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Don't have an account?"),
              ),
               GestureDetector(
                onTap:navigateToSignup,
                 child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Sign up.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                             ),
               ),
            ],
          )
        ],
      ),
    )),
    );
  }
}