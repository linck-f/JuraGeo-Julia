using GeoStats
using Meshes
using Plots
using StatsPlots
using StatsBase
using Statistics
using DataFrames
using Colors

import CairoMakie as Mke

# --------------------------------------------------------- #
# -------------------- LEITURA ARQUIVO -------------------- #
# --------------------------------------------------------- #

path = "Jura_Meters_Gslib.txt"

lines = readlines(path)

# linha 2 = número de variáveis
nvar = parse(Int, strip(lines[2]))

# linhas 3 até 3+nvar-1 = nomes das variáveis
colnames = strip.(lines[3:2+nvar])

# dados começam logo depois
data_lines = lines[3+nvar:end]

# separar cada linha em campos
rows = [split(strip(line)) for line in data_lines if !isempty(strip(line))]

# conferir se todas as linhas têm o mesmo número de colunas
#=
@show nvar
@show length(colnames)
@show unique(length.(rows))
=#

# converter cada linha para Float64
rows_num = [parse.(Float64, row) for row in rows]

# transformar em matriz
mat = reduce(vcat, permutedims.(rows_num))

# criar DataFrame
df = DataFrame(mat, Symbol.(colnames))

# ---------------------------------------------------------- #
# --------------- I. Estatística univariada ---------------- #
# ---------------------------------------------------------- #

zn = df.Zn
co = df.Co
rock = df.Rock

# -------------------------------------------------------------
# Zn - Zinco
# -------------------------------------------------------------
mean_zn = mean(zn)
var_zn  = var(zn)
std_zn  = std(zn)
cv_zn   = std_zn / mean_zn
min_zn  = minimum(zn)
max_zn  = maximum(zn)
q1_zn   = quantile(zn, 0.25)
q2_zn   = quantile(zn, 0.50)
q3_zn   = quantile(zn, 0.75)
n_zn    = length(zn)

fig = Mke.Figure(size = (600, 600), dpi=2000)

ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    title = "Zinco",
    xlabel = "Zn",
    ylabel = "Frequência",
)

Mke.hist!(ax, zn, bins = 30, 
          color = HSV(200, 74, 81), 
          alpha = 0.9,
          strokecolor = :black,
          strokewidth = 1
)

stats_txt = """
Média = $(round(mean_zn, digits=2))
Variância = $(round(var_zn, digits=2)) 
Desvio Padrão = $(round(std_zn, digits=2))
CV = $(round(cv_zn, digits=2))          
N° = $(round(n_zn))
"""

stats_txt2 = """
Máx = $(round(max_zn, digits=2))
Quartil 3 = $(round(q3_zn, digits=2))
Mediana = $(round(q2_zn, digits=2))
Quartil 1 = $(round(q1_zn, digits=2))
Min = $(round(min_zn, digits=2))
"""

Mke.Label(
    fig[2, 1],
    stats_txt,
    tellwidth = false,
    justification = :left,
    halign = 0.05,
    valign = :top,
    fontsize = 16
)

Mke.Label(
    fig[2, 1],
    stats_txt2,
    tellwidth = false,
    justification = :right,
    halign = 0.95,
    valign = :top,
    fontsize = 16
)

Mke.xlims!(ax, 0, nothing)
Mke.ylims!(ax, 0, nothing)

Q1 = Mke.vlines!(ax, [q1_zn], color = :gray, linewidth = 2, alpha=0.8)
Q2 = Mke.vlines!(ax, [q2_zn], color = :green, linewidth = 2, alpha=0.8)
Q3 = Mke.vlines!(ax, [q3_zn], color = :gray, linewidth = 2, alpha=0.8)
M = Mke.vlines!(ax, [mean_zn], color = :red, linewidth = 2, alpha=0.8)

Mke.Legend(fig[1, 1], tellwidth = false, halign = 0.95, valign = 0.95,
    [Q1, Q2, Q3, M],
    ["Q1", "Q2", "Q3", "Méd."]
)

Mke.rowgap!(fig.layout, 10)

display(fig)

# -------------------------------------------------------------
# Co - Cobalto
# -------------------------------------------------------------
mean_co = mean(co)
var_co  = var(co)
std_co  = std(co)
cv_co   = std_co / mean_co
min_co  = minimum(co)
max_co  = maximum(co)
q1_co   = quantile(co, 0.25)
q2_co   = quantile(co, 0.50)
q3_co   = quantile(co, 0.75)
n_co    = length(co)

fig = Mke.Figure(size = (600, 600), dpi=2000)

ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    title = "Cobalto",
    xlabel = "Co",
    ylabel = "Frequência",
)

Mke.hist!(ax, co, bins = 30, 
          color = HSV(200, 74, 81), 
          alpha = 0.9,
          strokecolor = :black,
          strokewidth = 1
)

stats_txt = """
Média = $(round(mean_co, digits=2))
Variância = $(round(var_co, digits=2)) 
Desvio Padrão = $(round(std_co, digits=2))
CV = $(round(cv_co, digits=2))
N° = $(round(n_co))
"""

stats_txt2 = """
Máx = $(round(max_co, digits=2))
Quartil 3 = $(round(q3_co, digits=2))
Mediana = $(round(q2_co, digits=2))
Quartil 1 = $(round(q1_co, digits=2))
Min = $(round(min_co, digits=2))
"""

Mke.Label(
    fig[2, 1],
    stats_txt,
    tellwidth = false,
    justification = :left,
    halign = 0.05,
    valign = :top,
    fontsize = 16
)

Mke.Label(
    fig[2, 1],
    stats_txt2,
    tellwidth = false,
    justification = :right,
    halign = 0.95,
    valign = :top,
    fontsize = 16
)

Mke.xlims!(ax, 0, nothing)
Mke.ylims!(ax, 0, nothing)

Q1 = Mke.vlines!(ax, [q1_co], color = :gray, linewidth = 2, alpha=0.8)
Q2 = Mke.vlines!(ax, [q2_co], color = :green, linewidth = 2, alpha=0.8)
Q3 = Mke.vlines!(ax, [q3_co], color = :gray, linewidth = 2, alpha=0.8)
M = Mke.vlines!(ax, [mean_co], color = :red, linewidth = 2, alpha=0.8)

Mke.Legend(fig[1, 1], tellwidth = false, halign = 0.95, valign = 0.95,
    [Q1, Q2, Q3, M],
    ["Q1", "Q2", "Q3", "Méd."])

Mke.rowgap!(fig.layout, 10)

display(fig)

# -------------------------------------------------------------
# Rock
# -------------------------------------------------------------

rock = Int.(df.Rock)

counts = countmap(rock)
total = sum(values(counts))

xs = sort(collect(keys(counts)))
ys = [counts[x] for x in xs]
props = [counts[x] / total for x in xs]

# figura
fig = Mke.Figure(size = (600, 600), dpi=2000)

ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    title = "Rock",
    xlabel = "Classe",
    ylabel = "Frequência"
)

# barras
Mke.barplot!(
    ax,
    xs, ys,
    color = HSV(200, 74, 81), 
    alpha = 0.9,
    strokecolor = :black,
    strokewidth = 1
)


stats_txt = """
N° = $(round(total))
"""

Mke.Label(
    fig[2, 1],
    stats_txt,
    tellwidth = false,
    justification = :left,
    halign = 0.05,
    valign = :top,
    fontsize = 16
)

# limite do eixo Y
ymax = maximum(ys)
Mke.ylims!(ax, 0, ymax * 1.2)

# anotações
for (x, y, p) in zip(xs, ys, props)
    Mke.text!(
        ax,
        x,
        y + ymax * 0.03,
        text = "n=$y\n$(round(p*100, digits=1))%",
        align = (:center, :bottom),
        fontsize = 15
    )
end

display(fig)

# ---------------------------------------------------------- #
# --------------- II. Estatística bivariada ---------------- #
# ---------------------------------------------------------- #

# ----------------
# Scatter
# ----------------

# estatísticas bivariadas
cov_co_zn = cov(co, zn)
cor_co_zn = cor(co, zn)

# ajuste linear
b = cov(co, zn) / var(co)
a = mean(zn) - b * mean(co)

xline = range(minimum(co), maximum(co), length=200)
yline = a .+ b .* xline

# figura
fig = Mke.Figure(size = (600, 600), dpi=2000)

ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    xlabel = "Co",
    ylabel = "Zn",
    title = "Zn x Co",
)

# pontos
Mke.scatter!(
    ax,
    co, zn,
    color = HSV(200, 74, 81), 
    alpha = 0.9,
    strokecolor = :black,
    strokewidth = 1,
    markersize = 10
)

# reta de ajuste
Mke.lines!(
    ax,
    xline, yline,
    color = :red,
    label = "Ajuste linear"
)

# legenda
Mke.axislegend(ax)

Mke.xlims!(ax, 0, nothing)
Mke.ylims!(ax, 0, nothing)

stats_txt3 = """
Covariância = $(round(cov_co_zn, digits=2))
Correlação = $(round(cor_co_zn, digits=3))
"""

Mke.Label(
    fig[2, 1],
    stats_txt3,
    tellwidth = false,
    justification = :left,
    halign = 0.05,
    valign = :top,
    fontsize = 16
)

Mke.rowgap!(fig.layout, 10)

display(fig)

# ----------------
# QQ Plot
# ----------------

zn_r2 = zn[rock .== 2]
zn_r1 = zn[rock .== 1]

# quantis
q = range(0, 1, length=100)

q_r2 = quantile(zn_r2, q)
q_r1 = quantile(zn_r1, q)

# limites para linha 1:1
minv = min(minimum(q_r2), minimum(q_r1))
maxv = max(maximum(q_r2), maximum(q_r1))

# figura
fig = Mke.Figure(size = (600, 600), dpi=2000)
ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    xlabel = "Zn (Rock = 2)",
    ylabel = "Zn (Rock = 1)",
    title = "QQ-plot Zn (Rock 1 vs Rock 2)"
)

# pontos
Mke.scatter!(
    ax,
    q_r2, q_r1,
    color = HSV(200, 74, 81), 
    alpha = 0.9,
    strokecolor = :black,
    strokewidth = 1,
    markersize = 10
)

# linha 1:1
Mke.lines!(
    ax,
    [minv, maxv],
    [minv, maxv],
    color = :black,
    linewidth = 2,
    label = "1:1",
    linestyle = :dot
)

# legenda
Mke.axislegend(ax)

# escala
Mke.limits!(ax, minv, maxv, minv, maxv)

display(fig)

# ----------------------------------------------------------- #
# ------------------- III. Desagrupamento ------------------- #
# ----------------------------------------------------------- #

# ----------------
# Zinco no espaço
# ----------------

fig = Mke.Figure(size = (600, 600), dpi=2000)

ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    title = "Zinco no espaço",
    xlabel = "X",
    ylabel = "Y",
    aspect = Mke.DataAspect(),
)

sc = Mke.scatter!(
    ax,
    df.X, df.Y,
    color = df.Zn,
    colormap = :sunset,
    markersize = 10
)

Mke.Colorbar(fig[1, 2], sc, label = "Zn")

display(fig)

# ----------------
# Cobalto no espaço
# ----------------

fig = Mke.Figure(size = (600, 600), dpi=2000)

ax = Mke.Axis(
    fig[1, 1],
    backgroundcolor = :gray80,
    title = "Cobalto no espaço",
    xlabel = "X",
    ylabel = "Y",
    aspect = Mke.DataAspect(),
)

sc = Mke.scatter!(
    ax,
    df.X, df.Y,
    color = df.Co,
    colormap = :sunset,
    markersize = 10,
    #alpha = 0.7
)

Mke.Colorbar(fig[1, 2], sc, label = "Co")

display(fig)
