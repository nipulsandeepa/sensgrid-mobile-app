
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async'; // Add this for Timer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SensGrid IoT',
      theme: ThemeData(
        // Light theme
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E88E5),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // Dark theme
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
        ),
        cardColor: const Color(0xFF1E1E1E),
        dialogBackgroundColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: ESP32ControllerApp(
        toggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class ESP32ControllerApp extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ESP32ControllerApp({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<ESP32ControllerApp> createState() => _ESP32ControllerAppState();
}

class _ESP32ControllerAppState extends State<ESP32ControllerApp> with SingleTickerProviderStateMixin {
  String currentIP = 'http://192.168.4.1';
  late WebViewController controller;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  
  // Single AnimationController for the entire state
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize single loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _loadingAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
    
    _initializeWebView();
  }

  @override
  void dispose() {
    // Dispose the single AnimationController
    _loadingController.dispose();
    super.dispose();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              hasError = true;
              errorMessage = 'Connection Error: ${error.description}\n\n'
                           'Make sure:\n'
                           '1. You are connected to the correct WiFi\n'
                           '2. The device is powered on\n'
                           '3. Mobile Data is TURNED OFF\n'
                           '4. The IP address is correct: $currentIP';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(currentIP));
  }

  void _retryLoad() {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    controller.reload();
  }

  // Load SensGrid Website
  // void _loadSensGridWebsite() {
  //   setState(() {
  //     currentIP = 'https://sensegrid.sltdigitallab.lk/';
  //     isLoading = true;
  //     hasError = false;
  //   });
  //   controller.loadRequest(Uri.parse(currentIP));
  // }




  // // Load custom website
  // void _showCustomWebsiteDialog() {
  //   TextEditingController urlController = TextEditingController();
  //   bool isValidUrl = false;
  //   String validationMessage = '';

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           void validateUrl(String url) {
  //             // Basic URL validation
  //             bool isValid = url.isNotEmpty && 
  //                          (url.startsWith('http://') || url.startsWith('https://'));
  //             setDialogState(() {
  //               isValidUrl = isValid;
  //               validationMessage = isValid ? '' : 'Please enter a valid URL starting with http:// or https://';
  //             });
  //           }

  //           return AlertDialog(
  //             backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //             title: Column(
  //               children: [
  //                 Icon(
  //                   Icons.public,
  //                   size: 40,
  //                   color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'Open Website',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: widget.isDarkMode ? Colors.white : const Color(0xFF1565C0),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     'Enter website URL:',
  //                     style: TextStyle(
  //                       color: widget.isDarkMode ? Colors.white70 : Colors.black87,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextField(
  //                     controller: urlController,
  //                     decoration: InputDecoration(
  //                       hintText: 'https://example.com',
  //                       border: const OutlineInputBorder(),
  //                       labelText: 'Website URL',
  //                       prefixIcon: Icon(Icons.link, color: widget.isDarkMode ? Colors.white70 : null),
  //                       errorText: validationMessage.isNotEmpty ? validationMessage : null,
  //                       suffixIcon: isValidUrl && urlController.text.isNotEmpty
  //                           ? const Icon(Icons.check_circle, color: Colors.green)
  //                           : const Icon(Icons.error, color: Colors.red),
  //                       filled: widget.isDarkMode,
  //                       fillColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : null,
  //                     ),
  //                     style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
  //                     keyboardType: TextInputType.url,
  //                     onChanged: validateUrl,
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     'Must start with http:// or https://',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       color: widget.isDarkMode ? Colors.white54 : Colors.grey,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: Text(
  //                   'Cancel',
  //                   style: TextStyle(
  //                     color: widget.isDarkMode ? Colors.white70 : null,
  //                   ),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: isValidUrl ? () {
  //                   setState(() {
  //                     currentIP = urlController.text;
  //                     isLoading = true;
  //                     hasError = false;
  //                   });
  //                   Navigator.of(context).pop();
  //                   controller.loadRequest(Uri.parse(currentIP));
  //                 } : null,
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: isValidUrl 
  //                       ? (widget.isDarkMode ? const Color(0xFF1565C0) : const Color(0xFF1E88E5))
  //                       : Colors.grey,
  //                 ),
  //                 child: const Text('Open', style: TextStyle(color: Colors.white)),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }


// Load SensGrid Website - UPDATED VERSION
void _loadSensGridWebsite() {
  _loadWebsite('https://sensegrid.sltdigitallab.lk/');
}

// Load custom website - UPDATED VERSION
void _showCustomWebsiteDialog() {
  TextEditingController urlController = TextEditingController();
  bool isValidUrl = false;
  String validationMessage = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          void validateUrl(String url) {
            // Basic URL validation
            bool isValid = url.isNotEmpty && 
                         (url.startsWith('http://') || url.startsWith('https://'));
            setDialogState(() {
              isValidUrl = isValid;
              validationMessage = isValid ? '' : 'Please enter a valid URL starting with http:// or https://';
            });
          }

          return AlertDialog(
            backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Column(
              children: [
                Icon(
                  Icons.public,
                  size: 40,
                  color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Open Website',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter website URL:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.com',
                      border: const OutlineInputBorder(),
                      labelText: 'Website URL',
                      prefixIcon: Icon(Icons.link, color: widget.isDarkMode ? Colors.white70 : null),
                      errorText: validationMessage.isNotEmpty ? validationMessage : null,
                      suffixIcon: isValidUrl && urlController.text.isNotEmpty
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                      filled: widget.isDarkMode,
                      fillColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : null,
                    ),
                    style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    keyboardType: TextInputType.url,
                    onChanged: validateUrl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Must start with http:// or https://',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isDarkMode ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white70 : null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: isValidUrl ? () {
                  _loadWebsite(urlController.text);
                  Navigator.of(context).pop();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isValidUrl 
                      ? (widget.isDarkMode ? const Color(0xFF1565C0) : const Color(0xFF1E88E5))
                      : Colors.grey,
                ),
                child: const Text('Open', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}

// // NEW METHOD: Proper website loading
// void _loadWebsite(String url) {
//   setState(() {
//     currentIP = url;
//     isLoading = true;
//     hasError = false;
//   });

//   // Create a new WebViewController for the new website
//   controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onPageStarted: (String url) {
//           setState(() {
//             isLoading = true;
//             hasError = false;
//           });
//         },
//         onPageFinished: (String url) {
//           setState(() {
//             isLoading = false;
//           });
//         },
//         onWebResourceError: (WebResourceError error) {
//           setState(() {
//             isLoading = false;
//             hasError = true;
//             errorMessage = 'Website Error: ${error.description}\n\n'
//                          'Unable to load: $currentIP\n\n'
//                          'Please check:\n'
//                          '1. Internet connection\n'
//                          '2. URL is correct\n'
//                          '3. Website is available';
//           });
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse(currentIP));
// }







// UPDATED: Website loading with error delay
void _loadWebsite(String url) {
  setState(() {
    currentIP = url;
    isLoading = true;
    hasError = false;
    errorMessage = '';
  });

  // Timer to handle delayed errors
  Timer? errorTimer;

  controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA))
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          print('Page started loading: $url');
          // Cancel any pending error timer
          errorTimer?.cancel();
          setState(() {
            isLoading = true;
            hasError = false;
          });
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          // Cancel any pending error timer
          errorTimer?.cancel();
          setState(() {
            isLoading = false;
            hasError = false;
          });
        },
        onWebResourceError: (WebResourceError error) {
          print('WebResource Error: ${error.errorCode} - ${error.description}');
          
          // Delay error display to see if page still loads
          errorTimer?.cancel();
          errorTimer = Timer(const Duration(seconds: 3), () {
            // Only show error if we're still loading after the delay
            if (mounted && isLoading) {
              setState(() {
                isLoading = false;
                hasError = true;
                errorMessage = 'Failed to load: $currentIP\n\n'
                             'Error: ${error.description}\n\n'
                             'The website may be taking too long to load.';
              });
            }
          });
        },
      ),
    )
    ..loadRequest(Uri.parse(currentIP));
}











  // IP Address Validation Function
  bool _isValidIPAddress(String ip) {
    // Basic IP validation regex
    final ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    );
    return ipRegex.hasMatch(ip);
  }

  // Input formatter to restrict characters
  String _sanitizeIPInput(String input) {
    // Remove any characters that are not numbers or dots
    return input.replaceAll(RegExp(r'[^0-9.]'), '');

  }










  // void _showIPDialog() {
  //   TextEditingController ipController = TextEditingController(
  //     text: currentIP.replaceFirst('http://', '').replaceFirst('https://', '')
  //   );
  //   bool isValidIP = _isValidIPAddress(ipController.text);
  //   String validationMessage = '';

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           void validateIP(String ip) {
  //             final sanitizedIP = _sanitizeIPInput(ip);
  //             if (sanitizedIP != ip) {
  //               ipController.text = sanitizedIP;
  //               ipController.selection = TextSelection.fromPosition(
  //                 TextPosition(offset: sanitizedIP.length)
  //               );
  //             }
              
  //             final isValid = _isValidIPAddress(sanitizedIP);
  //             setDialogState(() {
  //               isValidIP = isValid;
  //               validationMessage = isValid ? '' : 'Please enter a valid IP address';
  //             });
  //           }

  //           return AlertDialog(
  //             backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //             title: Column(
  //               children: [
  //                 Icon(
  //                   Icons.settings_ethernet,
  //                   size: 40,
  //                   color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'Change Device IP',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: widget.isDarkMode ? Colors.white : const Color(0xFF1565C0),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     'Enter the IP address of your IoT device:',
  //                     style: TextStyle(
  //                       color: widget.isDarkMode ? Colors.white70 : Colors.black87,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextField(
  //                     controller: ipController,
  //                     decoration: InputDecoration(
  //                       hintText: '192.168.4.1',
  //                       border: const OutlineInputBorder(),
  //                       labelText: 'IP Address',
  //                       prefixIcon: Icon(Icons.computer, color: widget.isDarkMode ? Colors.white70 : null),
  //                       errorText: validationMessage.isNotEmpty ? validationMessage : null,
  //                       suffixIcon: isValidIP && ipController.text.isNotEmpty
  //                           ? const Icon(Icons.check_circle, color: Colors.green)
  //                           : const Icon(Icons.error, color: Colors.red),
  //                       filled: widget.isDarkMode,
  //                       fillColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : null,
  //                     ),
  //                     style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
  //                     keyboardType: TextInputType.numberWithOptions(decimal: true),
  //                     onChanged: validateIP,
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     'Format: XXX.XXX.XXX.XXX',
  //                     style: TextStyle(
  //                       fontSize: 11,
  //                       color: widget.isDarkMode ? Colors.white54 : Colors.grey,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: Text(
  //                   'Cancel',
  //                   style: TextStyle(
  //                     color: widget.isDarkMode ? Colors.white70 : null,
  //                   ),
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: isValidIP ? () {
  //                   setState(() {
  //                     currentIP = 'http://${ipController.text}';
  //                   });
  //                   Navigator.of(context).pop();
  //                   _initializeWebView();
  //                 } : null,
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: isValidIP 
  //                       ? (widget.isDarkMode ? const Color(0xFF1565C0) : const Color(0xFF1E88E5))
  //                       : Colors.grey,
  //                 ),
  //                 child: const Text('Save', style: TextStyle(color: Colors.white)),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }



void _showIPDialog() {
  // Check if currentIP is a website URL or an IP address
  String displayText;
  if (currentIP.startsWith('http://192.168.') || 
      currentIP.startsWith('http://10.') ||
      currentIP.startsWith('http://172.') ||
      _isValidIPAddress(currentIP.replaceAll('http://', '').replaceAll('https://', ''))) {
    // It's an IP address - show without protocol
    displayText = currentIP.replaceFirst('http://', '').replaceFirst('https://', '');
  } else {
    // It's a website - show default ESP32 IP
    displayText = '192.168.4.1';
  }

  TextEditingController ipController = TextEditingController(text: displayText);
  bool isValidIP = _isValidIPAddress(ipController.text);
  String validationMessage = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          void validateIP(String ip) {
            final sanitizedIP = _sanitizeIPInput(ip);
            if (sanitizedIP != ip) {
              ipController.text = sanitizedIP;
              ipController.selection = TextSelection.fromPosition(
                TextPosition(offset: sanitizedIP.length)
              );
            }
            
            final isValid = _isValidIPAddress(sanitizedIP);
            setDialogState(() {
              isValidIP = isValid;
              validationMessage = isValid ? '' : 'Please enter a valid IP address';
            });
          }

          return AlertDialog(
            backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Column(
              children: [
                Icon(
                  Icons.settings_ethernet,
                  size: 40,
                  color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                ),
                const SizedBox(height: 8),
                Text(
                  'Change Device IP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter the IP address of your IoT device:',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      hintText: '192.168.4.1',
                      border: const OutlineInputBorder(),
                      labelText: 'IP Address',
                      prefixIcon: Icon(Icons.computer, color: widget.isDarkMode ? Colors.white70 : null),
                      errorText: validationMessage.isNotEmpty ? validationMessage : null,
                      suffixIcon: isValidIP && ipController.text.isNotEmpty
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.error, color: Colors.red),
                      filled: widget.isDarkMode,
                      fillColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : null,
                    ),
                    style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: validateIP,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Format: XXX.XXX.XXX.XXX',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isDarkMode ? Colors.white54 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Note: For websites, use the globe icon',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isDarkMode ? Colors.orange : Colors.blue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white70 : null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: isValidIP ? () {
                  setState(() {
                    currentIP = 'http://${ipController.text}';
                  });
                  Navigator.of(context).pop();
                  _initializeWebView();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isValidIP 
                      ? (widget.isDarkMode ? const Color(0xFF1565C0) : const Color(0xFF1E88E5))
                      : Colors.grey,
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}
















  Widget _buildLoadingScreen() {
    return Container(
      color: widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing SensGrid Logo using the single AnimationController
              ScaleTransition(
                scale: _loadingAnimation,
                child: Column(
                  children: [
                    Icon(
                      Icons.radar,
                      size: 80,
                      color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'SensGrid',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                      ),
                    ),
                    Text(
                      'IoT Platform',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.isDarkMode ? Colors.white70 : const Color(0xFF546E7A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Animated loading indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFE3F2FD),
                  color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              
              // Loading text
              Text(
                'Connecting to your device...',
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.white70 : const Color(0xFF546E7A),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Animated dots using the same AnimationController
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedDot(0),
                  _buildAnimatedDot(1),
                  _buildAnimatedDot(2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        final delay = index * 200;
        final animationValue = (_loadingController.value * 1000 + delay) % 1000 / 1000;
        final scale = 0.5 + animationValue * 0.5;
        
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      color: widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.signal_wifi_connected_no_internet_4,
                size: 72,
                color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
              ),
              const SizedBox(height: 24),
              Text(
                'Unable to Connect to Device',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1565C0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isDarkMode ? Colors.white70 : const Color(0xFF546E7A),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _retryLoad,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isDarkMode ? const Color(0xFF1565C0) : const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _showIPDialog,
                child: Text(
                  'Change IP Address',
                  style: TextStyle(
                    color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SensGrid IoT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Device Controller',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: widget.isDarkMode ? const Color(0xFF0D47A1) : const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // 👇🏽 NEW WEBSITE BUTTONS
          PopupMenuButton<String>(
            icon: const Icon(Icons.public, size: 22),
            tooltip: 'Website Options',
            onSelected: (value) {
              if (value == 'sensgrid') {
                _loadSensGridWebsite();
              } else if (value == 'custom') {
                _showCustomWebsiteDialog();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'sensgrid',
                child: Row(
                  children: [
                    Icon(Icons.home, color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5)),
                    const SizedBox(width: 8),
                    const Text('SensGrid Website'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'custom',
                child: Row(
                  children: [
                    Icon(Icons.link, color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5)),
                    const SizedBox(width: 8),
                    const Text('Custom Website'),
                  ],
                ),
              ),
            ],
          ),
          // Theme toggle button
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              size: 22,
            ),
            onPressed: widget.toggleTheme,
            tooltip: widget.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
          IconButton(
            icon: const Icon(Icons.settings_input_component, size: 22),
            onPressed: _showIPDialog,
            tooltip: 'Change IP Address',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 22),
            onPressed: _retryLoad,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection info with mobile data warning
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: widget.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFE3F2FD),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Connected to:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  currentIP,
                  style: TextStyle(
                    color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Mobile data warning
                // Text(
                //   '⚠️ Make sure Mobile Data is OFF',
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.orange,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 4),
                Text(
                  'Use the website button for SensGrid or other sites',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isDarkMode ? Colors.white70 : const Color(0xFF546E7A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Loading indicator
          if (isLoading)
            SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                backgroundColor: widget.isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFE3F2FD),
                color: widget.isDarkMode ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5),
              ),
            ),

          // Main content area
          Expanded(
            child: isLoading
                ? _buildLoadingScreen()
                : hasError
                    ? _buildErrorScreen()
                    : WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }
}