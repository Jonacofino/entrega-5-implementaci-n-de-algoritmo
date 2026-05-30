# ============================================================
#  euler.jl — Método de Euler para EDOs
#  Jonathan Cofiño – 251252
#  CC2016 – UVG Semestre I 2026
# ============================================================
#
#  Problema: dada una EDO de la forma
#      dy/dt = f(t, y),  y(t0) = y0
#  aproximar y(t) en el intervalo [t0, tf] con paso h.
#
#  Fórmula de Euler:
#      y_{n+1} = y_n + h * f(t_n, y_n)
# ============================================================


# ------ 1. Euler clásico (paso fijo) ------

"""
    euler(f, t0, tf, y0, h)

Resuelve dy/dt = f(t, y) con condición inicial y(t0) = y0
usando el Método de Euler con paso fijo h.

Retorna (ts, ys): vectores de tiempos y valores aproximados.
"""
function euler(f, t0::T, tf::T, y0::T, h::T) where T <: AbstractFloat
    ts = collect(t0:h:tf)
    ys = Vector{T}(undef, length(ts))
    ys[1] = y0

    for i in 2:length(ts)
        ys[i] = ys[i-1] + h * f(ts[i-1], ys[i-1])
    end

    return ts, ys
end


# ------ 2. Euler con paso adaptivo (control de error) ------

"""
    euler_adaptivo(f, t0, tf, y0; tol, h_min, h_max)

Versión adaptiva: compara un paso de tamaño h con dos pasos
de tamaño h/2. Si el error supera la tolerancia, reduce h.

Retorna (ts, ys): vectores con los puntos aceptados.
"""
function euler_adaptivo(f, t0::T, tf::T, y0::T;
                         tol::T   = T(1e-4),
                         h_min::T = T(1e-6),
                         h_max::T = T(0.1)) where T <: AbstractFloat

    ts = [t0]
    ys = [y0]
    t  = t0
    y  = y0
    h  = h_max

    while t < tf
        h = min(h, tf - t)   # no sobrepasar tf

        # Un paso grande
        y1 = y + h * f(t, y)

        # Dos pasos de h/2
        y_mid = y  + (h/2) * f(t,       y)
        y2    = y_mid + (h/2) * f(t+h/2, y_mid)

        error = abs(y2 - y1)

        if error <= tol || h <= h_min
            # Acepta el paso (usa la estimación más precisa y2)
            t += h
            y  = y2
            push!(ts, t)
            push!(ys, y)

            # Intenta ampliar el paso si el error es muy pequeño
            if error < tol / 10
                h = min(h * 2, h_max)
            end
        else
            # Rechaza y reduce el paso
            h = max(h / 2, h_min)
        end
    end

    return ts, ys
end


# ------ 3. Utilidad: error respecto a solución exacta ------

"""
    error_maximo(ys_aprox, ts, sol_exacta)

Calcula el error máximo absoluto entre la solución aproximada
y la función exacta evaluada en los mismos puntos.
"""
function error_maximo(ys_aprox::Vector{T}, ts::Vector{T},
                      sol_exacta::Function) where T <: AbstractFloat
    return maximum(abs.(ys_aprox .- sol_exacta.(ts)))
end
