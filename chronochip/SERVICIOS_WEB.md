# Estructura de Servicios Web y Bloc

Este documento describe la estructura implementada para realizar peticiones a servicios web usando Bloc para gestión de estado.

## Estructura de Directorios

```
lib/src/
├── core/
│   ├── services/
│   │   ├── api/
│   │   │   ├── api_client.dart       # Cliente HTTP base
│   │   │   └── api_service.dart      # Servicios específicos (login, etc)
│   │   └── services.dart             # Índice de exportaciones
│   ├── models/
│   │   ├── login_response.dart       # Modelos de respuesta
│   │   └── models.dart               # Índice de exportaciones
│   └── routers/
│       └── routers.dart              # Router con Bloc providers
└── presentation/
    └── login/
        ├── bloc/
        │   ├── login_bloc.dart       # Lógica Bloc
        │   ├── login_event.dart      # Eventos
        │   └── login_state.dart      # Estados
        └── login_page.dart           # UI con Bloc integrado
```

## Componentes Principales

### 1. ApiClient (`core/services/api/api_client.dart`)
- Cliente HTTP base con métodos para GET, POST, PUT, DELETE
- Manejo de respuestas HTTP
- URL base configurada

### 2. ApiService (`core/services/api/api_service.dart`)
- Servicios específicos de la aplicación
- Método `login()` que utiliza ApiClient

### 3. Modelos (`core/models/`)
- `LoginResponse`: Modelo de respuesta del servidor
- Usa `json_annotation` para serialización

### 4. LoginBloc
- **Events**: `LoginSubmitted`, `LoginReset`
- **States**: `LoginInitial`, `LoginLoading`, `LoginSuccess`, `LoginFailure`
- Maneja la lógica de autenticación

### 5. LoginPage
- Integrada con Bloc
- Campos de email y contraseña funcionales
- Muestra loading durante la solicitud
- Maneja errores y éxito

## Flujo de Datos

1. Usuario ingresa email y contraseña en `LoginPage`
2. Al presionar el botón, se dispara evento `LoginSubmitted`
3. `LoginBloc` recibe el evento y emite `LoginLoading`
4. `LoginBloc` llama a `ApiService.login()`
5. `ApiService` realiza solicitud POST a `/login`
6. Si es exitoso, emite `LoginSuccess` (navega al home)
7. Si falla, emite `LoginFailure` (muestra error)

## Configuración

### URL Base
```dart
static const String baseUrl =
    'https://42240a32-872b-4780-a82b-11965d804431.mock.pstmn.io/';
```

### Dependencias Agregadas
- `http: ^1.1.0` - Cliente HTTP
- `flutter_bloc: ^8.1.5` - Bloc para Flutter
- `bloc: ^8.1.4` - Bloc puro
- `json_annotation: ^4.8.1` - Anotaciones JSON
- `build_runner: ^2.4.12` - Generador de código
- `json_serializable: ^6.8.0` - Generador JSON

## Próximos Pasos

Para generar los archivos de serialización JSON, ejecuta:

```bash
flutter pub run build_runner build
```

O para modo watch:

```bash
flutter pub run build_runner watch
```

Esto generará `login_response.g.dart` con los métodos `fromJson` y `toJson`.

## Cómo Agregar Nuevos Servicios

1. Crea un modelo en `core/models/`
2. Agrega un método en `core/services/api/api_service.dart`
3. Crea eventos y estados en una carpeta `bloc/`
4. Crea el Bloc correspondiente
5. Integra en la UI con `BlocProvider` y `BlocBuilder`/`BlocListener`

## Notas Importantes

- Los Blocs se instancian en el router con `BlocProvider`
- Los cambios de estado se manejan con `BlocListener` y `BlocBuilder`
- Los errores de API se capturan y se emiten en el estado `LoginFailure`
- El archivo `login_response.g.dart` se genera automáticamente
