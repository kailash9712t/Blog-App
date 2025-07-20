import 'package:blog/Components/custom_button.dart';
import 'package:blog/Components/text_field.dart';
import 'package:blog/Pages/Auth/ProfileSetUp1/State/profile_set_up1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool isLoading = false;

  void _showImageSourceDialog({required bool isProfile}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  isProfile ? 'Select Profile Photo' : 'Select Cover Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileSetUp1>().pickImageFromSource(
                    ImageSource.gallery,
                    isProfile,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);

                  context.read<ProfileSetUp1>().pickImageFromSource(
                    ImageSource.gallery,
                    isProfile,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<ProfileSetUp1>(
                builder: (context, instance, child) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient:
                          instance.coverImageUrl == null
                              ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                              )
                              : null,
                      image:
                          instance.coverImageUrl != null
                              ? DecorationImage(
                                image: FileImage(instance.coverImageUrl!),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 32),
                                Row(
                                  children: [
                                    Transform.rotate(
                                      angle: 0.785398,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white30,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Transform.rotate(
                                      angle: 0.785398,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white30,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap:
                                () => _showImageSourceDialog(isProfile: false),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit Cover',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Transform.translate(
                offset: Offset(0, -50),
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: Colors.grey[200],
                      ),
                      child: Consumer<ProfileSetUp1>(
                        builder: (context, instance, child) {
                          return ClipOval(
                            child:
                                instance.profileImageUrl != null
                                    ? Image.file(
                                      instance.profileImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                    : Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImageSourceDialog(isProfile: true),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: CustomTextField(
                          controller: _displayNameController,
                          labelText: 'Display Name',
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          delay: 1,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: CustomTextField(
                          controller: _bioController,
                          labelText: 'Bio',
                          prefixIcon: Icons.info_outline,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          delay: 2,
                          maxLength: 160,
                          maxLines: 4,
                        ),
                      ),

                      SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Consumer<ProfileSetUp1>(
                          builder: (context, instance, child) {
                            return CustomButton(
                              text: 'Submit',
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        instance.profileDataStore1(
                                          context,
                                          _displayNameController.text,
                                          _bioController.text,
                                        );
                                      },
                              isLoading: isLoading,
                              delay: 4,
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        'OR',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),

                      SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<ProfileSetUp1>().handleCancel(
                              _bioController,
                              _displayNameController,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
