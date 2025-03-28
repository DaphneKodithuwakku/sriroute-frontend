import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/user_service.dart'; // Add this import

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController(text: "********");
  TextEditingController dobController = TextEditingController(text: "23/05/1995");

  String selectedCountry = "Sri Lanka";
  String selectedReligion = "Buddhism";
  bool _isLoading = true;
  bool _isSaving = false;
  File? _imageFile;
  String? _profileImageUrl;

  final List<String> countries = [
    "Sri Lanka",
    "India",
    "USA",
    "Canada",
    "UK",
    "Australia",
  ];
  final List<String> religions = [
    "Hinduism",
    "Islam",
    "Buddhism",
    "Christianity",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get user data from Firebase Auth
      final user = _auth.currentUser;
      if (user != null && mounted) {
        emailController.text = user.email ?? '';
        
        // Check if user has a profile picture
        if (user.photoURL != null) {
          setState(() {
            _profileImageUrl = user.photoURL;
          });
        }
        
        // Get user data from Firestore
        try {
          final userData = await _firestore.collection('users').doc(user.uid).get();
          
          if (userData.exists) {
            final data = userData.data();
            if (data != null) {
              setState(() {
                // Check for username with fallbacks
                nameController.text = data['username'] ?? data['name'] ?? user.displayName ?? 'User';
                
                // Get DOB if it exists
                if (data['dob'] != null) {
                  dobController.text = data['dob'];
                }
                
                // Get country if it exists
                if (data['country'] != null) {
                  selectedCountry = data['country'];
                }
                
                // Get religion if it exists
                if (data['religion'] != null) {
                  selectedReligion = data['religion'];
                }
              });
            }
          } else {
            // Use display name if available
            if (user.displayName != null && user.displayName!.isNotEmpty) {
              nameController.text = user.displayName!;
            }
            
            // Try to get username from SharedPreferences as fallback
            final prefs = await SharedPreferences.getInstance();
            final savedUsername = prefs.getString('username');
            
            if (savedUsername != null && savedUsername.isNotEmpty) {
              nameController.text = savedUsername;
            } else {
              nameController.text = "User";
            }
          }
        } catch (firestoreError) {
          debugPrint("Firestore error: $firestoreError");
          // Fallback to Auth display name or SharedPreferences
          if (user.displayName != null && user.displayName!.isNotEmpty) {
            nameController.text = user.displayName!;
          } else {
            // Try SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            nameController.text = prefs.getString('username') ?? 'User';
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,  // Limit image size for faster uploads
        imageQuality: 85,  // Slightly compress for better performance
      );
      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: ${e.toString()}')),
        );
      }
    }
  }

  Future<String?> _uploadProfilePicture() async {
    if (_imageFile == null) return _profileImageUrl; // Return current URL if no new image

    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      
      // Create a reference to the file path in Firebase Storage
      final storageRef = _storage.ref().child('profile_pictures/${user.uid}');
      
      // Upload the file with metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': user.uid},
      );
      final uploadTask = storageRef.putFile(_imageFile!, metadata);
      
      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() {});
      
      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
      return null;  // Return null if upload fails
    }
  }

  Future<void> _saveUserData() async {
    if (!mounted) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user signed in");
      }
      
      // Step 1: Try to upload profile picture if a new one was selected
      String? photoURL = _profileImageUrl;  // Keep current if no new image
      if (_imageFile != null) {
        try {
          photoURL = await _uploadProfilePicture();
        } catch (uploadError) {
          debugPrint("Profile picture upload failed: $uploadError");
          // Continue with saving other data even if image upload fails
        }
      }
      
      // Step 2: Update Firebase Auth user display name
      try {
        await user.updateDisplayName(nameController.text);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
      } catch (authUpdateError) {
        debugPrint("Auth profile update failed: $authUpdateError");
        // Continue with Firestore update even if Auth update fails
      }
      
      // Step 3: Prepare user data for Firestore
      final userData = {
        'username': nameController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'country': selectedCountry,
        'religion': selectedReligion,
        'lastUpdated': FieldValue.serverTimestamp(),
      };
      
      // Add profile URL if available
      if (photoURL != null) {
        userData['photoURL'] = photoURL;
      }
      
      // Step 4: Save to Firestore with retry
      bool firestoreSaved = false;
      for (int attempt = 0; attempt < 3 && !firestoreSaved; attempt++) {
        try {
          await _firestore.collection('users').doc(user.uid).set(
            userData, 
            SetOptions(merge: true)
          );
          firestoreSaved = true;
        } catch (firestoreError) {
          debugPrint("Firestore save attempt ${attempt + 1} failed: $firestoreError");
          await Future.delayed(Duration(seconds: 1));  // Wait before retry
        }
      }
      
      // Step 5: Save to SharedPreferences for offline access
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nameController.text);
      if (photoURL != null) {
        await prefs.setString('profileImageUrl', photoURL);
      }
      
      // Make sure UserService knows about the updated data
      UserService.saveUsername(nameController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        
        // Pop with result so parent knows to refresh
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 5, 23),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
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
    // ...existing code...
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    // Show selected image, else user's photo, else icon
                    backgroundImage: _imageFile != null 
                      ? FileImage(_imageFile!) 
                      : (_profileImageUrl != null 
                        ? NetworkImage(_profileImageUrl!) as ImageProvider 
                        : null),
                    child: (_imageFile == null && _profileImageUrl == null) 
                      ? Icon(Icons.person, size: 50, color: Colors.grey[700]) 
                      : null,
                  ),
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildTextField("Username", nameController),
              _buildTextField("Email", emailController, enabled: false), // Email shouldn't be editable
              _buildTextField("Password", passwordController, obscureText: true, enabled: false), // Password handled separately
              _buildDateField("Date of Birth", dobController, context),
              _buildDropdown("Country/Region", selectedCountry, countries, (value) {
                setState(() {
                  selectedCountry = value!;
                });
              }),
              _buildDropdown("Religion", selectedReligion, religions, (value) {
                setState(() {
                  selectedReligion = value!;
                });
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 1.0,
                  shadowColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Save changes',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
