# 🥃 Análisis de Ventas – La Cava Dorada (Licorería)

Proyecto de análisis de datos de las ventas de una licorería, desarrollado con **Excel, SQL Server y Power BI**. Cubre el periodo del **9 de junio de 2025 al 6 de abril de 2026** y busca responder preguntas del negocio: ¿qué productos y categorías generan más ingresos?, ¿qué días y meses se vende más?, ¿cuál es el ticket promedio?, ¿qué productos no rotan?

---

## ⚠️ Aviso importante sobre los datos

Los datos de este proyecto **no son las ventas oficiales** de la licorería. Por un acuerdo de confidencialidad con el negocio, no se permite publicar sus ventas reales, por lo que:

| Elemento | Origen |
|---|---|
| **Productos, categorías y precios** | ✅ Reales (catálogo de la licorería) |
| **Ventas de los primeros meses del periodo** | 🟡 Simuladas siguiendo un criterio/patrón basado en mi experiencia trabajando en el negocio (qué días y qué productos se vendían más) |
| **Ventas del resto del periodo (desde ~agosto 2025)** | 🔴 Demasiada simulacion , las ventas a partir de este periodo no son del todo verdaderos, pues aqui es donde se a simulado mas que todo las cantidades de ventas|

**Consecuencias a tener en cuenta:**

- Las cifras y conclusiones **no representan el desempeño real** de La Cava Dorada. El objetivo del proyecto es **demostrar el proceso analítico y técnico**, no sacar conclusiones comerciales.
- Algunos meses están **incompletos**: junio 2025 inicia el día 9 y abril 2026 termina el día 6, debido a que solo se me dio permiso para analizar las ventas en ese periodo de tiempo.

---

## 📊 Resumen del dataset

| Métrica | Valor |
|---|---|
| Periodo | 09/06/2025 – 06/04/2026 (302 días con ventas) |
| Filas (líneas de producto vendidas) | 18,023 |
| Transacciones únicas (`id_venta`) | 4,575 |
| Venta total | S/ 880,332 |
| Unidades vendidas | 39,415 |
| Ticket promedio | ≈ S/ 192.4 |
| Productos en catálogo | 292 |
| Categorías | 24 (Cerveza, Ron, Whisky, Pisco, Vinos, Gaseosas, Snacks, etc.) |

> Cada `id_venta` es un ticket y puede tener varias filas (una por producto). Por eso las **transacciones se calculan con conteo distinto de `id_venta`**, no contando filas.

---

## 🗂️ Estructura del repositorio

```
├── data/
│   └── Ventas_CavaDorada.xlsx        # Tablas: ventas y productos
├── sql/
│   └── analisis_ventas_cava.sql      # Consultas de análisis en SQL Server
├── powerbi/
│   └── Reporte_cava_dorada.pbix      # Dashboard de 3 páginas
└── README.md
```

### Modelo de datos

- **VENTAS** (18,023 filas): `id_venta`, `fecha`, `id_producto`, `producto`, `categoria`, `precio_uni`, `cantidad`, `venta_total`, `dia`, `orden_dia`, `mes`, `año`
- **PRODUCTOS** (292 filas): `id_producto`, `Productos`, `Categoria`, `precio_Uni`

Relación: `PRODUCTOS[id_producto]` 1 → * `VENTAS[id_producto]`.

---

## 🛠️ Herramientas

- **Excel** – almacenamiento y revisión inicial de los datos
- **SQL Server (T-SQL)** – exploración y análisis con agregaciones, funciones de ventana (`LAG`, `ROW_NUMBER`, `SUM() OVER`), CTEs y joins
- **Power BI Desktop** – modelado, medidas DAX y dashboard interactivo

---

## 🧮 Análisis en SQL

El archivo [`sql/analisis_ventas_cava.sql`](sql/analisis_ventas_cava.sql) incluye consultas para:

- Venta total y cantidad total del periodo
- Ventas y cantidades por **producto, categoría, día de la semana, mes y año**
- Cantidad promedio vendida por día, considerando solo los días con ventas de cada mes
- **Transacciones únicas** y **ticket promedio** (en soles y en unidades)
- **% de participación** de cada producto y categoría sobre la venta total
- **Crecimiento mensual** vs mes anterior (`LAG`)
- Producto más vendido de cada categoría (`ROW_NUMBER`)
- **Análisis de Pareto** (% acumulado de venta por producto)
- Productos del catálogo que **nunca se vendieron** (`LEFT JOIN`)

---

## 📈 Dashboard en Power BI

El reporte tiene **3 páginas** con filtros (segmentaciones) por año, mes, día y categoría:

### 1. Resumen General
KPIs: Venta total, Transacciones únicas, Unidades vendidas, Ticket promedio y Ticket promedio por cantidad. Incluye ventas por categoría (dona), top de productos, evolución de ventas y unidades, y ticket promedio por día de la semana.

![Resumen general](images/resumen_general.png)

### 2. Análisis de Productos
Producto y categoría top con su % sobre el total, productos vendidos, tabla detallada (venta, unidades, % del total) y participación de categorías por año.

![Análisis de productos](images/analisis_productos.png)

### 3. Análisis Temporal
Mejor día, mejor mes, venta promedio diaria, comportamiento de ventas, unidades y transacciones por día de la semana, y matriz de ventas por día y mes.

![Análisis temporal](images/analisis_temporal.png)

### Medidas DAX principales

```DAX
Venta total          = SUM(VENTAS[venta_total])
Transacciones unicas = DISTINCTCOUNT(VENTAS[id_venta])
Unidades vendidas    = SUM(VENTAS[cantidad])
Ticket promedio      = DIVIDE([Venta total], [Transacciones unicas])
```

Además: ticket promedio por cantidad, venta promedio diaria, mejor día, mejor mes, producto top, categoría top y sus porcentajes sobre el total.

---

## ▶️ Cómo reproducirlo

1. Clona o descarga el repositorio.
2. **SQL:** importa las tablas del Excel a SQL Server (por ejemplo con el *Asistente de importación*) en una base llamada `ventas_cava_dorada`, con las tablas `ventas` y `productos`, y ejecuta el script.
3. **Power BI:** abre `Reporte_cava_dorada.pbix` con Power BI Desktop. Si te pide la fuente, apunta a `data/Ventas_CavaDorada.xlsx` desde *Transformar datos → Configuración de origen de datos*.

---

## 👤 Autor

**Nicksito-bot**

> Proyecto con fines de portafolio. La mayoria de los datos de ventas han sido simulados y no reflejan la información real del negocio.
