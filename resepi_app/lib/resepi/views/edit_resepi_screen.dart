import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/models.dart';
import '../bloc/resepi_bloc.dart';


class _ImagePickerContainer extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onPickImage;

  const _ImagePickerContainer({
    required this.imageFile,
    required this.imageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imageFile != null) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(imageFile!, fit: BoxFit.cover),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.broken_image,
              size: 100,
              color: Colors.grey[600],
            );
          },
        ),
      );
    } else {
      imageWidget = Icon(
        Icons.add_a_photo_rounded,
        size: 100,
        color: Colors.grey[300],
      );
    }

    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 180,
        width: double.infinity,
        child: imageWidget,
      ),
    );
  }
}

class _StandardTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _StandardTextFormField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    );
  }
}

class _DynamicInputList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final String itemLabel;
  final String validationMessage;
  final VoidCallback onAddField;
  final Function(int) onRemoveField;

  const _DynamicInputList({
    required this.controllers,
    required this.itemLabel,
    required this.validationMessage,
    required this.onAddField,
    required this.onRemoveField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemLabel,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],
                      maxLines: (itemLabel.contains('Langkah')) ? null : 1,
                      keyboardType: (itemLabel.contains('Langkah')) ? TextInputType.multiline : TextInputType.text,
                      decoration: InputDecoration(
                        hintText: '${itemLabel.split('-').first} ${index + 1}',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return validationMessage;
                        }
                        return null;
                      },
                    ),
                  ),
                  if (controllers.length > 1)
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () => onRemoveField(index),
                    ),
                ],
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onAddField,
            icon: const Icon(Icons.add_circle),
            label: Text('Tambah ${itemLabel.split('-').first}'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}


class EditResepiScreen extends StatefulWidget {
  final Resepi resep;

  const EditResepiScreen({
    super.key,
    required this.resep,
  });

  @override
  State<EditResepiScreen> createState() => _EditResepiScreenState();
}

class _EditResepiScreenState extends State<EditResepiScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _imageFile; // Digunakan jika gambar baru dipilih
  String? _currentImageUrl; // Untuk gambar yang sudah ada dari database

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final List<TextEditingController> _bahanController = [];
  final List<TextEditingController> _langkahController = [];
  final TextEditingController _porsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.resep.nama;
    _deskripsiController.text = widget.resep.deskripsi;
    _porsiController.text = widget.resep.porsi.toString();
    _currentImageUrl = widget.resep.imageUrl;

    if (widget.resep.bahan.isNotEmpty) {
      for (var bahan in widget.resep.bahan) {
        _bahanController.add(TextEditingController(text: bahan));
      }
    } else {
      _bahanController.add(TextEditingController());
    }

    if (widget.resep.langkah.isNotEmpty) {
      for (var langkah in widget.resep.langkah) {
        _langkahController.add(TextEditingController(text: langkah));
      }
    } else {
      _langkahController.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _porsiController.dispose();
    for (var controller in _bahanController) {
      controller.dispose();
    }
    for (var controller in _langkahController) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);

        _currentImageUrl = null;
      });
    }
  }

  void _addBahanField() {
    setState(() {
      _bahanController.add(TextEditingController());
    });
  }

  void _removeBahanField(int index) {
    setState(() {
      _bahanController[index].dispose();
      _bahanController.removeAt(index);
    });
  }

  void _addLangkahField() {
    setState(() {
      _langkahController.add(TextEditingController());
    });
  }

  void _removeLangkahField(int index) {
    setState(() {
      _langkahController[index].dispose();
      _langkahController.removeAt(index);
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null && (_currentImageUrl == null || _currentImageUrl!.isEmpty)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Harap pilih gambar resep.')));
        return;
      }

      final String namaResep = _namaController.text;
      final String deskripsiResep = _deskripsiController.text;
      final int porsi = int.tryParse(_porsiController.text) ?? 0;
      final List<String> bahan =
      _bahanController.map((c) => c.text).where((text) => text.isNotEmpty).toList();
      final List<String> langkah =
      _langkahController.map((c) => c.text).where((text) => text.isNotEmpty).toList();

      context.read<ResepiBloc>().add(
        UpdateResepiEvent(
          id: widget.resep.id,
          nama: namaResep,
          deskripsi: deskripsiResep,
          imageFile: _imageFile!,
          bahan: bahan,
          langkah: langkah,
          porsi: porsi,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Edit Resep'),
        forceMaterialTransparency: true,
      ),
      body: BlocListener<ResepiBloc, ResepiState>(

        listener: (context, state) {
          if (state.status == ResepiStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state.status == ResepiStatus.success) {

            Navigator.pop(context);

          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  _ImagePickerContainer(
                    imageFile: _imageFile,
                    imageUrl: _currentImageUrl, // Perhatikan ini
                    onPickImage: _pickImage,
                  ),
                  const SizedBox(height: 16),
                  _StandardTextFormField(
                    controller: _namaController,
                    hintText: 'Nama Resep',
                    labelText: 'Nama Resep',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama resep tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _StandardTextFormField(
                    controller: _deskripsiController,
                    hintText: 'Deskripsi Resep',
                    labelText: 'Deskripsi Resep',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi resep tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _StandardTextFormField(
                    controller: _porsiController,
                    hintText: 'Jumlah Porsi',
                    labelText: 'Jumlah Porsi',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah porsi tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Porsi harus angka positif';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _DynamicInputList(
                    controllers: _bahanController,
                    itemLabel: 'Bahan-bahan',
                    validationMessage: 'Bahan tidak boleh kosong',
                    onAddField: _addBahanField,
                    onRemoveField: _removeBahanField,
                  ),
                  _DynamicInputList(
                    controllers: _langkahController,
                    itemLabel: 'Langkah-langkah',
                    validationMessage: 'Langkah tidak boleh kosong',
                    onAddField: _addLangkahField,
                    onRemoveField: _removeLangkahField,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _submitForm(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}