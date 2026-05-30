# ============================================================
#  main.jl — Demo: tres EDOs resueltas con Método de Euler
#  Jonathan Cofiño – 251252
#  CC2016 – UVG Semestre I 2026
# ============================================================

include("euler.jl")
using Printf

println("=" ^ 55)
println("  Demostración — Método de Euler en Julia")
println("=" ^ 55)


# ══════════════════════════════════════════════════════════
#  EDO 1: Crecimiento/decaimiento exponencial
#         dy/dt = -2y,  y(0) = 1
#         Solución exacta: y(t) = e^(-2t)
# ══════════════════════════════════════════════════════════
println("\n─── EDO 1: Decaimiento exponencial ───")
println("    dy/dt = -2y,  y(0) = 1")
println("    Solución exacta: y(t) = e^(-2t)\n")

f1     = (t, y) -> -2.0 * y
exacta1 = t -> exp(-2.0 * t)

ts, ys = euler(f1, 0.0, 2.0, 1.0, 0.1)

println("  t     | Euler    | Exacta   | Error")
println("  ------+----------+----------+----------")
for i in 1:5:length(ts)
    e = exacta1(ts[i])
    @printf("  %.2f  | %.6f | %.6f | %.2e\n",
            ts[i], ys[i], e, abs(ys[i]-e))
end


# ══════════════════════════════════════════════════════════
#  EDO 2: Ecuación logística (crecimiento poblacional)
#         dy/dt = r·y·(1 - y/K)
#         r=1, K=100, y(0)=5
#         Solución exacta: K / (1 + ((K-y0)/y0)·e^(-rt))
# ══════════════════════════════════════════════════════════
println("\n─── EDO 2: Crecimiento logístico ───")
println("    dy/dt = y·(1 - y/100),  y(0) = 5")
println("    Modela crecimiento poblacional con capacidad de carga\n")

r, K, y0 = 1.0, 100.0, 5.0
f2      = (t, y) -> r * y * (1.0 - y/K)
exacta2 = t -> K / (1.0 + ((K - y0)/y0) * exp(-r * t))

ts2, ys2 = euler(f2, 0.0, 10.0, y0, 0.05)

println("  t     | Euler    | Exacta   | Población ≈")
println("  ------+----------+----------+------------")
for t_target in [0.0, 1.0, 3.0, 5.0, 7.0, 10.0]
    idx = argmin(abs.(ts2 .- t_target))
    e   = exacta2(ts2[idx])
    @printf("  %.1f   | %7.3f  | %7.3f  | ~%.0f individuos\n",
            ts2[idx], ys2[idx], e, ys2[idx])
end


# ══════════════════════════════════════════════════════════
#  EDO 3: Oscilador armónico (sistema de 2 ecuaciones)
#         x'' + ω²x = 0  →  sistema:
#             dx/dt = v
#             dv/dt = -ω²x
#         ω=2π, x(0)=1, v(0)=0  → x(t) = cos(ωt)
# ══════════════════════════════════════════════════════════
println("\n─── EDO 3: Oscilador armónico ───")
println("    x'' + (2π)²x = 0,  x(0)=1, v(0)=0")
println("    Solución exacta: x(t) = cos(2πt)\n")

ω = 2π

# Sistema vectorial: y = [x, v]
# Julia permite trabajar con vectores directamente
function euler_sistema(t0, tf, y0_vec, h, f_sistema)
    ts = collect(t0:h:tf)
    ys = [Vector{Float64}(undef, 2) for _ in ts]
    ys[1] = copy(y0_vec)

    for i in 2:length(ts)
        ys[i] = ys[i-1] .+ h .* f_sistema(ts[i-1], ys[i-1])
    end
    return ts, ys
end

f3        = (t, y) -> [y[2], -ω^2 * y[1]]   # [dx/dt, dv/dt]
exacta3   = t -> cos(ω * t)
y0_vec    = [1.0, 0.0]

ts3, ys3 = euler_sistema(0.0, 1.0, y0_vec, 0.001, f3)

println("  t     | x Euler  | x Exacta | Error")
println("  ------+----------+----------+----------")
for t_target in [0.0, 0.25, 0.5, 0.75, 1.0]
    idx = argmin(abs.(ts3 .- t_target))
    aprox = ys3[idx][1]
    e     = exacta3(ts3[idx])
    @printf("  %.2f  | %+.6f | %+.6f | %.2e\n",
            ts3[idx], aprox, e, abs(aprox - e))
end


# ══════════════════════════════════════════════════════════
#  Resumen
# ══════════════════════════════════════════════════════════
println("\n" * "=" ^ 55)
println("  Resumen")
println("=" ^ 55)
println("""
  Las tres EDOs fueron resueltas con el Método de Euler
  implementado manualmente en Julia.

  Ventajas observadas:
  ✓ Notación matemática clara (f = (t,y) -> expresión)
  ✓ Bucles for sin overhead — velocidad comparable a C
  ✓ Broadcasting (.+, .*) para operar vectores sin loops extra
  ✓ Una función genérica sirve para escalares y vectores
  ✓ No requirió ninguna librería externa
""")
