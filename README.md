# GuitarUex

GuitarUex es una aplicación SwiftUI para iOS diseñada para entusiastas de la guitarra. Permite a los usuarios gestionar su colección de guitarras, aprender sobre guitarristas y bandas famosas, y acceder a un afinador de guitarra incorporado. La aplicación también incluye una función de chat para que los usuarios se conecten y discutan su pasión por la música.

## Características

*   **Colección de Guitarras:** Mantén un registro detallado de tus guitarras, incluyendo fabricante, modelo e imágenes.
*   **Explora Artistas:** Descubre información sobre guitarristas famosos y sus bandas.
*   **Afinador de Guitarra:** Una utilidad para ayudarte a afinar tu guitarra con precisión.
*   **Autenticación de Usuarios:** Inicio de sesión seguro y gestión de usuarios.
*   **Chat:** Un chat dentro de la aplicación para conectar con otros usuarios.

## Estructura del Proyecto

El proyecto está organizado en los siguientes directorios principales:

-   `GuitarUex/`: Contiene el código fuente principal de la aplicación.
    -   `Model/`: Modelos de datos para las entidades principales (Guitarra, Guitarrista, Banda, etc.).
    -   `ModelLogic/`: Lógica de negocio y view models.
    -   `Views/`: Vistas de SwiftUI para la interfaz de usuario.
    -   `Interactor/`: Maneja la persistencia de datos.
    -   `KeyChain/`: Gestiona la autenticación de usuarios y el acceso al llavero (Keychain).
    -   `Resources/`: Contiene recursos estáticos como datos JSON.

## Tecnologías Utilizadas

*   **SwiftUI:** La interfaz de usuario está construida con el moderno framework declarativo de Apple.
*   **Swift:** La aplicación está escrita completamente en Swift.
*   **Xcode:** El proyecto se gestiona y compila con Xcode.

## Cómo Compilar

1.  Clona el repositorio.
2.  Abre `GuitarUex.xcodeproj` en Xcode.
3.  Selecciona un simulador o un dispositivo iOS conectado.
4.  Haz clic en el botón "Run" para compilar y lanzar la aplicación.