import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/event_category.dart';
import 'package:chronochip/src/core/models/tshirt_size.dart';
import 'race_registration_bloc.dart';
import 'race_registration_event.dart';
import 'race_registration_state.dart';
import 'package:chronochip/src/core/routers/routers.dart';

class RaceRegistrationPage extends StatefulWidget {
  final int eventId;
  const RaceRegistrationPage({super.key, required this.eventId});

  @override
  State<RaceRegistrationPage> createState() => _RaceRegistrationPageState();
}

class _RaceRegistrationPageState extends State<RaceRegistrationPage> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _teamController;
  late TextEditingController _dobController;
  Gender? _selectedSex;
  int? _selectedRunnerId;
  String? _selectedCategory;
  String? _selectedJersey;
  final List<String> _categoryOptions = [];
  final List<String> _jerseyOptions = [];
  RaceRegistrationBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RaceRegistrationBloc(eventId: widget.eventId);
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _teamController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _bloc?.close();
    _nameController.dispose();
    _surnameController.dispose();
    _teamController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc!,
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
                          child: BlocListener<RaceRegistrationBloc, RaceRegistrationState>(
                            listener: (context, state) {
                              if (state.isSuccess) {
                                Navigator.pushNamed(context, Routers.payment);
                              } else if (state.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.error!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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

                                    // Corredores dropdown (cargado desde API)
                                    BlocBuilder<
                                      RaceRegistrationBloc,
                                      RaceRegistrationState
                                    >(
                                      builder: (context, state) {
                                        final boxDecoration = BoxDecoration(
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.18,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        );

                                        if (state.runners.isEmpty) {
                                          return Container(
                                            height: 48,
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: boxDecoration,
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              underline:
                                                  const SizedBox.shrink(),
                                              value: _selectedRunnerId ?? -1,
                                              items: [
                                                DropdownMenuItem<int>(
                                                  value: -1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 12,
                                                        ),
                                                    child: Text(
                                                      'Sin datos de corredores',
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              onChanged: null,
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
                                        }

                                        return Container(
                                          height: 48,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: boxDecoration,
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            underline: const SizedBox.shrink(),
                                            hint: const Text(
                                              'corredores',
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            value: _selectedRunnerId,
                                            items: state.runners.map((r) {
                                              return DropdownMenuItem<int>(
                                                value: r.id,
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
                                              );
                                            }).toList(),
                                            onChanged: (int? val) {
                                              if (val == null) return;
                                              final selected = state.runners
                                                  .firstWhere(
                                                    (r) => r.id == val,
                                                  );
                                              setState(() {
                                                _selectedRunnerId = val;
                                                _nameController.text =
                                                    selected.firstName;
                                                _surnameController.text =
                                                    selected.lastName;
                                                _dobController.text =
                                                    selected.birthdate;
                                                // reset selected category when runner changes
                                                _selectedCategory = null;
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

                                    TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Nombre',
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                      RaceRegistrationBloc,
                                      RaceRegistrationState
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
                                            items: state.genders.map((g) {
                                              return DropdownMenuItem<Gender>(
                                                value: g,
                                                child: Text(
                                                  g.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: state.genders.isEmpty
                                                ? null
                                                : (Gender? val) {
                                                    setState(() {
                                                      _selectedSex = val;
                                                      // reset selected category whenever sex changes
                                                      _selectedCategory = null;
                                                    });

                                                    // If DOB already selected, fetch categories
                                                    if (val != null &&
                                                        _dobController
                                                            .text
                                                            .isNotEmpty) {
                                                      _bloc?.add(
                                                        FetchCategories(
                                                          genderId: val.id,
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
                                            final colorScheme = theme
                                                .colorScheme
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
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                AppColors
                                                                    .primary,
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
                                            // reset selected category whenever DOB changes
                                            _selectedCategory = null;
                                          });

                                          // If sex already selected, fetch categories
                                          if (_selectedSex != null) {
                                            _bloc?.add(
                                              FetchCategories(
                                                genderId: _selectedSex!.id,
                                                birthdate: _dobController.text,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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

                                    // Categoría dropdown (populated from API)
                                    BlocBuilder<
                                      RaceRegistrationBloc,
                                      RaceRegistrationState
                                    >(
                                      builder: (context, state) {
                                        final boxDecoration = BoxDecoration(
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.18,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        );

                                        final items = state.categories
                                            .map(
                                              (c) => DropdownMenuItem<String>(
                                                value: c.displayName,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 12,
                                                      ),
                                                  child: Text(
                                                    c.displayName,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList();

                                        // Ensure the currently selected category maps to exactly one item
                                        final selectedCount =
                                            _selectedCategory == null
                                            ? 0
                                            : items
                                                  .where(
                                                    (it) =>
                                                        it.value ==
                                                        _selectedCategory,
                                                  )
                                                  .length;
                                        final dropdownValue = selectedCount == 1
                                            ? _selectedCategory
                                            : null;

                                        return Container(
                                          height: 48,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: boxDecoration,
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            underline: const SizedBox.shrink(),
                                            hint: const Text(
                                              'Categoría',
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            value: dropdownValue,
                                            items: items,
                                            onChanged: items.isEmpty
                                                ? null
                                                : (val) {
                                                    setState(() {
                                                      _selectedCategory = val;
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

                                    // Jersey dropdown
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
                                      child:
                                          BlocBuilder<
                                            RaceRegistrationBloc,
                                            RaceRegistrationState
                                          >(
                                            builder: (context, state) {
                                              final sizes = state.tshirtSizes;
                                              return DropdownButton<String>(
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
                                                items: sizes.map((t) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: t.description,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 12,
                                                          ),
                                                      child: Text(
                                                        t.description,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: sizes.isEmpty
                                                    ? null
                                                    : (val) {
                                                        setState(() {
                                                          _selectedJersey = val;
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
                                              );
                                            },
                                          ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Checkbox replacing "Confirmar" button
                                    BlocBuilder<
                                      RaceRegistrationBloc,
                                      RaceRegistrationState
                                    >(
                                      builder: (context, state) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // dispatch validation + toggle to bloc
                                                context
                                                    .read<
                                                      RaceRegistrationBloc
                                                    >()
                                                    .add(
                                                      ValidateAndToggleConfirm(
                                                        desiredConfirmed:
                                                            !state.isConfirmed,
                                                        runnerId:
                                                            _selectedRunnerId,
                                                        name: _nameController
                                                            .text,
                                                        surname:
                                                            _surnameController
                                                                .text,
                                                        genderId:
                                                            _selectedSex?.id,
                                                        birthdate:
                                                            _dobController.text,
                                                        team:
                                                            _teamController
                                                                .text
                                                                .isEmpty
                                                            ? null
                                                            : _teamController
                                                                  .text,
                                                        category:
                                                            _selectedCategory,
                                                        jersey: _selectedJersey,
                                                      ),
                                                    );
                                              },
                                              child: Container(
                                                width: 22,
                                                height: 22,
                                                decoration: BoxDecoration(
                                                  color: state.isConfirmed
                                                      ? Colors.white
                                                      : const Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          0.18,
                                                        ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: state.isConfirmed
                                                    ? const Icon(
                                                        Icons.check,
                                                        size: 16,
                                                        color:
                                                            AppColors.primary,
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
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 18),

                                    // Realizar pago button
                                    BlocBuilder<
                                      RaceRegistrationBloc,
                                      RaceRegistrationState
                                    >(
                                      builder: (context, state) {
                                        final isEnabled =
                                            state.isConfirmed &&
                                            !state.isSubmitting;
                                        return ElevatedButton(
                                          onPressed: isEnabled
                                              ? () {
                                                  // prepare payload values
                                                  final runnerId =
                                                      _selectedRunnerId ?? 0;
                                                  final firstName =
                                                      _nameController.text;
                                                  final lastName =
                                                      _surnameController.text;
                                                  final birthdate =
                                                      _dobController.text;
                                                  final genderId =
                                                      _selectedSex!.id;
                                                  final teamName =
                                                      _teamController.text;

                                                  // resolve selected category id
                                                  final selectedCategoryId = state
                                                      .categories
                                                      .firstWhere(
                                                        (c) =>
                                                            c.displayName ==
                                                            _selectedCategory,
                                                        orElse: () =>
                                                            state
                                                                .categories
                                                                .isNotEmpty
                                                            ? state
                                                                  .categories
                                                                  .first
                                                            : EventCategory(
                                                                id: 0,
                                                                eventCategoryId:
                                                                    0,
                                                                categoryName:
                                                                    '',
                                                                divisionName:
                                                                    '',
                                                                displayName: '',
                                                                distanceKm: 0,
                                                                minAge: 0,
                                                                maxAge: 0,
                                                                genderId: 0,
                                                              ),
                                                      )
                                                      .eventCategoryId;

                                                  // resolve tshirt size id
                                                  final tshirtSizeId = state
                                                      .tshirtSizes
                                                      .firstWhere(
                                                        (t) =>
                                                            t.description ==
                                                            _selectedJersey,
                                                        orElse: () =>
                                                            TShirtSize(
                                                              id: 0,
                                                              sizeEs: '',
                                                              sizeEn: '',
                                                              description: '',
                                                            ),
                                                      )
                                                      .id;

                                                  context
                                                      .read<
                                                        RaceRegistrationBloc
                                                      >()
                                                      .add(
                                                        SubmitRegistrationPressed(
                                                          runnerId: runnerId,
                                                          firstName: firstName,
                                                          lastName: lastName,
                                                          birthdate: birthdate,
                                                          genderId: genderId,
                                                          teamName: teamName,
                                                          eventCategoryId:
                                                              selectedCategoryId,
                                                          tshirtSize:
                                                              tshirtSizeId,
                                                        ),
                                                      );
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            side: BorderSide(
                                              color: isEnabled
                                                  ? AppColors.primary
                                                  : const Color.fromRGBO(
                                                      241,
                                                      136,
                                                      0,
                                                      0.5,
                                                    ),
                                              width: 1.5,
                                            ),
                                            elevation: isEnabled ? 4 : 0,
                                            shadowColor: const Color.fromRGBO(
                                              241,
                                              136,
                                              0,
                                              0.2,
                                            ),
                                          ),
                                          child: state.isSubmitting
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(AppColors.primary),
                                                  ),
                                                )
                                              : Text(
                                                  'Realizar pago',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primary,
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
