-- Clientes SIN pedidos (LEFT JOIN para filtrar nulos)
CREATE OR REPLACE VIEW Clientes_sin_pedidos AS			-- Crear vista
SELECT c.codigo_cliente, c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
WHERE p.codigo_pedido IS NULL;
SELECT *
FROM Clientes_sin_pedidos;

-- Productos sin aparecer en ningún pedido (RIGHT JOIN equivalente a LEFT)
CREATE OR REPLACE VIEW Productos_sin_ventas AS			-- Crear vista
SELECT pr.codigo_producto, pr.nombre
FROM producto pr
LEFT JOIN detalle_pedido dp ON dp.codigo_producto = pr.codigo_producto
WHERE dp.codigo_pedido IS NULL;
SELECT *
FROM Productos_sin_ventas;

-- Vista: Clientes con total de pedidos pendientes y días de espera promedio
CREATE OR REPLACE VIEW Clientes_pedidos_pendientes AS
SELECT 
    c.codigo_cliente,
    c.nombre_cliente,
    c.telefono,
    COUNT(p.codigo_pedido) AS total_pedidos_pendientes,
    AVG(DATEDIFF(p.fecha_esperada, p.fecha_pedido)) AS dias_promedio_espera  -- Borrar
FROM cliente c
JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
WHERE p.estado IN ('Pendiente')
GROUP BY c.codigo_cliente, c.nombre_cliente, c.telefono;
SELECT *
FROM Clientes_pedidos_pendientes
ORDER BY total_pedidos_pendientes DESC;
-- Vista Top5 ventas por mes
CREATE OR REPLACE VIEW Top5_ventas_por_mes AS
SELECT 
	DATE_FORMAT(p.fecha_pedido, '%Y-%m') AS mes,
	SUM(dp.cantidad * pr.precio_venta) AS total_ventas
FROM pedido p
JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
WHERE p.estado = 'Entregado'
GROUP BY mes;
-- llama
SELECT * 
FROM Top5_ventas_por_mes
ORDER BY total_ventas DESC
LIMIT 5;

-- Vista: Mes con mayores ventas (usando Top5_ventas_por_mes)
CREATE OR REPLACE VIEW Mes_con_mas_ventas AS
SELECT *
FROM Top5_ventas_por_mes
ORDER BY total_ventas DESC
LIMIT 1;
SELECT * 
FROM Mes_con_mas_ventas;

-- Vista: Productos más vendidos durante el mes con mayores ventas
CREATE OR REPLACE VIEW Productos_mas_vendidos_mes_top AS
SELECT dp.codigo_producto,
       pr.nombre, 
       SUM(dp.cantidad) AS total_vendido
FROM pedido p
JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
JOIN Mes_con_mas_ventas mv ON DATE_FORMAT(p.fecha_pedido, '%Y-%m') = mv.mes
WHERE p.estado = 'Entregado'
GROUP BY clientedp.codigo_producto, pr.nombre
ORDER BY total_vendido DESC;
SELECT * 
FROM Productos_mas_vendidos_mes_top;

-- Tabla de fidelización
CREATE OR REPLACE VIEW vista_fidelizacion AS
SELECT 
    c.codigo_cliente,
    c.nombre_cliente,
    COUNT(pag.id_transaccion) AS total_pagos,
    SUM(CASE WHEN p.estado = 'Pendiente' THEN 1 ELSE 0 END) AS total_pedidos_pendientes
FROM cliente c
LEFT JOIN pago pag ON c.codigo_cliente = pag.codigo_cliente
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre_cliente
HAVING total_pedidos_pendientes > 0
   AND total_pagos >= 2;
SELECT * 
FROM vista_fidelizacion
ORDER BY total_pagos DESC;
