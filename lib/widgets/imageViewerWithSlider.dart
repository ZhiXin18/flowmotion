import 'package:flowmotion/models/rating_point.dart';
import 'package:flutter/material.dart';

class ImageViewerWithSlider extends StatefulWidget {
  final List<RatingPoint> data;
  ImageViewerWithSlider({required this.data});

  @override
  _ImageViewerWithSliderState createState() => _ImageViewerWithSliderState();
}

class _ImageViewerWithSliderState extends State<ImageViewerWithSlider> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Text("No images available");
    }

    // Get the current RatingPoint based on the slider value
    int currentIndex = _currentSliderValue.toInt();
    RatingPoint currentRatingPoint = widget.data[currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display the image
        Container(
          height: 200,
          width: 200,
          margin: EdgeInsets.all(5),
          child: Image.network(currentRatingPoint.imageUrls, fit: BoxFit.cover),
        ),

        // Display the time
        Text(
          "Time - ${currentRatingPoint.ratedOn.hour}:00",
          style: TextStyle(fontSize: 16),
        ),

        // Slider to change the image based on the time
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: (widget.data.length - 1).toDouble(),
          divisions: widget.data.length - 1,
          label:
              "Time - ${currentRatingPoint.ratedOn.hour}:00}",
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
      ],
    );
  }
}
