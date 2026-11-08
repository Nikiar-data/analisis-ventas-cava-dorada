create database ventas_cava_dorada
use ventas_cava_dorada
GO

select*from productos
select*from ventas


--Cantidad promedio vendido por dia, considerado los dias vendidos en cada mes en el periodo 2025-2026
SELECT 
    año, mes,
    SUM(cantidad) AS 'Cantidad total',
    COUNT(DISTINCT fecha) AS 'Días con ventas',
    SUM(cantidad) * 1.0 / COUNT(DISTINCT fecha) AS 'Cantidad promedio por día'
FROM
	ventas
GROUP BY
	año, mes
ORDER BY
	SUM(cantidad) * 1.0 / COUNT(DISTINCT fecha) DESC;

--ventas total obtenido en el periodo 2025-2026
select 
	sum(venta_total) as 'Venta total'
from ventas

--Ventas totales por producto 
select 
	producto as 'Producto' ,
	sum(venta_total) as 'Venta_total'
from 
	ventas
group by 
	producto
order by
	sum(venta_total) desc

--Ventas totales por categoria
select 
	categoria 
	, sum(venta_total) as 'Venta total'
from
	ventas
group by
	categoria
order by
	sum(venta_total) desc

--Venta total por dia

select 
	dia, 
	sum(venta_total) as 'Venta_total'
from 
	ventas
group by 
	dia
order by
	sum(venta_total) desc

--Venta total por mes. Diferenciado por año
select 
	mes, año,
	sum(venta_total) as 'Venta total'
from 
	ventas
group by
	mes, año
order by 
	sum(venta_total) desc

--Venta total por año
select 
	año,
	sum(venta_total) as 'Venta total' 
from
	Ventas
group by 
	año
order by 
	sum(venta_total) desc

-- Ventas por año y mes (cronológico, no alfabético)
SELECT año, mes, SUM(venta_total) AS 'Venta total'
FROM ventas
GROUP BY año, mes, MONTH(fecha)
ORDER BY año, MONTH(fecha) desc


--Cantidad total vendido en todo el periodo de ventas
select
	sum(cantidad) as 'Cantidad total'
from ventas

--Cantidades totales vendidas producto
select 
	producto as 'Producto', 
	sum(cantidad) as 'Cantidad total'
from 
	ventas
group by 
	producto
order by 
	sum(cantidad) desc

--Cantidades totales vendidas por mes 
select 
	mes,sum(cantidad) as 'Cantidad total'
from
	Ventas
group by 
	mes
order by 
	sum(cantidad) desc

--Cantidades totales vendidas por dia
select 
	dia,
	sum(cantidad) as 'Cantidad total'
from
	Ventas
group by 
	dia
order by 
	sum(cantidad) desc

--Cantidades totales vendidas en el año 2025 y 2026
select 
	año,
	sum(cantidad) as 'Cantidad total'
from
	Ventas
group by 
	año
order by 
	sum(cantidad) desc

--Cantidades totales por categoria
select 
	categoria, 
	sum(cantidad) as 'Cantidad total'
from 
	ventas
group by 
	categoria
order by 
	sum(cantidad) desc


--Transacciones unicas en total
select
	 count(distinct id_venta) as 'Transacciones Unicas'
from 
	ventas

--Ticket promedio de venta y cantidad
select sum(venta_total)*1.0/ count(distinct id_venta) as 'Ticket promedio por ventas',
		sum(cantidad)*1.0/ count(distinct id_venta) as 'TIcket promedio por cantidad'
from ventas
 
-- % de cada producto sobre la venta total
SELECT 
    producto ,
    SUM(venta_total) AS 'Venta total',
    CAST(SUM(venta_total) * 100.0 / SUM(SUM(venta_total)) OVER() AS DECIMAL(5,2)) AS 'Porcentaje'
FROM ventas
GROUP BY producto
ORDER BY SUM(venta_total) DESC;

-- % de cada categoría sobre la venta total
SELECT
	categoria,
    SUM(venta_total) AS 'Venta total',
    CAST(SUM(venta_total) * 100.0 / SUM(SUM(venta_total)) OVER() AS DECIMAL(5,2)) AS 'Porcentaje'
FROM ventas
GROUP BY categoria
ORDER BY SUM(venta_total) DESC;

-- Crecimiento mensual vs mes anterior
WITH mensual AS (
    SELECT año, MONTH(fecha) AS num_mes, mes, SUM(venta_total) AS venta
    FROM ventas
    GROUP BY año, MONTH(fecha), mes
)
SELECT año, mes, venta,
       LAG(venta) OVER (ORDER BY año, num_mes) AS venta_mes_anterior,
       CAST((venta - LAG(venta) OVER (ORDER BY año, num_mes)) * 100.0
            / NULLIF(LAG(venta) OVER (ORDER BY año, num_mes), 0) AS DECIMAL(6,2)) AS 'Crecimiento %'
FROM mensual
ORDER BY año, num_mes;

--Producto más vendido de cada categoría
WITH ranking AS (
    SELECT categoria, producto, SUM(venta_total) AS venta,
           ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY SUM(venta_total) DESC) AS pos
    FROM ventas
    GROUP BY categoria, producto
)
SELECT categoria, producto, venta
FROM ranking
WHERE pos = 1;

--Productos con las veces y cantidad total vendida
SELECT producto, COUNT(DISTINCT id_venta) AS 'Veces vendido', SUM(cantidad) AS 'Cantidad total'
FROM ventas
GROUP BY producto
ORDER BY COUNT(DISTINCT id_venta);

-- Análisis pareto,  % acumulado de venta por producto
WITH base AS (
    SELECT producto, SUM(venta_total) AS venta
    FROM ventas
    GROUP BY producto
)
SELECT producto, venta,
       CAST(SUM(venta) OVER (ORDER BY venta DESC) * 100.0 / SUM(venta) OVER() AS DECIMAL(5,2)) AS 'Acumulado %'
FROM base
ORDER BY venta DESC;

--Productos que no se han vendido
select p.id_producto, p.nombre, p.categoria, v.id_venta
from Productos p 
left join ventas v on p.id_producto=v.id_producto
where v.id_producto is null

