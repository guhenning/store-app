import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:store/components/custom_image_builder.dart';

import 'package:store/components/gradient_colors.dart';
import 'package:store/models/product.dart';
import 'package:store/providers/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  //add product to cart or manualy 1 by 1 or using the url with the formate json content
  // image preview for the image url
  // to do implement possibility of using local storage photo

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  var _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _storeNameFocus = FocusNode();

  final _imageFocus = FocusNode();
  final _imageController = TextEditingController();

  File? _storedImage;
  //File? pickedImage;

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;
  bool _imageFromUrl = false;
  bool _imageFromCameraGallery = true;

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener((updateImage));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['storeName'] = product.storeName;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _storeNameFocus.dispose();
    _imageFocus.removeListener(updateImage);
    _imageFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 80,
    );

    if (imageFile == null) return; // User canceled the operation

    setState(() {
      _storedImage = File(imageFile.path);
      //print('Thatsthepath ${_storedImage?.path}');
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName',
    );
  }

  _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 80,
    );

    if (imageFile == null) return; // User canceled the operation

    setState(() {
      _storedImage = File(imageFile.path);
      print('Thatsthepath ${_storedImage?.path}');
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName',
    );
  }

  // void _selectImage(File pickedImage) {
  //   pickedImage = pickedImage;
  // }

  Future<void> _submitform() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      // Update the imageUrl in the same format as _storedImage?.path
      if (_storedImage != null) {
        _formData['imageUrl'] = _storedImage!.path;
      }

      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
      // Clear form fields
      _formKey.currentState?.reset();
      _imageController.clear();
      _formData.clear();
    } catch (error) {
      //handle error
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          content: const Text(
            'An error occurred while saving the product, try again later!',
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Pop again to go back to manager page
              },
            )
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadFromJson() async {
    final urlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(
          child: Text(
            'Load Products from URL',
            style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'Paste the URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                  fontSize: 14),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Load',
              style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 20),
            ),
            onPressed: () async {
              final url = urlController.text.trim();

              if (url.isNotEmpty) {
                Navigator.of(context).pop();

                try {
                  setState(() => _isLoading = true);

                  await Provider.of<ProductList>(
                    context,
                    listen: false,
                  ).loadProductsFromJsonUrl(url);

                  setState(() => _isLoading = false);

                  // Go back to manager page
                } catch (error) {
                  // handle error
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Center(
                        child: Text(
                          'Error',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                      ),
                      content: const Text(
                        'An error occurred while loading products from URL.',
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pop(); // Pop again to go back to manager page
                          },
                        ),
                      ],
                    ),
                  );
                } finally {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Products from Url saved successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientColors(),
        centerTitle: true,
        title: Text(
          'Add/Edit Products',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _loadFromJson,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitform,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // in case is edit its showing data from product in inicial value of text field
                    // name text form max length 40 showing the lenght for the user
                    const SizedBox(height: 5),
                    TextFormField(
                        autofocus: true,
                        initialValue: _formData['name']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        textInputAction: TextInputAction.next,
                        maxLength: 45,
                        focusNode: _nameFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (name) => _formData['name'] = name ?? '',
                        validator: (_name) {
                          final name = _name ?? '';

                          if (name.trim().isEmpty) {
                            return 'Name is required';
                          }

                          return null;
                        }),
                    const SizedBox(height: 5),
                    TextFormField(
                      initialValue: _formData['price'] != null
                          ? (_formData['price'] as double).toStringAsFixed(2)
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        counterText: "",
                      ),
                      textInputAction: TextInputAction.next,
                      maxLength: 13,
                      focusNode: _priceFocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (_price) {
                        final priceString = _price ?? '';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'The price format is invalid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      focusNode: _descriptionFocus,
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_storeNameFocus);
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      initialValue: _formData['storeName']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Store Name',
                        counterText: "",
                      ),
                      focusNode: _storeNameFocus,
                      maxLength: 40,
                      onSaved: (storeName) =>
                          _formData['storeName'] = storeName ?? '',
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            activeColor:
                                Theme.of(context).textTheme.titleMedium?.color,
                            title: const Text(
                              'Load from Camera',
                              textAlign: TextAlign.center,
                            ),
                            value: _imageFromCameraGallery,
                            onChanged: (value) {
                              setState(
                                () {
                                  _imageFromCameraGallery = value!;
                                  _imageFromUrl = !value;
                                },
                              );
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            activeColor:
                                Theme.of(context).textTheme.titleMedium?.color,
                            title: const Text(
                              'Load from URL',
                              textAlign: TextAlign.center,
                            ),
                            value: _imageFromUrl,
                            onChanged: (value) {
                              setState(
                                () {
                                  _imageFromUrl = value!;
                                  _imageFromCameraGallery = !value;
                                },
                              );
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Visibility(
                          visible: _imageFromUrl,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Image Url'),
                                  focusNode: _imageFocus,
                                  controller: _imageController,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  onFieldSubmitted: (_) => _submitform(),
                                  onSaved: (imageUrl) =>
                                      _formData['imageUrl'] = imageUrl ?? '',
                                  validator: (_imageUrl) {
                                    final imageUrl = _imageUrl ?? '';
                                    if (imageUrl.trim().isEmpty) {
                                      return 'The Image Url is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: _imageController.text.isEmpty
                                    ? const Text('Insert Url')
                                    : ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(17.5)),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: CustomImageBuilder(
                                            image: _imageController.text,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // if _loadFromCameraGallery is true show this
                    Column(
                      children: [
                        Visibility(
                          visible: _imageFromCameraGallery,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    width: 180,
                                    child: ElevatedButton(
                                      onPressed: _takePicture, //_takePicture,
                                      child: Text(
                                        'Take Photo',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 180,
                                    child: ElevatedButton(
                                      onPressed: _pickImage, //_takePicture,
                                      child: Text(
                                        'Select Photo',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.color),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              Container(
                                height: 100,
                                width: 100,
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(17.5)),
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: _storedImage != null
                                        ? CustomImageBuilder(
                                            image: _storedImage!.path)
                                        : _imageController.text.isNotEmpty
                                            ? CustomImageBuilder(
                                                image: _imageController.text)
                                            : const Center(
                                                child: Text(
                                                  'Select An Image!',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
