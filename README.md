# -Mi-Viaje-en-SQL-Consultas-MER-y-m-s
Repositorio sobre gestión de bases de datos con SQL. Incluye la creación de un Modelo Entidad-Relación (MER), consultas básicas y avanzadas (SELECT, JOIN, GROUP BY, etc.), además de ejemplos prácticos para aplicar en distintos escenarios.
# 🛒 Sistema de Gestión de Pedidos y Productos

¡Hola! 👋 Soy Fernando y este es mi proyecto de base de datos orientado a la **gestión de pedidos y productos**.  
Mi objetivo fue diseñar y gestionar datos **como un pro**, aplicando buenas prácticas en SQL y modelado de datos.  

---

## 📌 Descripción del Proyecto

Este proyecto consiste en un sistema que relaciona **Clientes, Pedidos y Productos**.  
Permite manejar las operaciones básicas de un negocio, desde el registro de pedidos hasta la relación con los productos.  

Para el diseño utilicé un **Modelo Entidad-Relación (MER)** y consultas SQL optimizadas.  

---

## 🛠️ Tecnologías Utilizadas

- **MySQL** para la gestión de la base de datos  
- **SQL** para las consultas  
- **MER** para el modelado  
- **GitHub** para compartir el proyecto  

---

## 💻 Ejemplos de Consultas SQL

```sql
-- Crear tabla de productos
CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- Crear tabla de pedidos
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    id_cliente INT
);

-- Relacionar pedido con producto (muchos a muchos)
CREATE TABLE Pedido_Producto (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- Ejemplo de JOIN
SELECT p.id_pedido, pr.nombre, pr.precio, pp.cantidad
FROM Pedido p
JOIN Pedido_Producto pp ON p.id_pedido = pp.id_pedido
JOIN Producto pr ON pp.id_producto = pr.id_producto;

```
---
##🗂️ GRÁFICO (MER)
<img width="800" height="420" alt="image" src="https://github.com/user-attachments/assets/ac12ddc7-ae12-4a1a-a3cd-a80fc28a0f40" />
---

