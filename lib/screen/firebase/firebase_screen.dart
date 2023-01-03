import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<String?> signUp(String emailid,String userpassword)async
{

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailid,
      password: userpassword,
    );
    return "Success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return "Email already Exist";
    }
  } return "";

}

Future<String?> login(String email,String password)async
{
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return "Success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      return "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      return 'Wrong password provided for that user.';
    }
  }
  return "";
}

bool checkuser()
{
  User? user = FirebaseAuth.instance.currentUser;
  if(user!=null)
    {
      return true;
    }
  return false;

}

void logout()
{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  firebaseAuth.signOut();
}


Future<bool> googleLogin()async
{
  GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

  GoogleSignInAuthentication? authentication =  await googleSignInAccount?.authentication;

  var credential = GoogleAuthProvider.credential(accessToken: authentication?.accessToken ,idToken: authentication?.idToken);

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

   await FirebaseAuth.instance.signInWithCredential(credential);

   return checkuser();
}



Future<List<String?>> userProfile()async
{
  User? user = await FirebaseAuth.instance.currentUser;
  return[
    user!.email,
    user!.displayName,
    user!.photoURL,
  ];
}



void instertData(String id,String name, String mobile)
{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference collectionReference = firebaseFirestore.collection("Student");
  collectionReference.add({"id": id, "name": name , "mobile": mobile}).then((value) => print("Success")).catchError((error)=>print("Error $error"));
}


Stream<QuerySnapshot<Map<String, dynamic>>> readData()
{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  return firebaseFirestore.collection("Student").snapshots();
}


void deleteData(String key)
{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  firebaseFirestore.collection("Student").doc("$key").delete();
}

void updateData(String key ,String id , String name , String mobile )async
{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  firebaseFirestore.collection("Student").doc("$key").set({"id": "$id" , "name" : "$name" , "mobile" : "$mobile"});
}
