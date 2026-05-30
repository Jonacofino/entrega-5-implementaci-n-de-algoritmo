# Entrega 5 – Implementación de Algoritmo en Julia
**Jonathan Cofiño– 251252**  
CC2016 – Algoritmos y Estructura de Datos  
Universidad del Valle de Guatemala – Semestre I 2026

---

## ¿Qué hace este programa?

Implementación del **Método de Euler** para resolver ecuaciones diferenciales
ordinarias (EDOs), comparando dos enfoques:

- **Euler manual** — implementación explícita del algoritmo paso a paso
- **Euler con paso adaptivo** — ajusta el tamaño del paso según el error estimado,
  logrando más precisión con menos iteraciones

También incluye un benchmark que mide la diferencia de velocidad y precisión
entre ambos métodos con distintos tamaños de paso, y un demo que resuelve
tres EDOs clásicas mostrando las capacidades numéricas nativas de Julia.

---

## Archivos

| Archivo | Descripción |
|---|---|
| `euler.jl` | Funciones del método de Euler (manual y adaptivo) |
| `benchmark.jl` | Comparación de tiempos y error con distintos pasos h |
| `main.jl` | Demo completo: tres EDOs, solución exacta vs aproximada |

---

## ¿Cómo correrlo?

1. Tener Julia instalado
2. En terminal:

```
julia main.jl
```

Para el benchmark:

```
julia benchmark.jl
```

---

## ¿Por qué este algoritmo en Julia?

El Método de Euler es la base de toda simulación numérica: física, ingeniería,
biología computacional, finanzas. Julia es ideal para este tipo de algoritmo
porque sus bucles `for` compilan a código nativo (sin overhead de
interpretación como Python), permite notación matemática casi idéntica a las
fórmulas teóricas, y su sistema de tipos genéricos hace que la misma función
sirva para `Float32`, `Float64` o cualquier tipo de precisión arbitraria.

Internamente, cuando se usa el operador `\` para verificar soluciones exactas,
Julia utiliza LAPACK — la misma librería que usa SciPy en Python.
