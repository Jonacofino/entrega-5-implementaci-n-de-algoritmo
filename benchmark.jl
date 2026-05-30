# ============================================================
#  benchmark.jl — Comparación de velocidad y precisión
#  Jonathan Cofiño – 251252
#  CC2016 – UVG Semestre I 2026
# ============================================================

include("euler.jl")
using Printf

# EDO de prueba: dy/dt = -2y,  y(0) = 1
# Solución exacta: y(t) = e^(-2t)
f       = (t, y) -> -2.0 * y
exacta  = t -> exp(-2.0 * t)
t0, tf, y0 = 0.0, 5.0, 1.0

println("=" ^ 58)
println("  Benchmark — Método de Euler  |  dy/dt = -2y, y(0)=1")
println("=" ^ 58)

# ------ Euler clásico: distintos pasos h ------
println("\n► Euler clásico (paso fijo)\n")
println("  Paso h   | Pasos N  | Error máx    | Tiempo (ms)")
println("  ---------+----------+--------------+------------")

pasos = [0.5, 0.1, 0.05, 0.01, 0.001]

for h in pasos
    t = @elapsed begin
        for _ in 1:200          # repeticiones para medir bien
            ts, ys = euler(f, t0, tf, y0, h)
        end
    end
    ts, ys = euler(f, t0, tf, y0, h)
    err    = error_maximo(ys, ts, exacta)
    n      = length(ts)
    @printf("  h=%-6.3f | %-8d | %-12.6e | %.4f\n",
            h, n, err, (t/200)*1000)
end

# ------ Euler adaptivo ------
println("\n► Euler adaptivo (tolerancia variable)\n")
println("  Tolerancia | Pasos N  | Error máx    | Tiempo (ms)")
println("  -----------+----------+--------------+------------")

tolerancias = [1e-2, 1e-3, 1e-4, 1e-5]

for tol in tolerancias
    t = @elapsed begin
        for _ in 1:200
            ts, ys = euler_adaptivo(f, t0, tf, y0; tol=tol)
        end
    end
    ts, ys = euler_adaptivo(f, t0, tf, y0; tol=tol)
    err    = error_maximo(ys, ts, exacta)
    n      = length(ts)
    @printf("  tol=%-6.0e | %-8d | %-12.6e | %.4f\n",
            tol, n, err, (t/200)*1000)
end

println("\n► Conclusión:")
println("   El método adaptivo logra errores similares usando")
println("   significativamente menos pasos que el paso fijo.")
println("   En Julia, los bucles for tienen velocidad de C:")
println("   no hay penalización por escribir el algoritmo explícito.")
