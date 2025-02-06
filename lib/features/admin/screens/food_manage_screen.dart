import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickfood/widgets/AppWidgets.dart';

class FoodManagePage extends StatefulWidget {
  @override
  _FoodManagePageState createState() => _FoodManagePageState();
}

class _FoodManagePageState extends State<FoodManagePage> {
  void _editFoodItem(BuildContext context, String foodItemId) {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: [
            AlertDialog(
              title: Text(
                'Edit Food Item',
                style: AppWidgets.HeadlineField(),
              ),
              content: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter new name'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(hintText: 'Price'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(hintText: 'Food Type'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _deleteFoodItem(String foodItemId) async {
    await FirebaseFirestore.instance
        .collection('foods')
        .doc(foodItemId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Food item deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foods').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No food items available.'));
          }

          final foodItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              var foodItem = foodItems[index];
              String foodItemId = foodItem['id'];
              String foodName = foodItem['name'];
              double price = foodItem['price'];
              String imageUrl = foodItem['imageUrl'];

              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  height: 100,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(foodName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Price: \₹${price.toString()}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editFoodItem(context, foodItemId);
                        } else if (value == 'delete') {
                          _deleteFoodItem(foodItemId);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, color: Colors.blue),
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
