-- ============================================================================
-- PRE-ENTREGA MÓDULO 5: Cruzando tablas para enriquecer el análisis
-- Base de Datos: Ventas_Tech_DB
-- m5_consultas_joins.sql
-- ============================================================================

USE Ventas_Tech_DB;

-- ----------------------------------------------------------------------------
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- ----------------------------------------------------------------------------
SELECT 
    v.fecha_venta AS fecha,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email AS email_cliente,
    p.nombre_producto AS descripcion_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM 
    ventas v
INNER JOIN 
    clientes c ON v.id_cliente = c.id_cliente
INNER JOIN 
    productos p ON v.id_producto = p.id_producto;


-- ----------------------------------------------------------------------------
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- ----------------------------------------------------------------------------
SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM 
    clientes c
LEFT JOIN 
    ventas v ON c.id_cliente = v.id_cliente
WHERE 
    v.id_venta IS NULL;


-- ----------------------------------------------------------------------------
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- ----------------------------------------------------------------------------
SELECT 
    p.nombre_producto,
    p.precio
FROM 
    productos p
LEFT JOIN 
    ventas v ON p.id_producto = v.id_producto
WHERE 
    v.id_venta IS NULL;


-- ----------------------------------------------------------------------------
-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- ----------------------------------------------------------------------------
WITH ventas_por_canal AS (
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM 
        ventas
    WHERE 
        DAY(fecha_venta) <= 15

    UNION ALL

    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM 
        ventas
    WHERE 
        DAY(fecha_venta) > 15
)
SELECT 
    canal,
    SUM(total) AS total_facturado,
    COUNT(*) AS cantidad_operaciones
FROM 
    ventas_por_canal
GROUP BY 
    canal;