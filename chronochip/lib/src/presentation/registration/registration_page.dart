import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/registration_bloc.dart';
import 'bloc/registration_event.dart';
import 'bloc/registration_state.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/states_response/datum.dart';
import 'package:chronochip/src/core/models/tshirt_sizes_response/datum.dart'
    as TshirtDatum;
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/models/runner_response.dart';
import 'package:chronochip/src/core/models/race_registration_response/race_registration_response.dart';
import 'package:chronochip/src/core/routers/routers.dart';

class RegistrationPage extends StatefulWidget {
  final bool allowTshirtSize;
  final int eventId;

  const RegistrationPage({
    super.key,
    this.allowTshirtSize = false,
    this.eventId = 0,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _teamController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _cityController;
  String? _selectedRunner;
  final List<String> _self_runners = [];
  String? _selectedSelfRunner;
  bool _isSelfRegistration = false;
  int _selectedRunnerId = 0;
  Gender? _selectedSex;
  late RegistrationBloc _bloc;
  Datum? _selectedState;
  String? _selectedCategory;
  String? _selectedJersey;
  bool _isConfirmed = false;
  bool _isSubmitting = false;
  RaceRegistrationResponse? _raceRegistrationResponse;
  bool _hasShownNoCategoriesDialog = false;
  bool _hasRequestedCategories = false;
  bool _isEmailValid = true;
  bool _isNameValid = true;
  bool _isSurnameValid = true;
  bool _isDobValid = true;
  bool _isPhoneValid = true;
  bool _isEmergencyPhoneValid = true;
  bool _isCityValid = true;
  // Dropdown validation flags
  bool _isSexValid = true;
  bool _isStateValid = true;
  bool _isCategoryValid = true;
  bool _isJerseyValid = true;

  void _resetForm() {
    // Reset controllers
    _nameController.clear();
    _surnameController.clear();
    _teamController.clear();
    _dobController.clear();
    _emailController.clear();
    _phoneController.clear();
    _emergencyPhoneController.clear();
    _cityController.clear();

    // Reset selections
    setState(() {
      _selectedRunner = null;
      _selectedSelfRunner = null;
      _isSelfRegistration = false;
      _selectedRunnerId = 0;
      _selectedSex = null;
      _selectedState = null;
      _selectedCategory = null;
      _selectedJersey = null;
      _isConfirmed = false;

      // Reset validation flags to defaults
      _isEmailValid = true;
      _isNameValid = true;
      _isSurnameValid = true;
      _isDobValid = true;
      _isPhoneValid = true;
      _isEmergencyPhoneValid = true;
      _isCityValid = true;
      _isSexValid = true;
      _isStateValid = true;
      _isCategoryValid = true;
      _isJerseyValid = true;
    });

    // Re-fetch static lists to ensure consistent state
    _bloc.add(const FetchGendersRequested());
    _bloc.add(const FetchStatesRequested());
    _bloc.add(const FetchRunnersRequested());
  }

  bool _isEmailFormatValid(String email) {
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _bloc = RegistrationBloc();
    _bloc.add(const FetchGendersRequested());
    _bloc.add(const FetchStatesRequested());
    _bloc.add(const FetchRunnersRequested());
    _self_runners.addAll(['Yo mismo', 'Otra persona']);
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _teamController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _cityController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _bloc.close();
    _nameController.dispose();
    _surnameController.dispose();
    _teamController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    _cityController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/imgs/main_background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.82,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Inscripción a carrera',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                      // Clean/reset button (icon only)
                                      IconButton(
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(
                                          Icons.cleaning_services_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: _resetForm,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  //self runner
                                  Container(
                                    height: 48,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: const SizedBox.shrink(),
                                      hint: const Text(
                                        'Quién se inscribe',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      value: _selectedSelfRunner,
                                      items: _self_runners
                                          .map(
                                            (r) => DropdownMenuItem<String>(
                                              value: r,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 12,
                                                    ),
                                                child: Text(
                                                  r,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? val) {
                                        if (val == _self_runners[0]) {
                                          //consultar servicio y deshabilitar todos los campos
                                          //deshabilitar todos los campos
                                        } else {}
                                        setState(() {
                                          _selectedSelfRunner = val;
                                          _isSelfRegistration =
                                              val == _self_runners[0];
                                          //exec service, fill ruuner info with response and set validation flags
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      dropdownColor: const Color.fromRGBO(
                                        241,
                                        136,
                                        0,
                                        0.9,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (!_isSelfRegistration) ...[
                                    // Corredores dropdown
                                    const SizedBox(height: 8),
                                    BlocBuilder<
                                      RegistrationBloc,
                                      RegistrationState
                                    >(
                                      builder: (context, state) {
                                        return Container(
                                          height: 48,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              0.18,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            underline: const SizedBox.shrink(),
                                            hint: const Text(
                                              'corredores',
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            value: _selectedRunner,
                                            items: state.runners
                                                .map(
                                                  (
                                                    r,
                                                  ) => DropdownMenuItem<String>(
                                                    value: r.id.toString(),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 12,
                                                          ),
                                                      child: Text(
                                                        '${r.firstName} ${r.lastName}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: state.runners.isEmpty
                                                ? null
                                                : (String? val) {
                                                    setState(() {
                                                      _selectedRunner = val;
                                                      _selectedRunnerId =
                                                          int.tryParse(
                                                            val ?? '',
                                                          ) ??
                                                          0;
                                                      if (_selectedRunnerId !=
                                                          0) {
                                                        final runner = state
                                                            .runners
                                                            .firstWhere(
                                                              (x) =>
                                                                  x.id ==
                                                                  _selectedRunnerId,
                                                              orElse: () =>
                                                                  state
                                                                      .runners
                                                                      .first,
                                                            );
                                                        _nameController.text =
                                                            runner.firstName;
                                                        _surnameController
                                                                .text =
                                                            runner.lastName;
                                                        _dobController.text =
                                                            runner.birthdate;
                                                        // Validate filled fields
                                                        _emailController.text =
                                                            runner.email;
                                                        _phoneController.text =
                                                            runner.phone;
                                                        _emergencyPhoneController
                                                            .text = runner
                                                            .emergencyPhone;
                                                        _cityController.text =
                                                            runner.city;
                                                        _teamController.text =
                                                            runner.teamName;
                                                        // Mark newly filled fields as valid when possible
                                                        _isEmailValid =
                                                            _isEmailFormatValid(
                                                              runner.email,
                                                            );
                                                        final phoneTrim = runner
                                                            .phone
                                                            .trim();
                                                        _isPhoneValid =
                                                            phoneTrim.length ==
                                                            10;
                                                        final emergTrim = runner
                                                            .emergencyPhone
                                                            .trim();
                                                        _isEmergencyPhoneValid =
                                                            emergTrim.length ==
                                                            10;
                                                        _isCityValid =
                                                            (runner.city)
                                                                .trim()
                                                                .isNotEmpty;
                                                        final matched = state
                                                            .genders
                                                            .where(
                                                              (g) =>
                                                                  g.id ==
                                                                  runner
                                                                      .genderId,
                                                            )
                                                            .toList();
                                                        _selectedSex =
                                                            matched.isNotEmpty
                                                            ? matched.first
                                                            : null;
                                                        _isSexValid =
                                                            _selectedSex !=
                                                            null;
                                                        final matchedState = state
                                                            .states
                                                            .where(
                                                              (s) =>
                                                                  s.id ==
                                                                  runner
                                                                      .stateId,
                                                            )
                                                            .toList();
                                                        _selectedState =
                                                            matchedState
                                                                .isNotEmpty
                                                            ? matchedState.first
                                                            : null;
                                                        _isStateValid =
                                                            _selectedState !=
                                                            null;
                                                        _isNameValid = true;
                                                        _isSurnameValid = true;
                                                        _isDobValid = true;
                                                        _isSexValid = true;
                                                        _isEmailValid = true;
                                                        _isPhoneValid = true;
                                                        _isEmergencyPhoneValid =
                                                            true;
                                                        _isCityValid = true;
                                                        _isStateValid = true;
                                                      }
                                                    });
                                                    // After populating runner info, request tshirt sizes and categories
                                                    if (_selectedSex != null) {
                                                      _bloc.add(
                                                        FetchTshirtSizesRequested(
                                                          eventId:
                                                              widget.eventId,
                                                          genderId:
                                                              _selectedSex!.id,
                                                        ),
                                                      );
                                                    }
                                                    if (_selectedSex != null &&
                                                        _dobController
                                                            .text
                                                            .isNotEmpty) {
                                                      setState(() {
                                                        _hasRequestedCategories =
                                                            true;
                                                        _hasShownNoCategoriesDialog =
                                                            false;
                                                      });
                                                      _bloc.add(
                                                        FetchCategoriesRequested(
                                                          eventId:
                                                              widget.eventId,
                                                          genderId:
                                                              _selectedSex!.id,
                                                          birthdate:
                                                              _dobController
                                                                  .text,
                                                        ),
                                                      );
                                                    }
                                                  },
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            dropdownColor: const Color.fromRGBO(
                                              241,
                                              136,
                                              0,
                                              0.9,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 12),
                                  ],

                                  // Nombre
                                  TextField(
                                    controller: _nameController,
                                    onChanged: (val) {
                                      if (!_isNameValid &&
                                          val.trim().isNotEmpty) {
                                        setState(() {
                                          _isNameValid = true;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Nombres',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isNameValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isNameValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Apellidos
                                  TextField(
                                    controller: _surnameController,
                                    onChanged: (val) {
                                      if (!_isSurnameValid &&
                                          val.trim().isNotEmpty) {
                                        setState(() {
                                          _isSurnameValid = true;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Apellidos',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isSurnameValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isSurnameValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Sexo dropdown
                                  const SizedBox(height: 8),
                                  BlocBuilder<
                                    RegistrationBloc,
                                    RegistrationState
                                  >(
                                    builder: (context, state) {
                                      final boxDecoration = BoxDecoration(
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          0.18,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: _isSexValid
                                            ? null
                                            : Border.all(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      );

                                      if (!state.isLoadingCategories &&
                                          state.categories.isEmpty &&
                                          _hasRequestedCategories &&
                                          !_hasShownNoCategoriesDialog) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              if (!mounted) return;
                                              setState(() {
                                                _hasShownNoCategoriesDialog =
                                                    true;
                                              });
                                              showDialog<void>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  content: const Text(
                                                    'No hay categorías para la información seleccionada.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(),
                                                      child: const Text(
                                                        'Aceptar',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }
                                      return Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: boxDecoration,
                                        child: DropdownButton<Gender>(
                                          isExpanded: true,
                                          underline: const SizedBox.shrink(),
                                          hint: const Text(
                                            'Sexo',
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          value: _selectedSex,
                                          items: state.genders
                                              .map(
                                                (g) => DropdownMenuItem<Gender>(
                                                  value: g,
                                                  child: Text(
                                                    g.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: state.genders.isEmpty
                                              ? null
                                              : (Gender? val) {
                                                  setState(() {
                                                    _selectedSex = val;
                                                    _isSexValid = true;
                                                    _bloc.add(
                                                      FetchTshirtSizesRequested(
                                                        eventId: widget.eventId,
                                                        genderId:
                                                            _selectedSex!.id,
                                                      ),
                                                    );
                                                    // reset selected category when sex changes
                                                    _selectedCategory = null;
                                                    _isCategoryValid = true;
                                                  });
                                                  // If birthdate already selected, fetch categories
                                                  if (_selectedSex != null &&
                                                      _dobController
                                                          .text
                                                          .isNotEmpty) {
                                                    setState(() {
                                                      _hasRequestedCategories =
                                                          true;
                                                      _hasShownNoCategoriesDialog =
                                                          false;
                                                    });
                                                    _bloc.add(
                                                      FetchCategoriesRequested(
                                                        eventId: widget.eventId,
                                                        genderId:
                                                            _selectedSex!.id,
                                                        birthdate:
                                                            _dobController.text,
                                                      ),
                                                    );
                                                  }
                                                },
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          dropdownColor: const Color.fromRGBO(
                                            241,
                                            136,
                                            0,
                                            0.9,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Fecha de nacimiento (date picker)
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
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          AppColors.primary,
                                                    ),
                                                  ),
                                              dialogBackgroundColor:
                                                  Colors.white,
                                            ),
                                            child:
                                                child ??
                                                const SizedBox.shrink(),
                                          );
                                        },
                                      );
                                      if (picked != null) {
                                        final newDate = picked
                                            .toIso8601String()
                                            .split('T')
                                            .first;
                                        setState(() {
                                          _dobController.text = newDate;
                                          _isDobValid = true;
                                        });
                                        // If gender already selected, fetch categories
                                        if (_selectedSex != null) {
                                          setState(() {
                                            _hasRequestedCategories = true;
                                            _hasShownNoCategoriesDialog = false;
                                          });
                                          _bloc.add(
                                            FetchCategoriesRequested(
                                              eventId: widget.eventId,
                                              genderId: _selectedSex!.id,
                                              birthdate: newDate,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Fecha de nacimiento',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isDobValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isDobValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Nombre del equipo
                                  TextField(
                                    controller: _teamController,
                                    decoration: InputDecoration(
                                      hintText: 'Nombre del equipo',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Email
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (val) {
                                      if (!_isEmailValid) {
                                        final valid = _isEmailFormatValid(
                                          val.trim(),
                                        );
                                        if (valid) {
                                          setState(() {
                                            _isEmailValid = true;
                                          });
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isEmailValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isEmailValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Teléfono
                                  TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (val) {
                                      final trimmed = val.trim();
                                      if (trimmed.length == 10 &&
                                          !_isPhoneValid) {
                                        setState(() {
                                          _isPhoneValid = true;
                                        });
                                      } else if (trimmed.length != 10 &&
                                          _isPhoneValid) {
                                        setState(() {
                                          _isPhoneValid = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Teléfono',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isPhoneValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isPhoneValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Teléfono de emergencia
                                  TextField(
                                    controller: _emergencyPhoneController,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (val) {
                                      final trimmed = val.trim();
                                      if (trimmed.length == 10 &&
                                          !_isEmergencyPhoneValid) {
                                        setState(() {
                                          _isEmergencyPhoneValid = true;
                                        });
                                      } else if (trimmed.length != 10 &&
                                          _isEmergencyPhoneValid) {
                                        setState(() {
                                          _isEmergencyPhoneValid = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Teléfono de emergencia',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isEmergencyPhoneValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isEmergencyPhoneValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Estado dropdown (loaded from bloc)
                                  const SizedBox(height: 0),
                                  BlocBuilder<
                                    RegistrationBloc,
                                    RegistrationState
                                  >(
                                    builder: (context, state) {
                                      final boxDecoration = BoxDecoration(
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          0.18,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: _isStateValid
                                            ? null
                                            : Border.all(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      );

                                      return Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: boxDecoration,
                                        child: DropdownButton<Datum>(
                                          isExpanded: true,
                                          underline: const SizedBox.shrink(),
                                          hint: const Text(
                                            'Estado',
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          value: _selectedState,
                                          items: state.states
                                              .map(
                                                (s) => DropdownMenuItem<Datum>(
                                                  value: s,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 12,
                                                        ),
                                                    child: Text(
                                                      s.name ?? '',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: state.states.isEmpty
                                              ? null
                                              : (Datum? val) {
                                                  setState(() {
                                                    _selectedState = val;
                                                    _isStateValid = true;
                                                  });
                                                },
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          dropdownColor: const Color.fromRGBO(
                                            241,
                                            136,
                                            0,
                                            0.9,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Ciudad
                                  TextField(
                                    controller: _cityController,
                                    onChanged: (val) {
                                      if (!_isCityValid &&
                                          val.trim().isNotEmpty) {
                                        setState(() {
                                          _isCityValid = true;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Ciudad',
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.18,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isCityValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: _isCityValid
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      ),
                                      hintStyle: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Categoría dropdown
                                  BlocBuilder<
                                    RegistrationBloc,
                                    RegistrationState
                                  >(
                                    builder: (context, state) {
                                      final boxDecoration = BoxDecoration(
                                        color: const Color.fromRGBO(
                                          255,
                                          255,
                                          255,
                                          0.18,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: _isCategoryValid
                                            ? null
                                            : Border.all(
                                                color: Colors.red,
                                                width: 1.6,
                                              ),
                                      );

                                      return Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: boxDecoration,
                                        child: state.isLoadingCategories
                                            ? const Center(
                                                child: SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              )
                                            : DropdownButton<String>(
                                                isExpanded: true,
                                                underline:
                                                    const SizedBox.shrink(),
                                                hint: const Text(
                                                  'Categoría',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                // build unique category items keyed by computed idStr to avoid duplicates
                                                value: () {
                                                  final Map<String, dynamic>
                                                  unique = {};
                                                  for (final c
                                                      in state.categories) {
                                                    final idStr =
                                                        (c.eventCategoryId != 0
                                                                ? c.eventCategoryId
                                                                : c.id)
                                                            .toString();
                                                    if (!unique.containsKey(
                                                      idStr,
                                                    )) {
                                                      unique[idStr] = c;
                                                    }
                                                  }
                                                  return _selectedCategory !=
                                                              null &&
                                                          unique.containsKey(
                                                            _selectedCategory,
                                                          )
                                                      ? _selectedCategory
                                                      : null;
                                                }(),
                                                items: () {
                                                  final Map<String, dynamic>
                                                  unique = {};
                                                  for (final c
                                                      in state.categories) {
                                                    final idStr =
                                                        (c.eventCategoryId != 0
                                                                ? c.eventCategoryId
                                                                : c.id)
                                                            .toString();
                                                    if (!unique.containsKey(
                                                      idStr,
                                                    )) {
                                                      unique[idStr] = c;
                                                    }
                                                  }
                                                  return unique.entries.map((
                                                    e,
                                                  ) {
                                                    final idStr = e.key;
                                                    final c = e.value;
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: idStr,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 12,
                                                            ),
                                                        child: Text(
                                                          c.displayName,
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                              ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                }(),
                                                onChanged:
                                                    state.categories.isEmpty
                                                    ? null
                                                    : (String? val) {
                                                        setState(() {
                                                          _selectedCategory =
                                                              val;
                                                          _isCategoryValid =
                                                              true;
                                                        });
                                                        debugPrint(
                                                          'RegistrationPage: category selected -> $val',
                                                        );
                                                      },
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                dropdownColor:
                                                    const Color.fromRGBO(
                                                      241,
                                                      136,
                                                      0,
                                                      0.9,
                                                    ),
                                              ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Jersey dropdown (only when allowed)
                                  if (widget.allowTshirtSize) ...[
                                    BlocBuilder<
                                      RegistrationBloc,
                                      RegistrationState
                                    >(
                                      builder: (context, state) {
                                        return Container(
                                          height: 48,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              0.18,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: _isJerseyValid
                                                ? null
                                                : Border.all(
                                                    color: Colors.red,
                                                    width: 1.6,
                                                  ),
                                          ),
                                          child: state.isLoadingTshirtSizes
                                              ? const Center(
                                                  child: SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                )
                                              : DropdownButton<String>(
                                                  isExpanded: true,
                                                  underline:
                                                      const SizedBox.shrink(),
                                                  hint: const Text(
                                                    'Jersey conmemorativo',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  value: () {
                                                    final Map<String, dynamic>
                                                    unique = {};
                                                    for (final d
                                                        in state.tshirtSizes) {
                                                      final idStr =
                                                          d.id?.toString() ??
                                                          '';
                                                      if (!unique.containsKey(
                                                        idStr,
                                                      )) {
                                                        unique[idStr] = d;
                                                      }
                                                    }
                                                    return _selectedJersey !=
                                                                null &&
                                                            unique.containsKey(
                                                              _selectedJersey,
                                                            )
                                                        ? _selectedJersey
                                                        : null;
                                                  }(),
                                                  items: () {
                                                    final Map<String, dynamic>
                                                    unique = {};
                                                    for (final d
                                                        in state.tshirtSizes) {
                                                      final idStr =
                                                          d.id?.toString() ??
                                                          '';
                                                      if (!unique.containsKey(
                                                        idStr,
                                                      )) {
                                                        unique[idStr] = d;
                                                      }
                                                    }
                                                    return unique.entries.map((
                                                      e,
                                                    ) {
                                                      final idStr = e.key;
                                                      final d = e.value;
                                                      final label =
                                                          d
                                                              .tshirtSize
                                                              ?.description ??
                                                          '';
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: idStr,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 14,
                                                                vertical: 12,
                                                              ),
                                                          child: Text(
                                                            label,
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList();
                                                  }(),
                                                  onChanged:
                                                      state.tshirtSizes.isEmpty
                                                      ? null
                                                      : (String? val) {
                                                          setState(() {
                                                            _selectedJersey =
                                                                val;
                                                            _isJerseyValid =
                                                                true;
                                                          });
                                                        },
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  dropdownColor:
                                                      const Color.fromRGBO(
                                                        241,
                                                        136,
                                                        0,
                                                        0.9,
                                                      ),
                                                ),
                                        );
                                      },
                                    ),
                                  ],

                                  const SizedBox(height: 12),

                                  // Checkbox de confirmación
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isConfirmed = !_isConfirmed;
                                          });
                                        },
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: _isConfirmed
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    255,
                                                    255,
                                                    255,
                                                    0.18,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: _isConfirmed
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: AppColors.primary,
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Confirmo que la información que proporcioné es correcta',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  // Realizar pago button
                                  ElevatedButton(
                                    onPressed: _isConfirmed && !_isSubmitting
                                        ? () async {
                                            final name = _nameController.text
                                                .trim();
                                            final surname = _surnameController
                                                .text
                                                .trim();
                                            final dob = _dobController.text
                                                .trim();
                                            final phone = _phoneController.text
                                                .trim();
                                            final emergency =
                                                _emergencyPhoneController.text
                                                    .trim();
                                            final city = _cityController.text
                                                .trim();
                                            final email = _emailController.text
                                                .trim();

                                            final nameValid = name.isNotEmpty;
                                            final surnameValid =
                                                surname.isNotEmpty;
                                            final dobValid = dob.isNotEmpty;
                                            final phoneValid =
                                                phone.length == 10;
                                            final emergencyValid =
                                                emergency.length == 10;
                                            final cityValid = city.isNotEmpty;
                                            final emailValid =
                                                _isEmailFormatValid(email);

                                            // Dropdown validations
                                            final sexValid =
                                                _selectedSex != null;
                                            final stateValid =
                                                _selectedState != null;
                                            final categoryValid =
                                                _selectedCategory != null;
                                            final jerseyValid =
                                                widget.allowTshirtSize
                                                ? _selectedJersey != null
                                                : true;

                                            setState(() {
                                              _isNameValid = nameValid;
                                              _isSurnameValid = surnameValid;
                                              _isDobValid = dobValid;
                                              _isPhoneValid = phoneValid;
                                              _isEmergencyPhoneValid =
                                                  emergencyValid;
                                              _isCityValid = cityValid;
                                              _isEmailValid = emailValid;
                                              // dropdown validity
                                              _isSexValid = sexValid;
                                              _isStateValid = stateValid;
                                              _isCategoryValid = categoryValid;
                                              _isJerseyValid = jerseyValid;
                                            });
                                            if (!nameValid ||
                                                !surnameValid ||
                                                !dobValid ||
                                                !phoneValid ||
                                                !emergencyValid ||
                                                !cityValid ||
                                                !emailValid ||
                                                !sexValid ||
                                                !stateValid ||
                                                !categoryValid ||
                                                !jerseyValid) {
                                              return;
                                            }

                                            // All validations passed — submit to API
                                            setState(() {
                                              _isSubmitting = true;
                                            });
                                            try {
                                              final api = ApiService();
                                              final int categoryId =
                                                  int.tryParse(
                                                    _selectedCategory ?? '',
                                                  ) ??
                                                  0;
                                              final int? tshirtId =
                                                  int.tryParse(
                                                    _selectedJersey ?? '',
                                                  );
                                              final resp = await api
                                                  .submitRaceRegistration(
                                                    runnerId: _selectedRunnerId,
                                                    firstName: name,
                                                    lastName: surname,
                                                    birthdate: dob,
                                                    genderId: _selectedSex!.id,
                                                    teamName: _teamController
                                                        .text
                                                        .trim(),
                                                    eventCategoryId: categoryId,
                                                    eventTshirtSizeId: tshirtId,
                                                    email: email,
                                                    phone: phone,
                                                    stateId:
                                                        _selectedState!.id!,
                                                    city: city,
                                                    emergencyPhone: emergency,
                                                  );
                                              setState(() {
                                                _raceRegistrationResponse =
                                                    resp;
                                              });
                                              try {
                                                Navigator.of(context).pushNamed(
                                                  Routers
                                                      .informationConfirmation,
                                                  arguments: resp,
                                                );
                                              } catch (_) {}
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Error al enviar: $e',
                                                  ),
                                                ),
                                              );
                                            } finally {
                                              setState(() {
                                                _isSubmitting = false;
                                              });
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primary,
                                      disabledBackgroundColor:
                                          const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.5,
                                          ),
                                      disabledForegroundColor:
                                          const Color.fromRGBO(
                                            241,
                                            136,
                                            0,
                                            0.5,
                                          ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                        color: _isConfirmed
                                            ? AppColors.primary
                                            : const Color.fromRGBO(
                                                241,
                                                136,
                                                0,
                                                0.5,
                                              ),
                                        width: 1.5,
                                      ),
                                      elevation: _isConfirmed ? 4 : 0,
                                      shadowColor: const Color.fromRGBO(
                                        241,
                                        136,
                                        0,
                                        0.2,
                                      ),
                                    ),
                                    child: Text(
                                      'Continuar',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(241, 136, 0, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Image.asset(
                          'assets/imgs/logo.png',
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
