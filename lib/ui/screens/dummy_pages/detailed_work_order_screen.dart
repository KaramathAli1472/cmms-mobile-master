import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintboard/ui/screens/dummy_pages/location/create_location_screen.dart';
import 'package:maintboard/ui/screens/dummy_pages/asset/asset_selection_screen.dart';

class DetailedWorkOrderScreen extends StatefulWidget {
  const DetailedWorkOrderScreen({super.key});
  @override
  State<DetailedWorkOrderScreen> createState() => _DetailedWorkOrderScreenState();
}

class _DetailedWorkOrderScreenState extends State<DetailedWorkOrderScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];

  String location = "Assign Location";
  String asset = "Select Asset";
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
          title: const Text("New Work Order"),
          actions: [
            TextButton(
                onPressed: _createOrder,
                child: const Text("CREATE",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                )
            )
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,8,16,8),
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          labelText: "What needs to be done?",
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16, vertical:8),
                    child: InkWell(
                      onTap: _showPictureOptions,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal:12, vertical:16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                          Icon(Icons.camera_alt_outlined, color: Colors.blue),
                          SizedBox(width:8),
                          Text('Add / Take Picture', style: TextStyle(color:Colors.blue,fontWeight: FontWeight.w500))
                        ]),
                      ),
                    ),
                  ),

                  if(selectedImages.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left:16),
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right:8),
                                width:100, height:100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: FileImage(selectedImages[index]), fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Positioned(
                                  top:2, right:2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black54, shape: BoxShape.circle
                                      ),
                                      child: const Icon(Icons.close, size:18, color: Colors.white),
                                    ),
                                  )
                              )
                            ],
                          );
                        },
                      ),
                    ),

                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal:16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Description',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize:22, color: Colors.black87)
                              ),
                              const SizedBox(height:8),
                              TextField(
                                  controller: descriptionController,
                                  maxLines:4,
                                  decoration: const InputDecoration(hintText: 'Add description', border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey))
                              )
                            ]
                        ),
                      )
                  ),

                  const SizedBox(height: 12),

                  _customRow("Location", location, _openAssign),
                  const SizedBox(height: 12),
                  _customRow("Asset", asset, _openAsset),

                  const SizedBox(height: 16),
// Add Procedure Heading
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      'Procedure',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Procedure block
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical:28),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200, width: 1)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _showProcedureBottomSheet,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.list, color: Colors.blue, size: 22),
                            SizedBox(width:8),
                            Text('Add Procedure', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold, color: Colors.blue))
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _customRow("Estimated Time", estimateTime, (){}),
                  const SizedBox(height: 12),
                  _customRow("Assign To", assignedTo, (){}),
                  const SizedBox(height: 12),
                  _customRow("Due Date", dueDate==null?'Set Date':dueDate!.toLocal().toString().split(' ')[0], (){}),
                  const SizedBox(height: 12),
                  _customRow("Start Date", startDate==null?'Set Date':startDate!.toLocal().toString().split(' ')[0], (){}),
                  const SizedBox(height: 12),
                  _customRow("Recurrence", recurrence, (){}),
                  const SizedBox(height: 12),
                  _customRow("Work Type", workType, (){}),
                  const SizedBox(height: 12),
                  _customRow("Priority", priority, (){}),
                  const SizedBox(height: 12),
                  _customRow("Parts Needed", partsNeeded, (){}),
                  const SizedBox(height: 12),
                  _customRow("Categories", categories, (){}),
                  const SizedBox(height: 12),
                  _customRow("Files", files, (){}),
                  const SizedBox(height: 12),
                  _customRow("Vendors", vendors, (){}),
                ]
            )
        )
    );
  }

  Widget _customRow(String title, String value, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:16),
            child: Container(
              height: 48,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  Text(value, style: TextStyle(
                    color: value=='Set Date' || value=='Choose'|| value.startsWith('Add') ? Colors.blue : Colors.black,
                    fontWeight: value=='Set Date' || value=='Choose' || value.startsWith('Add') ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  )),
                ],
              ),
            )
        )
    );
  }

  void _showProcedureBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 8, 4),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          'Create New Procedure',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close, size: 24),
                      )
                    ]
                ),
              ),
              const Divider(height: 1, thickness: 1),
              // 1st Option
              _procedureOptionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.08),
                    child: const Icon(Icons.auto_awesome, color: Colors.blue, size: 24),
                    radius: 22,
                  ),
                  title: Row(
                    children: [
                      const Text('Quick-create', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 1),
                        decoration: BoxDecoration(color: const Color(0xfffffacc), borderRadius: BorderRadius.circular(5)),
                        child: const Text('New!', style: TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ],
                  ),
                  subtitle: 'Generate a new Procedure in three easy steps with our AI assistant',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context);
                    // quick-create action here
                  }
              ),
              const Divider(height: 1, thickness: 1),
              // 2nd Option
              _procedureOptionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.08),
                  child: const Icon(Icons.list_alt, color: Colors.blue, size: 24),
                  radius: 22,
                ),
                title: const Text('Add Procedure from library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: 'Attach an existing Procedure',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  // add from library action here
                },
              ),
              const Divider(height: 1, thickness: 1),
              // 3rd Option
              _procedureOptionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.08),
                  child: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 24),
                  radius: 22,
                ),
                title: const Text('Start from blank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: 'Create a Procedure from scratch',
                trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  // start from blank action here
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }

// Add this helper function inside your State class as well
  Widget _procedureOptionTile({
    required Widget leading,
    required Widget title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showPictureOptions() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("Take Photo"),
                      onTap: () => _pickImage(ImageSource.camera)
                  ),
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text("Choose from Gallery"),
                      onTap: () => _pickImage(ImageSource.gallery)
                  )
                ],
              )
          );
        }
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if(image != null) {
      setState(() {
        selectedImages.add(File(image.path));
      });
    }
    if(mounted) Navigator.of(context).pop();
  }

  void _createOrder() {
    debugPrint('Work order created with title: ${titleController.text} and desc: ${descriptionController.text}');
  }

  void _createWorkOrder() {
    debugPrint('Work order created');
  }

  void _openAssign() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssignLocationScreen())).then((value){
      if(value != null && value is String){
        setState(() {
          location = value;
        });
      }
    });
  }

  void _openAsset() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssetSelectionScreen())).then((value){
      if(value != null && value is String){
        setState(() {
          asset = value;
        });
      }
    });
  }
}

class AssignLocationScreen extends StatefulWidget {
  const AssignLocationScreen({super.key});

  @override
  State<AssignLocationScreen> createState() => _AssignLocationScreenState();
}

class _AssignLocationScreenState extends State<AssignLocationScreen> {
  void _scanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("QR Scanner pressed")));
  }
  void _openCreateLocation() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateLocationScreen()));
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
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16, vertical:12),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(Icons.add_location_alt, color: Colors.blue, size: 28),
                label: const Text(" + Create Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
                onPressed: _openCreateLocation,
                style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
