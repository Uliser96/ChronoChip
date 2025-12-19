import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'bloc/gender_bloc.dart';
import 'bloc/gender_event.dart';
import 'bloc/gender_state.dart';
import 'bloc/register_bloc.dart';
import 'package:chronochip/src/presentation/code_validation/code_validation_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Gender? _selectedGender;
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isEmailValid() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  bool _isDobValid() {
    final text = _dobController.text.trim();
    if (text.isEmpty) return false;
    final parsed = DateTime.tryParse(text);
    if (parsed == null) return false;
    final today = DateTime.now();
    final parsedDate = DateTime(parsed.year, parsed.month, parsed.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    return parsedDate.isBefore(todayDate) ||
        parsedDate.isAtSameMomentAs(todayDate);
  }

  bool _isNameValid() {
    return _nameController.text.trim().isNotEmpty;
  }

  bool _isSurnameValid() {
    return _surnameController.text.trim().isNotEmpty;
  }

  bool _isPasswordValid() {
    final value = _passwordController.text;
    if (value.isEmpty) return false;
    if (value.length < 8) return false;
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$',
    );
    return regex.hasMatch(value);
  }

  void _onDobChanged(String _) => setState(() {});
  void _onEmailChanged(String _) => setState(() {});
  void _onNameChanged(String _) => setState(() {});
  void _onSurnameChanged(String _) => setState(() {});
  void _onPasswordChanged(String _) => setState(() {});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenderBloc>().add(const GendersFetch());
    });
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final media = MediaQuery.of(context);
    final availableHeight =
        media.size.height - bottomInset - media.padding.vertical;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/imgs/main_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset + 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: Center(
                    child: BlocProvider<RegisterBloc>(
                      create: (_) => RegisterBloc(),
                      child: BlocListener<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Navigate to code validation screen after successful register
                            Future.microtask(() {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CodeValidationPage(
                                    email: _emailController.text.trim(),
                                  ),
                                ),
                              );
                            });
                          } else if (state is RegisterFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: media.size.width * 0.82,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Registro Usuario',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 12),

                              // Name field
                              TextField(
                                controller: _nameController,
                                onChanged: _onNameChanged,
                                decoration: InputDecoration(
                                  hintText: 'Nombre',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  errorText:
                                      !_isNameValid() &&
                                          _nameController.text.isNotEmpty
                                      ? 'El nombre no puede estar vacío'
                                      : null,
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Surname field
                              TextField(
                                controller: _surnameController,
                                onChanged: _onSurnameChanged,
                                decoration: InputDecoration(
                                  hintText: 'Apellidos',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  errorText:
                                      !_isSurnameValid() &&
                                          _surnameController.text.isNotEmpty
                                      ? 'Los apellidos no pueden estar vacíos'
                                      : null,
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Email field
                              TextField(
                                controller: _emailController,
                                onChanged: _onEmailChanged,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Correo electrónico',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  errorText:
                                      _emailController.text.isNotEmpty &&
                                          !_isEmailValid()
                                      ? 'Formato de correo inválido'
                                      : null,
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Date of birth field (opens calendar)
                              TextField(
                                controller: _dobController,
                                readOnly: true,
                                onTap: () async {
                                  final initialDate =
                                      _dobController.text.isNotEmpty
                                      ? DateTime.tryParse(
                                              _dobController.text,
                                            ) ??
                                            DateTime.now()
                                      : DateTime.now();
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: initialDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      final theme = Theme.of(context);
                                      final colorScheme = theme.colorScheme
                                          .copyWith(
                                            primary: AppColors.primary,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          );
                                      return Theme(
                                        data: theme.copyWith(
                                          colorScheme: colorScheme,
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primary,
                                            ),
                                          ),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child ?? const SizedBox.shrink(),
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    _dobController.text = picked
                                        .toIso8601String()
                                        .split('T')
                                        .first;
                                    setState(() {});
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Fecha de nacimiento',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  errorText:
                                      _dobController.text.isNotEmpty &&
                                          !_isDobValid()
                                      ? 'Fecha inválida o futura'
                                      : null,
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Gender dropdown
                              BlocBuilder<GenderBloc, GenderState>(
                                builder: (context, state) {
                                  if (state is GenderFailure) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Error: ${state.error}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }

                                  List<Gender> genders = [];
                                  bool isLoading = false;
                                  if (state is GenderSuccess) {
                                    genders = state.genders;
                                  } else if (state is GenderLoading) {
                                    isLoading = true;
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButton<Gender>(
                                      isExpanded: true,
                                      underline: const SizedBox.shrink(),
                                      hint: const Text(
                                        'Selecciona tu género',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      value: _selectedGender,
                                      items: genders.map((gender) {
                                        return DropdownMenuItem<Gender>(
                                          value: gender,
                                          child: Text(
                                            gender.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: isLoading || genders.isEmpty
                                          ? null
                                          : (Gender? selectedGender) {
                                              setState(() {
                                                _selectedGender =
                                                    selectedGender;
                                              });
                                            },
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      dropdownColor: AppColors.primary
                                          .withOpacity(0.9),
                                      disabledHint: isLoading
                                          ? const Text(
                                              'Cargando géneros...',
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),

                              // Password policy legend: show only while focused AND when password is invalid
                              if (_passwordFocusNode.hasFocus &&
                                  !_isPasswordValid())
                                Container(
                                  margin: EdgeInsets.zero,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              // Password field
                              TextField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                obscureText: _obscurePassword,
                                onChanged: _onPasswordChanged,
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                    splashRadius: 18,
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),

                              // Complete register button (connected to RegisterBloc)
                              BlocBuilder<RegisterBloc, RegisterState>(
                                builder: (context, state) {
                                  final isLoading = state is RegisterLoading;
                                  final isFormReady =
                                      _isPasswordValid() &&
                                      _isEmailValid() &&
                                      _isDobValid() &&
                                      _isNameValid() &&
                                      _isSurnameValid() &&
                                      _selectedGender != null;

                                  return ElevatedButton(
                                    onPressed: isLoading || !isFormReady
                                        ? null
                                        : () {
                                            context.read<RegisterBloc>().add(
                                              RegisterSubmitted(
                                                email: _emailController.text
                                                    .trim(),
                                                password:
                                                    _passwordController.text,
                                                firstName: _nameController.text
                                                    .trim(),
                                                lastName: _surnameController
                                                    .text
                                                    .trim(),
                                                birthdate: _dobController.text
                                                    .trim(),
                                                genderId: _selectedGender!.id,
                                              ),
                                            );
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.primary,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Completar registro',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
