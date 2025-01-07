import 'dart:math';
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart' as stat;
import 'package:shelf_router/shelf_router.dart';

// More examples: https://pub.dev/packages/shelf_router/example
// More features available with https://pub.dev/packages/shelf_plus
void main() async {
  final app = Router();

  // Define a GET endpoint to calculate PI to the nth decimal place
  app.get('/pi/<n>', (shelf.Request request, String n) {
    print ("New request from: " + request.url.path);
    final int decimalPlaces = int.tryParse(n) ?? 0;
    final piValue = calculatePi(decimalPlaces);
    return shelf.Response.ok(piValue.toString());
  });

  // Hello World response
  app.get('/HelloWorld', (shelf.Request request/*, String n*/) {
    print ("New request from: " + request.url.path);
    //print ("Context: " + request.context.toString());
    print ("Remote Address: " + (request.context ['shelf.io.connection_info'] as HttpConnectionInfo).remoteAddress.toString());
    return shelf.Response.ok("Hello World!!!");
  });  // Start the server


  // Provide a custom message when favicon.ico is requested
  app.get('/favicon.ico', (shelf.Request request/*, String n*/) {
    print ("Fav Icon Requested!");
    return shelf.Response.notFound("No Fav Icon available :(");
  });  // Start the server

  // Mount a directory, and show the directory if there's no default index.html file
  app.mount('/RESTCalculatePI_Files/', stat.createStaticHandler (r'.\', defaultDocument: 'index.html', listDirectories: true, serveFilesOutsidePath: false));

  final server = await io.serve(app, '127.0.0.1', 8080);// using localhost means 127.0.0.1 won't work. Stick to 127.0.0.1
  print('Server listening on ${server.address}:${server.port}');
}

// Function to calculate PI to the nth decimal place (up to 20, limitation in DART). Later, we can manually generate further decimals for PI directly.
double calculatePi(int n) {
  return double.parse(pi.toStringAsFixed(n));
}