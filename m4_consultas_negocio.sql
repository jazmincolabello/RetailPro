-- ============================================================================
-- PRE-ENTREGA MÓDULO 4: Extrayendo métricas clave con SQL 
-- Base de Datos: Ventas_Tech_DB
-- m4_consultas_negocio.sql
-- ============================================================================


-- ----------------------------------------------------------------------------
-- CONSULTA 1: Resumen ejecutivo mensual
-- ----------------------------------------------------------------------------
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta)
ORDER BY 
    mes ASC;


-- ----------------------------------------------------------------------------
-- CONSULTA 2: Ranking de productos (Top 5)
-- ----------------------------------------------------------------------------
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM 
    ventas
GROUP BY 
    id_producto
ORDER BY 
    total_facturado DESC;


-- ----------------------------------------------------------------------------
-- CONSULTA 3: Clientes recurrentes
-- ----------------------------------------------------------------------------
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM 
    ventas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 1
ORDER BY 
    total_gastado DESC;


-- ----------------------------------------------------------------------------
-- CONSULTA 4: Meses por encima/por debajo del promedio
-- ----------------------------------------------------------------------------
WITH facturacion_mensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM 
        ventas
    GROUP BY 
        MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS estado_rendimiento
FROM 
    facturacion_mensual
ORDER BY 
    mes ASC;


-- ============================================================================
-- BLOQUE DE CIERRE: Hallazgos de Negocio
-- ============================================================================

-- 1. Concentración de ingresos:
-- El producto id_producto = 1 es el que genera la mayor cantidad de ingresos, con $3.600, representando más del 50% de la facturación total.

-- 2. Compras recurrentes:
-- Todos los clientes registrados (id_cliente del 1 al 5) realizaron compras recurrentes, ya que cada uno realizó exactamente 2 pedidos.

-- 3. Concentración temporal de las ventas:
-- Toda la facturación, que alcanza los $6.184, se concentró en el mes de marzo (mes 3). Por este motivo, el total facturado en ese mes coincide con el promedio general de facturación.