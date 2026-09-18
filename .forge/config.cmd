# GRIDLOOCK Visual Engine — v0 (Rescate de Ideas)

Documento de rescate del 2026-09-17. Captura las ideas clave de la
conversacion con Gemini sobre visuales para sets de musica electronica
y el problema de la memoria humana al disenar sistemas complejos.

---

## 1. PROBLEMA ORIGINAL

- Sets de 36 tracks ≈ 36 cortometrajes.
- Visuales de VJ tradicionales no representan lo que la musica expresa.
- Hacer un video unico por track con IA es inviable (costo, consistencia).
- Marca: GRIDLOOCK.
- Objetivo: una imagen o miniatura que represente cada estado emocional
  del set, NO cada track individual.

### Ejes emocionales del set

- PASADO:
  - ancla_nostalgia: objeto especifico que ya no esta
  - ancla_melancolia: bruma, caminar sin rumbo
- PRESENTE:
  - eje_nostalgia: el eco que aun flota pero no duele
  - eje_melancolia: memoria colectiva procesandose en el beat
  - eje_neutral: presencia pura, aqui y ahora sin carga
- FUTURO:
  - proyeccion_tunel: euforia, velocidad frontal, liberacion

---

## 2. SISTEMA DE FACTORES VISUALES

### Factores iniciales

| # | Factor | Opciones / Variables |
|---|--------|----------------------|
| 1 | Universalidad del Entorno | No-lugares (distritos financieros, tuneles, concreto, cristal) vs. entornos locales (Lima, bodegas, mototaxis) |
| 2 | Fase Temporal | Sunrise, Sun, Sunset, Sundown, Night |
| 3 | Perspectiva Psicologica | Seguimiento posterior / avatar, CCTV, silueta extrema, perfil introspectivo |
| 4 | Direccion de Movimiento | Viaje (avanzando) vs. estatico (perfil/lateral) |
| 5 | Lenguaje Corporal / Pose | Pose House, cruce de pies, brazos en suspension, caminata ritmica |
| 6 | Dinamicas Humanas | Aislamiento absoluto, pareja, amigos, grupos dispersos, solo en multitud, osmosis social |
| 7 | Vestimenta | Neutra/global (hoodie, beanie, jeans, mochila) vs. ajustes por subgenero |
| 8 | Decoracion / Instalacion efimera | Parlantes, truss metalico, ground-stack, instalacion tactica |
| 9 | Camara / Angulo | POV, seguimiento, picado, cenital, lateral |
| 10 | Clima exterior | Lluvia, neblina, seco |
| 11 | Cinematica de poses | Como se mueve el cuerpo segun el estado emocional |
| 12 | Densidad humana | Solitario, grupos, masa, multitud |

### Regla de separacion de responsabilidades

- Factor 1: lienzo espacial (donde estamos)
- Factor 6: quienes estan ahi
- Factor 7: como se instalo la rave
- Factor 8: como se mira

NO se mezclan. Cada factor es independiente.

---

## 3. ARQUITECTURA DEL GENERADOR

### Estructura JSON/YAML por factor

Cada opcion dentro de un factor debe tener:

- metadata
- locked_core_prompt: prompt base inmutable
- evolution_ideas[]: mejoras positivas
- exclusions[]: errores que la IA no debe cometer

### Dos niveles

- GLOBAL: ideas/exclusiones que aplican a todo el factor
- LOCAL: ideas/exclusiones especificas de una opcion

### Conceptos clave

- IDEAS ADITIVAS: mejoran sin romper la regla
- EXCLUSIONES: prohiben errores tipicos de la IA
- DESVIOS / OVERRIDES: excepciones explicitas a una regla global
  (ej. "quiero que se parezca a Lima" aunque el factor sea universalidad)

### Flujo

1. Seleccionas opciones de cada factor
2. El ensamblador compila un prompt maestro
3. Ese prompt se le entrega a la IA generadora de imagenes

---

## 4. PROBLEMA DE LA MEMORIA HUMANA

### El problema

- La mente opera con ALTA ENTROPIA y SALTOS DE CONTEXTO
- La memoria de trabajo se desborda (metafora del vaso con pelotitas)
- Se pierde el hilo, se olvidan terminos tecnicos
- Se depende de Ctrl+F para recuperar conceptos
- La redundancia linguistica existe porque la memoria es limitada
- Los terminos abstractos no tienen anclaje sensorial (no se huelen, no se ven, no se tocan), por eso se olvidan mas rapido

### Ecuacion de sobrecarga

    O = max(0, m - v - W)

Donde:
- O = sobrecarga
- m = elementos mentales necesarios
- v = elementos visibles en la interfaz
- W = limite biologico de la memoria de trabajo

Conclusion: necesitas externalizar memoria en una interfaz visual/persistente.

---

## 5. PROPUESTAS DE SOLUCION

### HCI / UI Cognitiva

- State Rail: panel persistente con parametros activos
- Semantic Zoom y Ghost Layers: capas que muestran dependencias sin saturar
- Scaffolded Friction: obligar al usuario a clasificar sus ideas en tiempo real
- Reactive DAG: grafo aciclico dirigido para evitar bucles y permitir time-travel
- SQLite WAL + @ts-check: persistencia local y validacion tipada
- Neuroergonomia: adaptar la UI segun fatiga (adenosina, HRV, TEPR)

### Mnemotecnia

- Cubo-personaje: cubos 3x3 hasta 32x32 con patrones zigzag
- Indexacion espaciotemporal 4D: ano, mes, dia, hora + colores y vectores
- Sistemas narrativos: ano = personaje, mes = accion, dia = item, hora = ambiente
- Simbolos ASCII, rotaciones, angulos, eliminacion de conectores gramaticales
- Voice-to-node: dictado continuo, segmentacion semantica, nodos automaticos

### Prompt de investigacion avanzada

Ver archivos:
- Investigacion HCI Alta Entropia.docx
- Investigacion Arquitectura UI Cognitiva.docx

---

## 6. INVESTIGACIONES REALIZADAS

### Investigacion 1: HCI Alta Entropia

- Memoria de trabajo: 4-7 elementos simultaneos
- State Rail, Semantic Zoom, Ghost Layers
- Scaffolded Friction: NXS-SLICER de ideas
- Grafos aciclicos dirigidos (DAG)
- SQLite WAL, @ts-check, AST JSON

### Investigacion 2: Arquitectura UI Cognitiva

- Ecuacion de sobrecarga
- Efecto cerradura de UIs conversacionales
- Externalizacion dinamica (Orality, StepWrite)
- Decodificacion restringida por gramatica (AST, JSON)
- Neuroergonomia (TEPR, HRV)
- Modulos: Ingesta Restringida, Gestor de Estado Topologico,
  Bucle de Supervision Activa, Auditor Metacognitivo

---

## 7. PROYECTOS ANTIGUOS RELACIONADOS

- Mnemotecnia Cubo-Personaje (motor grafico mental)
- Diccionario de simbolos / compresion de lenguaje
- Memoria virtual / mnemotecnia infinita

---

## 8. PROXIMOS PASOS (cuando se retome)

### Corto plazo

- Definir el primer factor de forma completa (JSON con metadata,
  locked_core_prompt, evolution_ideas, exclusions)
- Probar el ensamblaje manual en una IA generadora
- Validar que la miniatura resultante represente el estado emocional

### Medio plazo

- Definir los 12 factores en JSON
- Implementar el ensamblador (script local, sin IA en tiempo real)
- Probar el flujo completo con un set real

### Largo plazo

- Resolver el primer pilar (memoria/externalizacion cognitiva)
- Interfaz de captura de voz con segmentacion semantica
- Integracion de mnemotecnia visual

---

## 9. FILOSOFIA DEL PROYECTO

- La tecnica es el lenguaje, no el fin
- La curaduria es narrativa temporal y emocional
- El sistema debe permitir creatividad sin perderse en el caos
- La redundancia es un sintoma de memoria limitada
- La solucion no es "pensar menos", es "externalizar mejor"

---

## 10. LINKS Y REFERENCIAS

- Investigacion HCI Alta Entropia.docx
- Investigacion Arquitectura UI Cognitiva.docx
- Mnemotecnia Cubo-Personaje (motor grafico mental)
- ULTRA TOKEN JSON
- Arquitectura De Ensamblaje De Prompts.docx

---

## NOTAS FINALES

Este documento es un rescate de ideas del 2026-09-17.
No es la version final. Es un snapshot para no olvidar.

Cuando retomes el proyecto, empeza por el Factor 1 y el Factor 6.
Son los pilares de todo el sistema.

La investigacion cognitiva (primer pilar) queda pendiente.
No es urgente. El motor visual se puede construir sin ella.

Regla de oro: SIEMPRE separacion de responsabilidades.
Cada factor hace una sola cosa. Nada mas.