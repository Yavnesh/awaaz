// import 'package:awaazapp/app/credentials/cloudinary.credentials.dart';
// import 'package:awaazapp/meta/utils/pick_image.util.dart';
// import 'package:awaazapp/meta/utils/snack_bar.dart';
// import 'package:cloudinary_sdk/cloudinary_sdk.dart';
// import 'package:flutter/material.dart';
//
// class UtilityNotifier extends ChangeNotifier  {
//        String? _userimage;
//        String? get userimage => _userimage;
// // final ImageUtility _imageUtility = new ImageUtility();
//
//       Future uploadUserImage({
//   required BuildContext context
// }) async {
//         final _cloudinary = Cloudinary(CloudinaryCredentials.APIKEY, CloudinaryCredentials.APISecret, CloudinaryCredentials.APICLOUDNAME);
//         try {
//
//           final _image = await ImageUtility.getImage() ;
//           await _cloudinary.uploadFile(
//             filePath: _image!.path,
//             resourceType: CloudinaryResourceType.image,
//             folder: "awaaz"
//           ).then((value) {
//               _userimage = value.url;
//               notifyListeners();
//               return _userimage;
//           });
//         } catch (e) {
//           SnackbarUtility.showSnackBar(message: e.toString(), context: context);
//         }
//       }
// }