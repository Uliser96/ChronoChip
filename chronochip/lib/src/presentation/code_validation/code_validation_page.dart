import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/verify_bloc.dart';
import 'package:chronochip/src/core/routers/routers.dart';

class CodeValidationPage extends StatefulWidget {
  final String email;
  const CodeValidationPage({super.key, required this.email});

  @override
  State<CodeValidationPage> createState() => _CodeValidationPageState();
}

class _CodeValidationPageState extends State<CodeValidationPage> {
  final int length = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(length, (_) => TextEditingController());
    _focusNodes = List.generate(length, (_) => FocusNode());
    // Autofocus first field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _isComplete => _controllers.every((c) => c.text.trim().isNotEmpty);

  void _onChanged(String value, int index) {
    if (value.isEmpty) {
      // If user deleted current box, move focus to previous and clear it
      if (index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
      }
      return;
    }

    // Keep only last character entered
    final ch = value.characters.last;
    _controllers[index].text = ch;
    _controllers[index].selection = const TextSelection.collapsed(offset: 1);

    if (index + 1 < length) {
      _focusNodes[index + 1].requestFocus();
    } else {
      // last box filled
      if (_isComplete) setState(() {});
    }
  }

  void _onComplete() {
    // kept for compatibility; prefer dispatch from the button
    final code = _controllers.map((c) => c.text).join();
    // no-op: actual dispatch happens from the Verify button to ensure correct context
    debugPrint('Code ready: $code');
  }

  Widget _buildBox(int index) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.primary.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (v) => _onChanged(v, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VerifyBloc>(
      create: (_) => VerifyBloc(),
      child: BlocListener<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to login and clear stack
            Future.microtask(() {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(Routers.login, (r) => false);
            });
          } else if (state is VerifyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text('Verificación'),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Introduce el código de verificación',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildBox(i),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<VerifyBloc, VerifyState>(
                    builder: (context, state) {
                      final isLoading = state is VerifyLoading;
                      return ElevatedButton(
                        onPressed: _isComplete && !isLoading
                            ? () {
                                final code = _controllers
                                    .map((c) => c.text)
                                    .join();
                                context.read<VerifyBloc>().add(
                                  VerifySubmitted(
                                    email: widget.email,
                                    code: code,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Verificar'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
