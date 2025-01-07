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

  // Define a GET endpoint to calculate PI to the nth hex place
  app.get('/pi/<n>', (shelf.Request request, String n) {
    print ("New request from: " + request.url.path);
    final int hexPlaces = int.tryParse(n) ?? 0;
    final piValue = calculatePi(hexPlaces);
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
  // was added for testing purposes, leaving it commented out for now.
  // app.mount('/RESTCalculatePI_Files/', stat.createStaticHandler (r'.\', defaultDocument: 'index.html', listDirectories: true, serveFilesOutsidePath: false));

  final server = await io.serve(app, '127.0.0.1', 8080);// using localhost means 127.0.0.1 won't work. Stick to 127.0.0.1
  print('Server listening on ${server.address}:${server.port}');
}

// Function to calculate PI to the nth hexadecimal place. In DART, the build-in constant holding PI can provide only up to 20 fractional decimal digits.
String calculatePi(int n) {
  String out = "";
  // Provide the decimal values of PI in a range of n to n+10
  
  for (int cnt = n;cnt < n + 14;cnt++)
  {
    out += piDigit (cnt).toRadixString(16);
  }

  return out;//double.parse(pi.toStringAsFixed(n));
}


// Bailey-Borwein-Plouffe-Algorithm from https://web.archive.org/web/20150627225748/http://en.literateprograms.org/Pi_with_the_BBP_formula_%28Python%29 & https://stackoverflow.com/q/12449430
/**
 * Computes the nth digit of Pi in base-16.
 *
 * If n < 0, return -1.
 *
 * @param n The digit of Pi to retrieve in base-16.
 * @return The nth digit of Pi in base-16.
 */
int piDigit(int n) {
    if (n < 0) return -1;

    n -= 1;
    double x = 4 * piTerm(1, n) - 2 * piTerm(4, n) -
               piTerm(5, n) - piTerm(6, n);
    x = x - x.floorToDouble();//Math.floor(x);

    return /*(int)*/(x * 16).toInt();
}

double piTerm(int j, int n) {
    // Calculate the left sum
    double s = 0;
    for (int k = 0; k <= n; ++k) {
        int r = 8 * k + j;
        s += powerMod(16, n-k, r) / /*(double)*/ r.toDouble();
        s = s - /*Math.floor*/(s.floorToDouble());
    }

    // Calculate the right sum
    double t = 0;
    int k = n+1;
    // Keep iterating until t converges (stops changing)
    while (true) {
        int r = 8 * k + j;
        double newt = t + /*Math.*/pow(16, n-k) / r;
        if (t == newt) {
            break;
        } else {
            t = newt;
        }
        ++k;
    }

    return s+t;
}

int powerMod(int base, int exponent, int modulus)
{
    /*BigInteger*/int n = 1;//BigInteger.ONE;
    for (int i = 0; i < exponent; ++i) {
        n = n/*.multiply*/ * (/*BigInteger.valueOf*/(base));
    }
    // n = n.mod(BigInteger.valueOf(modulus));
    n = n % modulus;
    // n is now guaranteed to be < modulus, so n definitely fits into an int
    return n.toInt();//n.intValue();
}