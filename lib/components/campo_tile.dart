import 'package:flutter/material.dart';

class CampoTile extends StatefulWidget {
  final String index;
  bool revelado;
  final Function()? onTap;
  bool bomba;
  bool flag;

  CampoTile({
    super.key,
    required this.index,
    required this.revelado,
    required this.onTap,
    required this.bomba,
    required this.flag,
  });

  @override
  State<CampoTile> createState() => _CampoTileState();
}

class _CampoTileState extends State<CampoTile> {
  Widget flag() {
    if (widget.flag == false && widget.bomba == true) {
      return Text(
        widget.flag ? "F" : (widget.revelado ? widget.index.toString() : ""),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (widget.flag == false && widget.bomba == false) {
      return Text(
        widget.revelado
            ? (widget.index == "0" ? '' : widget.index.toString())
            : " ",
        style: TextStyle(
          color: widget.index == "1"
              ? Colors.blue
              : (widget.index == "2" ? Colors.green : Colors.red),
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (widget.flag == true) {
      return const Icon(Icons.flag);
    }
    return const Icon(Icons.error);
  }

  Widget checarBomba(BuildContext context) {
    if (widget.bomba == false) {
      return Container(
        decoration: BoxDecoration(
          color: widget.flag
              ? Colors.amber
              : (widget.revelado ? Colors.grey[300] : Colors.grey[600]),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: flag(),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: widget.flag
              ? Colors.amber
              : (widget.revelado ? Colors.red : Colors.grey[600]),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: flag(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: checarBomba(context),
      ),
    );
  }
}
