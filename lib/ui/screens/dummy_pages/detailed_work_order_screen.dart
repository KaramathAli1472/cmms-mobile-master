import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintboard/ui/screens/dummy_pages/location/create_location_screen.dart';

// ========================= Detailed Work Order Screen =========================
class DetailedWorkOrderScreen extends StatefulWidget {
  const DetailedWorkOrderScreen({super.key});
  @override
  State<DetailedWorkOrderScreen> createState() =>
      _DetailedWorkOrderScreenState();
}

class _DetailedWorkOrderScreenState extends State<DetailedWorkOrderScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<File> selectedImages = [];

  String location = "Assign Location";
  String asset = "Select Asset";
  String produce = "";
  String estimateTime = "Set";
  String assignedTo = "Choose";
  DateTime? dueDate;
  DateTime? startDate;
  String recurrence = "Set";
  String workType = "Reactive";
  String priority = "None";
  String partsNeeded = "Add Parts";
  String categories = "Add Category";
  String files = "Attach Files";
  String vendors = "Add Vendors";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Work Order"),
        actions: [
          TextButton(
            onPressed: _createWorkOrder,
            child: const Text(
              "Create",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title Field
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "What needs to be done?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Add / Take Picture
            InkWell(
              onTap: () => _showPictureOptions(context),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      "Add / Take Picture",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Selected Images preview
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Description Field
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Add description",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rows
            _customRow("Location", location, _openAssignLocation),
            const SizedBox(height: 12),
            _customRow("Asset", asset, () {}),
            const SizedBox(height: 12),
            _customRow("Produce", produce.isEmpty ? "Add produce" : produce, () {}),
            const SizedBox(height: 12),
            _customRow("Estimate Time", estimateTime, () {}),
            const SizedBox(height: 12),
            _customRow("Assign To", assignedTo, () {}),
            const SizedBox(height: 12),
            _customRow("Due Date",
                dueDate == null ? "Set Due Date" : dueDate.toString(), () {}),
            const SizedBox(height: 12),
            _customRow("Start Date",
                startDate == null ? "Set Start Date" : startDate.toString(),
                    () {}),
            const SizedBox(height: 12),
            _customRow("Recurrence", recurrence, () {}),
            const SizedBox(height: 12),
            _customRow("Work Type", workType, () {}),
            const SizedBox(height: 12),
            _customRow("Priority", priority, () {}),
            const SizedBox(height: 12),
            _customRow("Parts Needed", partsNeeded, () {}),
            const SizedBox(height: 12),
            _customRow("Categories", categories, () {}),
            const SizedBox(height: 12),
            _customRow("Files", files, () {}),
            const SizedBox(height: 12),
            _customRow("Vendors", vendors, () {}),
          ],
        ),
      ),
    );
  }

  Widget _customRow(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              value,
              style: TextStyle(
                  color: value.contains("Set") ||
                      value.contains("Add") ||
                      value.contains("Choose")
                      ? Colors.grey
                      : Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _showPictureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
    if (mounted) Navigator.pop(context);
  }

  void _openAssignLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssignLocationScreen()),
    ).then((value) {
      if (value != null && value is String) {
        setState(() {
          location = value;
        });
      }
    });
  }

  void _createWorkOrder() {
    debugPrint(
        "Work Order Created: Title: ${titleController.text}, Desc: ${descriptionController.text}");
  }
}

// ========================= Assign Location Screen =========================
class AssignLocationScreen extends StatefulWidget {
  const AssignLocationScreen({super.key});

  @override
  State<AssignLocationScreen> createState() => _AssignLocationScreenState();
}

class _AssignLocationScreenState extends State<AssignLocationScreen> {
  void _scanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("QR Scanner pressed")),
    );
  }

  void _openCreateLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateLocationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode,
            tooltip: "Scan QR",
          ),
        ],
      ),
      body: Column(
        children: [
          // Bada Create Location button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity, // full width
              height: 60, // height bada kiya
              child: TextButton.icon(
                icon: const Icon(Icons.add_location_alt, color: Colors.blue, size: 28),
                label: const Text(
                  "+ Create Location",
                  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: _openCreateLocation,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade100, // optional light background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Bacha hua space
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}