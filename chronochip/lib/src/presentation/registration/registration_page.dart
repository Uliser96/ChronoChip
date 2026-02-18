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
  String? _selectedRunner;
  Gender? _selectedSex;
  late RegistrationBloc _bloc;
  Datum? _selectedState;
  String? _selectedCategory;
  String? _selectedJersey;
  bool _isConfirmed = false;
  bool _hasShownNoCategoriesDialog = false;
  bool _hasRequestedCategories = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      'RegistrationPage opened: allowTshirtSize=${widget.allowTshirtSize}, eventId=${widget.eventId}',
    );
    _bloc = RegistrationBloc();
    _bloc.add(const FetchGendersRequested());
    _bloc.add(const FetchStatesRequested());
    if (widget.allowTshirtSize) {
      _bloc.add(FetchTshirtSizesRequested(eventId: widget.eventId));
    }
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _teamController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _bloc.close();
    _nameController.dispose();
    _surnameController.dispose();
    _teamController.dispose();
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
                                  Text(
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
                                  const SizedBox(height: 16),

                                  // Corredores dropdown
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
                                        'corredores',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      value: _selectedRunner,
                                      items: const [],
                                      onChanged: null,
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

                                  // Nombre
                                  TextField(
                                    controller: _nameController,
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

                                  // Apellidos
                                  TextField(
                                    controller: _surnameController,
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

                                  // Teléfono
                                  TextField(
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

                                  // Teléfono de emergencia
                                  TextField(
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
                                                value: _selectedCategory,
                                                items: state.categories
                                                    .map(
                                                      (
                                                        c,
                                                      ) => DropdownMenuItem<String>(
                                                        value: c.eventCategoryId
                                                            .toString(),
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
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged:
                                                    state.categories.isEmpty
                                                    ? null
                                                    : (String? val) {
                                                        setState(() {
                                                          _selectedCategory =
                                                              val;
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
                                                  value: _selectedJersey,
                                                  items: state.tshirtSizes.map((
                                                    d,
                                                  ) {
                                                    final idStr =
                                                        d.tshirtSize?.id
                                                            ?.toString() ??
                                                        '';
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
                                                  }).toList(),
                                                  onChanged:
                                                      state.tshirtSizes.isEmpty
                                                      ? null
                                                      : (String? val) {
                                                          setState(() {
                                                            _selectedJersey =
                                                                val;
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
                                    onPressed: _isConfirmed ? () {} : null,
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
