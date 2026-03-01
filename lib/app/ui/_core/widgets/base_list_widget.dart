import 'package:flutter/material.dart';
import 'package:smart_stock/app/ui/_core/widgets/loading_widget.dart';

class BaseList<T> extends StatelessWidget {
  final bool isLoading;
  final String emptyMessage;
  final List<T> data;
  final Widget Function(T item) itemBuilder;
  final double widthPercentage;
  final double heightPercentage;

  const BaseList({
    super.key,
    required this.isLoading,
    required this.emptyMessage,
    required this.data,
    required this.itemBuilder,
    required this.heightPercentage,
    required this.widthPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * widthPercentage,
      height: MediaQuery.of(context).size.height * heightPercentage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            if (isLoading)
              const Expanded(child: LoadingWidget())
            else
              data.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(emptyMessage, style: Theme.of(context).textTheme.titleMedium),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 12),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: itemBuilder(data[index]),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
