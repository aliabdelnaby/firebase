import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_note.dart';
import 'edit_note.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.categoryId});

  final String categoryId;
  @override
  State<NoteView> createState() => _HomePageState();
}

class _HomePageState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('note')
        .get();

    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddNoteView(
                  docId: widget.categoryId,
                );
              },
            ),
          );
        },
        tooltip: "Add Category",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              "home",
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text('My Notes'),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            "home",
            (route) => false,
          );
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 235,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            data[index]["note"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 10),
                          if (data[index]["image"] != "none")
                            Image.network(
                              data[index]["image"]!,
                              height: 100,
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return UpdateNoteView(
                                          noteDocId: data[index].id,
                                          oldNote: data[index]["note"],
                                          categoryDocId: widget.categoryId,
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_note_outlined,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return NoteView(
                                        categoryId: widget.categoryId,
                                      );
                                    },
                                  ), (route) => false);
                                  await FirebaseFirestore.instance
                                      .collection("categories")
                                      .doc(widget.categoryId)
                                      .collection('note')
                                      .doc(data[index].id)
                                      .delete();
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
