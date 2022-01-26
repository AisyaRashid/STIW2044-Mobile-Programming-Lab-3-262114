import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab3_26114/model/config.dart';
import 'package:lab3_26114/model/product.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class UpdatePage extends StatefulWidget {
  final Product product;
  const UpdatePage({Key? key, required this.product}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  double screenHeight = 0.0, screenWidth = 0.0;
  File? _image;
  var pathAsset = "assets/images.png";
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final TextEditingController _prnameEditingController = TextEditingController();
  final TextEditingController _prdescEditingController = TextEditingController();
  final TextEditingController _prpriceEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prnameEditingController.text = widget.product.prname.toString();
    _prdescEditingController.text = widget.product.prdesc.toString();
    _prpriceEditingController.text = widget.product.prprice.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Product"),
      ),
      body: Column(
        children: [
          Flexible(
              flex: 5,
              child: GestureDetector(
                onTap: _uploadImage,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Card(
                    child: Container(
                        decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? NetworkImage(MyConfig.server + "/lab3_26114/images/products/${widget.product.prid.toString()}.png")
                            : FileImage(_image!) as ImageProvider,
                        fit: BoxFit.scaleDown,
                      ),
                    )),
                  ),
                ),
              )),
          Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Edit Product",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Product name must be longer than 3"
                                : null,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus);
                            },
                            controller: _prnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Product Name',
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.cake,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Product description must be longer than 3"
                                : null,
                            focusNode: focus,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus1);
                            },
                            maxLines: 4,
                            controller: _prdescEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Product Description',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.cake,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                            TextFormField(
                                  textInputAction: TextInputAction.next,
                                  validator: (val) => val!.isEmpty
                                      ? "Product price must contain value"
                                      : null,
                                  focusNode: focus1,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus2);
                                  },
                                  controller: _prpriceEditingController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Product Price',
                                      labelStyle: TextStyle(),
                                      icon: Icon(
                                        Icons.cake,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                                      const SizedBox(
                                    height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(screenWidth, screenHeight / 13)),
                          child: const Text('Update Product'),
                          onPressed: () => {_updateProductDialog(),}
                          
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _uploadImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 5, screenHeight / 10)),
                  child: const Text('Gallery'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectfromGallery(),
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth / 5, screenHeight / 10)),
                  child: const Text('Camera'),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                ),
              ],
            ));
      },
    );
  }
  
  Future<void> _selectfromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,

              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.blueGrey,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _updateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update this product",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateProduct();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
    _updateProduct() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _prname = _prnameEditingController.text;
    String _prdesc = _prdescEditingController.text;
    String _prprice = _prpriceEditingController.text;

    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Updating product.."),
        title: const Text("Processing..."));
    progressDialog.show();

    if(_image == null){
    http.post(Uri.parse(MyConfig.server + "/lab3_26114/php/updateproduct.php"), 
    body: {
      "prid": widget.product.prid,
      "prname": _prname,
      "prdesc": _prdesc,
      "prprice": _prprice,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      }else{
         Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
    progressDialog.dismiss();
    }else{
    String base64Image = base64Encode(_image!.readAsBytesSync());
    http.post(Uri.parse(MyConfig.server + "/lab3_26114/php/updateproduct.php"), 
    body: {
      "prid": widget.product.prid,
      "prname": _prname,
      "prdesc": _prdesc,
      "prprice": _prprice,
      "image": base64Image,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      }else{
         Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
    progressDialog.dismiss();
    }
    }
}
