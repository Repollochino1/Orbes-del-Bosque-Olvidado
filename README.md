# 🌲 Orbes del Bosque Olvidado

![Engine](https://img.shields.io/badge/Engine-Godot_4.3-blue?logo=godotengine)
![Language](https://img.shields.io/badge/Language-GDScript-green)
![Style](https://img.shields.io/badge/Art_Style-2D_Analog_Horror_Pixel_Art-purple)
![License](https://img.shields.io/badge/License-Academic_/_MIT-orange)

**Orbes del Bosque Olvidado** es un prototipo interactivo de survival horror en 2D desarrollado como proyecto académico en la **Universidad Tecnológica de Panamá (UTP)**. El juego combina una estética de horror analógico en pixel art de baja resolución con mecánicas de exploración, iluminación dinámica y persecución por inteligencia artificial.

---

## 📋 Descripción del Proyecto

El jugador se adentra en un bosque oscuro rodeado de una densa niebla y debe explorar un laberinto en busca de **4 orbes místico-energéticos**. A medida que los recolecta, la atmósfera se vuelve hostil: la iluminación disminuye y despierta una entidad destructiva que lo perseguirá de manera implacable.

---

## 🎮 Mecánicas y Sistemas Principales

*   **Iluminación Dinámica (Analog Horror):** Implementación de iluminación en tiempo real con nodos `PointLight2D` y procesamiento de sombras activas (`Shadows Enabled`) atadas a la visión del jugador.
*   **Inteligencia Artificial (FSM):** Entidad enemiga heredada de `CharacterBody2D` gestionada mediante una **Máquina de Estados Finitos (FSM)** simplificada (Patrullaje y Persecución direct-vector).
*   **Eventos Dinámicos en Escena:** El controlador global (`main.gd`) monitorea la recolección de los orbes. Al alcanzar la meta (4/4):
    1. Instancia dinámicamente al enemigo en un punto remoto.
    2. Altera la modulación ambiental (`CanvasModulate`) para oscurecer la escena.
    3. Activa la matriz de colisión del portal de salida.
*   **Interfaz Desacoplada (HUD):** UI renderizada sobre `CanvasLayer` independiente de la `Camera2D`. Actualización optimizada basada en reactividad mediante señales (`signals`).

---

## 🛠️ Tecnologías Utilizadas

*   **Motor de Videojuegos:** [Godot Engine 4.3](https://godotengine.org/)
*   **Lenguaje de Programación:** GDScript
*   **Control de Versiones:** Git & GitHub
*   **Gestión del Proyecto:** GitHub Projects (Metodología Ágil / Tablero Kanban)

---

## 🌿 Estrategia de Ramificación y Flujo de Trabajo (Git & GitHub)

El desarrollo del proyecto se organizó mediante **GitHub Projects** utilizando una estructura Kanban de 4 columnas:
`To Do` ➔ `In Progress` ➔ `Testing/Review` ➔ `Done`

Para el desarrollo en equipo se empleó una estrategia de **Feature Branching**:
*   Cada funcionalidad (IA, HUD, Iluminación, Colisiones) se trabajó en su propia rama independiente.
*   La integración a la rama principal se realizó exclusivamente mediante **Pull Requests (PR)** previa validación y resolución manual de conflictos de fusión (*merge conflicts*) en escenas (`.tscn`) y scripts (`.gd`).

---

## 📂 Estructura de Carpetas del Proyecto

```text
Orbes-del-Bosque-Olvidado/
├── assets/
│   ├── audio/          # Efectos de sonido (WAV/OGG) y música ambiental
│   ├── sprites/        # Hojas de sprites 2D (Player, Enemigo, TileSets 16x16)
│   └── ui/             # Texturas para la interfaz y fuentes
├── scenes/
│   ├── characters/     # Escenas del Jugador y la Entidad Enemiga
│   ├── levels/         # TileMaps, laberinto y configuración de iluminación
│   ├── objects/        # Orbes recolectables y Portal
│   └── ui/             # Menú Principal, HUD, Screamer/Game Over, Victoria
├── scripts/
│   ├── characters/     # Scripts GDScript de movimiento e IA
│   ├── global/         # Game Manager y Singletons
│   └── ui/             # Controladores del HUD y señales
├── project.godot       # Configuración global de Godot Engine 4.3
└── README.md
