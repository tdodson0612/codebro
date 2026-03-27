import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/user_code_storage.dart';

// NOTE: For JavaScript execution install the flutter_js package.
// For Python execution, use the webview_flutter package with Pyodide.
// For other languages (C, C++, Java, C#, Kotlin), use a code execution API.
// Replace 'https://your-code-runner-api.com/run' with your actual API endpoint.

class MultiLangConsolePage extends StatefulWidget {
  final String initialCode;
  final String language;
  final String lessonTitle;

  MultiLangConsolePage({
    required this.initialCode,
    required this.language,
    required this.lessonTitle,
  });

  @override
  _MultiLangConsolePageState createState() => _MultiLangConsolePageState();
}

class _MultiLangConsolePageState extends State<MultiLangConsolePage> {
  late TextEditingController _codeController;
  late TextEditingController _inputController;
  String _output = '';
  bool _isRunning = false;
  bool _showInput = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialCode);
    _inputController = TextEditingController();
    _loadSavedCode();
  }

  Future<void> _loadSavedCode() async {
    final saved = await UserCodeStorage.loadCode(
        widget.language, widget.lessonTitle, widget.initialCode);
    setState(() => _codeController.text = saved);
  }

  Future<void> _saveCode() async {
    await UserCodeStorage.saveCode(
        widget.language, widget.lessonTitle, _codeController.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Code saved!')));
  }

  Future<void> _resetCode() async {
    setState(() => _codeController.text = widget.initialCode);
    await UserCodeStorage.clearCode(widget.language, widget.lessonTitle);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Code reset to original.')));
  }

  Future<void> runCode() async {
    setState(() {
      _isRunning = true;
      _output = 'Running...';
    });

    final lang = widget.language.toLowerCase();

    try {
      if (lang == 'javascript') {
        // For JS, you would use flutter_js:
        // final result = jsRuntime.evaluate(_codeController.text);
        // setState(() => _output = result.stringResult);
        setState(() => _output =
            '// JavaScript execution requires the flutter_js package.\n'
            '// Install it and uncomment the JS runtime code.\n'
            '// For now, copy this code to a browser console to test.');
      } else if (lang == 'python') {
        setState(() => _output =
            '# Python execution requires the webview_flutter + Pyodide setup.\n'
            '# See the PythonWebViewPage widget in the codebase.\n'
            '# For now, copy this code to run in Python.');
      } else {
        // For compiled languages, use a remote API
        final response = await http.post(
          Uri.parse('https://your-code-runner-api.com/run'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'language': lang,
            'code': _codeController.text,
            'input': _inputController.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() => _output = data['output'] ?? 'No output');
        } else {
          setState(() =>
              _output = 'API Error: ${response.statusCode}\n${response.body}');
        }
      }
    } catch (e) {
      setState(() => _output = 'Error: $e');
    }

    setState(() => _isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.language} Console'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: Icon(Icons.input),
            tooltip: 'Toggle stdin input',
            onPressed: () => setState(() => _showInput = !_showInput),
          ),
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save code',
            onPressed: _saveCode,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Reset to original',
            onPressed: _resetCode,
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // Code editor
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: TextField(
                  controller: _codeController,
                  maxLines: null,
                  expands: true,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.lightGreenAccent,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    hintText: 'Enter ${widget.language} code here...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),

            // Optional stdin input
            if (_showInput) ...[
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey),
                ),
                child: TextField(
                  controller: _inputController,
                  style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    hintText: 'Program input (stdin)...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],

            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isRunning
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.play_arrow),
                label: Text(_isRunning ? 'Running...' : 'Run Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isRunning ? null : runCode,
              ),
            ),

            SizedBox(height: 8),

            // Output console
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[900]!),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _output.isEmpty ? '// Output will appear here' : _output,
                    style: TextStyle(
                      color: _output.startsWith('Error')
                          ? Colors.redAccent
                          : Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _inputController.dispose();
    super.dispose();
  }
}