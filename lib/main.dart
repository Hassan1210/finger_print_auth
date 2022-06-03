import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyButton(),
    );
  }
}

class MyButton extends StatefulWidget {

  const MyButton({Key? key}) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  String ok = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(ok.toString()),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: ()async{
                if(await FingerPrint.authenticate()){
                  setState(() { ok = "Authentication Successful"; });

                }
                else{
                  print("NO");
                }
              },
              child: Text("click Here"),
            ),
          ],
        ),
      ),
    );
  }
}

class FingerPrint{

  static final auth = LocalAuthentication();

  static Future<bool>hasFingerPrint()async{
    try{
      return await auth.canCheckBiometrics;
    }on PlatformException catch(e){
      return false;
    }
  }

  static Future<bool> authenticate() async{

    bool isAvailable = await hasFingerPrint();
    if(!isAvailable){
      return false;
    }

    try{
      return await auth.authenticate(
          localizedReason: 'Please authenticate to login',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
          stickyAuth: true,
          )
      );
    } on PlatformException catch (e){
      print(e);
      return false;
    }
  }

}