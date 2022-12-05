import 'package:flutter/material.dart';

class LoadingBuilder extends StatefulWidget {
  const LoadingBuilder({
    super.key,
    required this.builder,
  });
  final Widget Function(
      BuildContext context, bool isLoading, Function(bool) setLoading) builder;
  // final VoidCallback onLoad;

  @override
  State<LoadingBuilder> createState() => _LoadingBuilderState();
}

class _LoadingBuilderState extends State<LoadingBuilder> {
  bool isLoading = false;
  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      isLoading,
      (isLoading) => setIsLoading(isLoading),
    );
  }
}
