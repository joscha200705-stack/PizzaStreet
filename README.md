
# 🍕 Pizza & Grill Street - Aplicación Web

Aplicación web CRUD desarrollada con **Python Flask** y **MariaDB** para la pizzería Pizza & Grill Street de Salteras (Sevilla).

## 📋 Descripción

Carta digital con sistema de pedidos online, panel de administración y buscador de productos.

## 🏗️ Arquitectura

- **VM1** → Servidor MariaDB (base de datos)
- **VM2** → Servidor Flask (aplicación web)

## 🗄️ Base de Datos

6 tablas relacionadas:
- `Categorias` → Tipos de productos
- `Ingredientes` → Ingredientes disponibles
- `Productos` → Carta completa
- `ProductoIngredientes` → Relación productos-ingredientes
- `Pedidos` → Pedidos realizados
- `LineaPedido` → Líneas de cada pedido

## 👥 Usuarios MariaDB

- `pizzaweb` → Usuario de la aplicación web (SELECT, INSERT, UPDATE, DELETE)
- `pizzaadmin` → Usuario administrador (todos los permisos)

## 🚀 Instalación

1. Crear entorno virtual:
```bash
python3 -m venv PizzaStreet
cd PizzaStreet
source bin/activate
```

2. Instalar dependencias:
```bash
pip install flask mariadb
```

3. Importar base de datos:
```bash
mysql -u root < pizzastreet_db.sql
```

4. Configurar conexión en `pizzastreet.py`:
```python
user="pizzaweb",
password="pizza1234",
host="IP_VM1",
```

5. Arrancar:
```bash
python pizzastreet.py
```

## 🌐 Rutas

| Ruta | Descripción |
|------|-------------|
| `/` | Carta pública |
| `/pedido` | Hacer un pedido |
| `/buscar` | Buscador con filtros |
| `/admin` | Panel de administración |
| `/admin/pedidos` | Ver pedidos recibidos |

## 📞 Contacto

**Pizza & Grill Street** · C/ Alcalde Gerardo Pérez Pérez, 12 Local 2 · Salteras (Sevilla)
📞 955 708 547 · 663 450 430
