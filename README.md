# Blogit 🚀

Bienvenido a **Blogit**, un nuevo proyecto desarrollado con Flutter que te permite crear y gestionar blogs de manera sencilla y eficiente. **¡Atención!** Esta aplicación todavía está en desarrollo. 🛠️

## Descripción del Proyecto 📖

Blogit es una aplicación móvil diseñada para bloggers y escritores que desean tener una plataforma fácil de usar para publicar y compartir sus ideas. Con una interfaz intuitiva y herramientas poderosas, Blogit te ayuda a concentrarte en lo que realmente importa: ¡escribir! ✍️

## Características Principales 🌟

- **Editor de Texto Avanzado**: Escribe y edita tus entradas con un editor de texto enriquecido. 📝
- **Gestión de Contenidos**: Organiza tus publicaciones con categorías y etiquetas. 📂
- **Interfaz Amigable**: Navegación sencilla y diseño atractivo. 🎨
- **Compatibilidad Multiplataforma**: Disponible para Android e iOS. 📱

## Instalación 🛠️

Sigue estos pasos para configurar el proyecto en tu máquina local:

1. Clona el repositorio:
   ```bash
   git clone https://github.com/ainlautaro7/blogit.git
   ```
2. Navega al directorio del proyecto:
   ```bash
   cd blogit
   ```
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## API de Node.js 🌐

La API de Blogit está desarrollada en Node.js utilizando Express y MySQL. Proporciona varios endpoints para gestionar artículos y usuarios. Aquí tienes un resumen de los principales endpoints:

### Endpoints de Artículos

- **POST /articles**: Crea un nuevo artículo.
- **GET /articles**: Obtiene todos los artículos.
- **GET /articles/:id**: Obtiene un artículo específico por su ID.
- **PUT /articles/:id**: Actualiza un artículo existente.
- **DELETE /articles/:id**: Elimina un artículo por su ID.
- **GET /articles/user/:userId**: Obtiene todos los artículos de un usuario específico.

### Endpoints de Usuarios

- **POST /users/register**: Registra un nuevo usuario.
- **POST /users/login**: Inicia sesión un usuario.
- **POST /users/update**: Actualiza el perfil de un usuario.

### Configuración de la Base de Datos

La API utiliza MySQL para almacenar datos. Asegúrate de configurar las variables de entorno en un archivo `.env` con los siguientes valores:

```
DB_HOST=tu_host
DB_USER=tu_usuario
DB_PASSWORD=tu_contraseña
DB_NAME=tu_base_de_datos
```

## Recursos Adicionales 📚

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Guía de Estilo de Dart](https://dart.dev/guides/language/effective-dart/style)

## Licencia 📄

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

---

¡Gracias por visitar Blogit! Esperamos que disfrutes usando nuestra aplicación tanto como nosotros disfrutamos desarrollándola. 🎉