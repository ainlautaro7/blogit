// blogit/lib/widgets/tag_filter.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp2/providers/theme_provider.dart';

class TagFilter extends StatelessWidget {
  final Future<List<String>> tags;
  final String? selectedTag;
  final Function(String?) onTagSelected;

  const TagFilter(
      {Key? key,
      required this.tags,
      this.selectedTag,
      required this.onTagSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return FutureBuilder<List<String>>(
      future: tags,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tags found.'));
        }

        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final tag = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  onTagSelected(tag);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: selectedTag == tag
                        ? Colors.green
                        : isDarkMode
                            ? Colors.white
                            : Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selectedTag == tag
                          ? Colors.green
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(
                          color: isDarkMode ? Colors.black87 : Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
