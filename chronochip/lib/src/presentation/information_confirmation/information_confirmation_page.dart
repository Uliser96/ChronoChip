import 'package:flutter/material.dart';
import 'package:chronochip/src/core/models/race_registration_response/race_registration_response.dart';

class InformationConfirmationPage extends StatelessWidget {
  final RaceRegistrationResponse? raceRegistration;

  const InformationConfirmationPage({Key? key, this.raceRegistration})
    : super(key: key);

  static const routeName = '/informationConfirmation';

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFf6921e);

    Widget buildLine(String label, String value, {bool isTotal = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.black87 : Colors.grey[800],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Confirma la información de tu registro',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // Campos del modelo (si están disponibles)
                                buildLine(
                                  'Nombres:',
                                  raceRegistration
                                          ?.data
                                          ?.runnerData
                                          ?.firstName ??
                                      '-',
                                ),
                                buildLine(
                                  'Apellidos:',
                                  raceRegistration
                                          ?.data
                                          ?.runnerData
                                          ?.lastName ??
                                      '-',
                                ),
                                buildLine(
                                  'Fecha de nacimiento:',
                                  raceRegistration
                                          ?.data
                                          ?.runnerData
                                          ?.birthdate ??
                                      '-',
                                ),
                                buildLine(
                                  'Email:',
                                  raceRegistration?.data?.runnerData?.email ??
                                      '-',
                                ),
                                buildLine(
                                  'Teléfono:',
                                  raceRegistration?.data?.runnerData?.phone ??
                                      '-',
                                ),
                                buildLine(
                                  'Estado:',
                                  raceRegistration
                                          ?.data
                                          ?.runnerData
                                          ?.state
                                          ?.name ??
                                      '-',
                                ),
                                buildLine(
                                  'Evento:',
                                  raceRegistration
                                          ?.data
                                          ?.eventCategory
                                          ?.displayName ??
                                      raceRegistration
                                          ?.data
                                          ?.eventCategory
                                          ?.categoryName ??
                                      '-',
                                ),
                                const Divider(),
                                Text(
                                  "INFORMACION DE PAGO",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                buildLine(
                                  'Registro:',
                                  raceRegistration?.data?.registrationCost ??
                                      '-',
                                ),
                                buildLine(
                                  'Comisión:',
                                  raceRegistration
                                          ?.data
                                          ?.onlinePaymentCommission ??
                                      '-',
                                ),
                                buildLine(
                                  'Total:',
                                  raceRegistration?.data?.totalAmount ?? '-',
                                  isTotal: true,
                                ),
                                const SizedBox(height: 20),
                                // Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    label: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      child: Text('Proceder al pago'),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: orange,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
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
          ),
        ],
      ),
    );
  }
}
