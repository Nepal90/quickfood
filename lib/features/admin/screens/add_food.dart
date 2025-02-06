import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:barcode/barcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickfood/features/admin/screens/admin_dashboard.dart';
import 'package:quickfood/widgets/AppWidgets.dart';
import 'package:quickfood/widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemTypeController = TextEditingController();
  final TextEditingController itemQuantityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<Uint8List> convertSvgToPng(String svgData) async {
    try {
      final DrawableRoot svgRoot = await svg.fromSvgString(svgData, svgData);
      final picture = svgRoot.toPicture(size: const Size(200, 80));
      final image = await picture.toImage(200, 80);

      final ByteData? pngBytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (pngBytes == null) {
        throw Exception("Failed to convert SVG to PNG");
      }
      return pngBytes.buffer.asUint8List();
    } catch (e) {
      print("Error in SVG to PNG conversion: $e");
      rethrow;
    }
  }

  Future<String?> generateAndUploadBarcode(String uniqueId) async {
    try {
      final bc = Barcode.code128();
      final svgData = bc.toSvg(uniqueId, height: 80);

      final tempDir = await getTemporaryDirectory();
      final barcodeFile = File('${tempDir.path}/$uniqueId.svg');
      await barcodeFile.writeAsString(svgData);

      return await uploadBarcodeImageToCloudinary(barcodeFile);
    } catch (e) {
      print("Error in Barcode Generation: $e");
      return null;
    }
  }

  Future<String?> uploadBarcodeImageToCloudinary(File imageFile) async {
    final String cloudName = "danuec5mr";

    final cloudinary = Cloudinary.signedConfig(
      apiKey: '979729989863561',
      apiSecret: 'rSUPV8ymyKst7VYjfdqQ2qYkQAI',
      cloudName: cloudName,
    );

    try {
      String uniqueFileName = Uuid().v4() + '.svg';

      final response = await cloudinary.upload(
        file: imageFile.path,
        fileBytes: imageFile.readAsBytesSync(),
        resourceType: CloudinaryResourceType.raw,
        fileName: uniqueFileName,
        progressCallback: (count, total) {
          print('Uploading SVG with progress: $count/$total');
        },
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        throw Exception("Failed to upload SVG: ${response.error}");
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final String cloudName = "danuec5mr";

    final cloudinary = Cloudinary.signedConfig(
      apiKey: '979729989863561',
      apiSecret: 'rSUPV8ymyKst7VYjfdqQ2qYkQAI',
      cloudName: cloudName,
    );

    try {
      String uniqueFileName = Uuid().v4() + '.jpg';

      final response = await cloudinary.upload(
        file: imageFile.path,
        fileBytes: imageFile.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        fileName: uniqueFileName,
        progressCallback: (count, total) {
          print('Uploading image from file with progress: $count/$total');
        },
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        throw Exception("Failed to upload image: ${response.error}");
      }
    } catch (e) {
      print("Cloudinary Upload Error: $e");
      return null;
    }
  }

  Future<void> addFoodToFirestore() async {
    if (itemNameController.text.isEmpty ||
        itemPriceController.text.isEmpty ||
        itemTypeController.text.isEmpty ||
        itemQuantityController.text.isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and upload an image')),
      );
      return;
    }

    String? imageUrl = await uploadImageToCloudinary(selectedImage!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
      return;
    }

    String uniqueId = const Uuid().v4();

    String? barcodeUrl = await generateAndUploadBarcode(uniqueId);
    if (barcodeUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barcode generation failed')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('foods').doc(uniqueId).set({
      'id': uniqueId,
      'name': itemNameController.text,
      'price': double.parse(itemPriceController.text),
      'type': itemTypeController.text,
      'quantity': int.parse(itemQuantityController.text),
      'imageUrl': imageUrl,
      'barcodeUrl': barcodeUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Food added successfully!')),
    );

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    bool isloading = false;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child:
              const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.blue),
        ),
        centerTitle: true,
        title: Text("Add Items", style: AppWidgets.HeadlineField()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text("Upload the Item Picture",
                      style: AppWidgets.semiBoldTextFeildStyle())),
              const SizedBox(height: 20),
              selectedImage == null
                  ? GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
              _buildTextField(
                  'Food Name', itemNameController, 'Enter Food Name'),
              _buildTextField('Price', itemPriceController, 'Enter Price'),
              _buildTextField(
                  'Veg/Non-Veg', itemTypeController, 'Enter Veg/Non-Veg'),
              _buildTextField(
                  'Quantity', itemQuantityController, 'Enter Quantity'),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isloading = true;
                  });
                  addFoodToFirestore();
                  setState(() {
                    isloading = false;
                  });
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: isloading
                            ? Center(child: CircularProgressIndicator())
                            : const Text(
                                "Add",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppWidgets.semiBoldTextFeildStyle()),
        const SizedBox(height: 10),
        CustomTextField(hintText: hint, controller: controller),
        const SizedBox(height: 20),
      ],
    );
  }
}
