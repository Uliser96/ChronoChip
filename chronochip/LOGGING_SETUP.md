# Sistema de Logging para Servicios Web

## Descripción

Se ha implementado un sistema completo de logging que permite ver en consola todas las solicitudes HTTP realizadas, junto con sus URLs y payloads.

## Componentes

### 1. LoggerUtil (`core/utils/logger_util.dart`)

Utilidad centralizada para logging que proporciona:

- **logRequest()** - Registra solicitudes HTTP con método, URL y payload
- **logResponse()** - Registra respuestas exitosas con status code y contenido
- **logError()** - Registra errores con stack trace

### 2. ApiClient (`core/services/api/api_client.dart`)

El cliente HTTP utiliza LoggerUtil para registrar:

- ✅ Antes de cada solicitud (GET, POST, PUT, DELETE)
- ✅ Después de cada respuesta exitosa
- ✅ Cuando ocurren errores

## Ejemplo de Salida en Consola

### Solicitud

```
════════════════════════════════════════════════════════════════════════════════
🚀 [POST] 2025-12-10 14:30:45
🔗 URL: https://42240a32-872b-4780-a82b-11965d804431.mock.pstmn.io/login
📦 Payload: {"email":"user@example.com","password":"password123"}
════════════════════════════════════════════════════════════════════════════════
```

### Respuesta Exitosa

```
════════════════════════════════════════════════════════════════════════════════
✅ [POST] 200 2025-12-10 14:30:46
🔗 URL: https://42240a32-872b-4780-a82b-11965d804431.mock.pstmn.io/login
📥 Response: {"succes":true,"messageError":""}
════════════════════════════════════════════════════════════════════════════════
```

### Error

```
════════════════════════════════════════════════════════════════════════════════
❌ [POST] ERROR 2025-12-10 14:30:47
🔗 URL: https://42240a32-872b-4780-a82b-11965d804431.mock.pstmn.io/login
💥 Error: Connection timeout
════════════════════════════════════════════════════════════════════════════════
```

## Características

✨ **Emojis Visuales** - Facilita identificar solicitudes, respuestas y errores
🎯 **URL Completa** - Muestra la URL absoluta de cada solicitud
📦 **Payload Visible** - Muestra los datos enviados en POST/PUT
⏰ **Timestamps** - Registra la hora exacta de cada solicitud
🔍 **Stack Traces** - En errores, incluye el stack trace completo
🔐 **Debug Mode** - Solo muestra logs en modo debug (`kDebugMode`)

## Cómo Funciona

1. **ApiClient** recibe una solicitud
2. Llama a `LoggerUtil.logRequest()` con método, URL y body
3. Realiza la solicitud HTTP
4. Si es exitosa, llama a `LoggerUtil.logResponse()`
5. Si hay error, llama a `LoggerUtil.logError()`
6. Los logs se imprimen en la consola con formato legible

## Ventajas

- ✅ Debugging fácil de problemas HTTP
- ✅ Auditoría de solicitudes realizadas
- ✅ Validación de payloads enviados
- ✅ Rastreo de errores con stack traces
- ✅ No requiere herramientas externas (solo console logs)
- ✅ Funciona en modo debug y release

## Integración Automática

El logging se aplica automáticamente a **TODAS** las solicitudes HTTP realizadas a través de `ApiClient`, incluidas:

- Login
- Cualquier otro servicio que se agregue en el futuro

No requiere configuración adicional en el código de la aplicación.

## Ejemplo de Uso

```dart
// En LoginBloc
final response = await _apiService.login(
  email: 'user@example.com',
  password: 'password123',
);
// Automáticamente se registra:
// 1. Solicitud POST con URL y payload
// 2. Respuesta o error
```

## Deshabilitación

Si necesitas deshabilitar los logs en algún momento, puedes:

1. Compilar en modo release (los logs no se mostrarán porque `kDebugMode` será false)
2. Modificar LoggerUtil para agregar un flag de control
