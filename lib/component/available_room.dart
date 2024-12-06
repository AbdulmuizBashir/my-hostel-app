import 'package:flutter/material.dart';

class AvailableRoom extends StatelessWidget {
  final void Function()? onTap;
  final String imagePath;
  final bool isApplied;
  final String price;

  const AvailableRoom({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.price,
    this.isApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500.withOpacity(0.2),
              offset: const Offset(0, 5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
                height: 300,
                child: Image.asset(imagePath),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffE5E5E5),
                      ),
                      child: Text(price,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ))),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          isApplied ? 'Applied' : 'Book Now',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
