
from flask import Flask, render_template, request, redirect
import mariadb
import sys

app = Flask(__name__)

def connection():
    try:
        conn = mariadb.connect(
            user="pizzaweb",
            password="pizza1234",
            host="192.168.0.31",
            port=3306,
            database="PizzaStreet"
        )
        return conn
    except mariadb.Error as e:
        print(f"Error conectando a MariaDB: {e}")
        sys.exit(1)

@app.route("/")
def index():
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Categorias ORDER BY id")
    categorias = [{"id": r[0], "nombre": r[1], "descripcion": r[2]} for r in cursor.fetchall()]
    cursor.execute("""
        SELECT p.id, p.categoria_id, p.codigo, p.nombre, p.ingredientes, p.precio, p.disponible, c.nombre
        FROM Productos p
        JOIN Categorias c ON p.categoria_id = c.id
        ORDER BY p.categoria_id, p.id
    """)
    productos = {}
    for r in cursor.fetchall():
        cat_id = r[1]
        if cat_id not in productos:
            productos[cat_id] = []
        productos[cat_id].append({
            "id": r[0], "categoria_id": r[1], "codigo": r[2],
            "nombre": r[3], "ingredientes": r[4], "precio": r[5], "disponible":r[6]
        })
    conn.close()
    return render_template("index.html", categorias=categorias, productos=productos)

@app.route("/admin")
def admin():
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT p.id, c.nombre, p.codigo, p.nombre, p.precio, p.disponible
        FROM Productos p
        JOIN Categorias c ON p.categoria_id = c.id
        ORDER BY c.id, p.id
    """)
    productos = [{"id": r[0], "categoria": r[1], "codigo": r[2],
                  "nombre": r[3], "precio": r[4], "disponible": r[5]}
                 for r in cursor.fetchall()]
    cursor.execute("SELECT * FROM Categorias ORDER BY id")
    categorias = [{"id": r[0], "nombre": r[1]} for r in cursor.fetchall()]
    conn.close()
    return render_template("admin.html", productos=productos, categorias=categorias)

@app.route("/addproducto", methods=["GET", "POST"])
def addproducto():
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Categorias ORDER BY id")
    categorias = [{"id": r[0], "nombre": r[1]} for r in cursor.fetchall()]
    if request.method == "POST":
        categoria_id = int(request.form["categoria_id"])
        codigo = request.form["codigo"]
        nombre = request.form["nombre"]
        precio = float(request.form["precio"])
        cursor.execute(
            "INSERT INTO Productos (categoria_id, codigo, nombre, precio) VALUES (?, ?, ?, ?)",
            (categoria_id, codigo, nombre, precio)
        )
        conn.commit()
        conn.close()
        return redirect("/admin")
    conn.close()
    return render_template("addproducto.html", categorias=categorias, producto={})

@app.route("/editproducto/<int:id>", methods=["GET", "POST"])
def editproducto(id):
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Categorias ORDER BY id")
    categorias = [{"id": r[0], "nombre": r[1]} for r in cursor.fetchall()]
    if request.method == "POST":
        categoria_id = int(request.form["categoria_id"])
        codigo = request.form["codigo"]
        nombre = request.form["nombre"]
        precio = float(request.form["precio"])
        disponible = 1 if request.form.get("disponible") else 0
        cursor.execute(
            "UPDATE Productos SET categoria_id=?, codigo=?, nombre=?, precio=?, disponible=? WHERE id=?",
            (categoria_id, codigo, nombre, precio, disponible, id)
        )
        conn.commit()
        conn.close()
        return redirect("/admin")
    cursor.execute("SELECT * FROM Productos WHERE id=?", (id,))
    r = cursor.fetchone()
    producto = {"id": r[0], "categoria_id": r[1], "codigo": r[2],
                "nombre": r[3], "precio": r[4], "disponible": r[5]}
    conn.close()
    return render_template("addproducto.html", categorias=categorias, producto=producto)

@app.route("/deleteproducto/<int:id>")
def deleteproducto(id):
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Productos WHERE id=?", (id,))
    conn.commit()
    conn.close()
    return redirect("/admin")

@app.route("/buscar")
def buscar():
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Categorias ORDER BY id")
    categorias = [{"id": r[0], "nombre": r[1]} for r in cursor.fetchall()]
    nombre = request.args.get("nombre", "")
    categoria_id = request.args.get("categoria_id", "")
    precio_max = request.args.get("precio_max", "")
    query = """
        SELECT p.id, c.nombre, p.codigo, p.nombre, p.precio, p.disponible
        FROM Productos p
        JOIN Categorias c ON p.categoria_id = c.id
        WHERE 1=1
    """
    params = []
    if nombre:
        query += " AND p.nombre LIKE ?"
        params.append(f"%{nombre}%")
    if categoria_id:
        query += " AND p.categoria_id = ?"
        params.append(int(categoria_id))
    if precio_max:
        query += " AND p.precio <= ?"
        params.append(float(precio_max))
    query += " ORDER BY p.categoria_id, p.precio"
    cursor.execute(query, params)
    resultados = [{"id": r[0], "categoria": r[1], "codigo": r[2],
                   "nombre": r[3], "precio": r[4], "disponible": r[5]}
                  for r in cursor.fetchall()]
    conn.close()
    return render_template("buscar.html", categorias=categorias,
                           resultados=resultados, total=len(resultados))

   
@app.route("/pedido", methods=["GET", "POST"])
def pedido():
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT p.id, p.categoria_id, p.codigo, p.nombre, p.ingredientes, p.precio
        FROM Productos p
        WHERE p.disponible = 1
        ORDER BY p.categoria_id, p.id
    """)
    productos = [{"id": r[0], "categoria_id": r[1], "codigo": r[2],
                  "nombre": r[3], "ingredientes": r[4], "precio": float(r[5])}
                 for r in cursor.fetchall()]
    cursor.execute("SELECT * FROM Categorias ORDER BY id")
    categorias = [{"id": r[0], "nombre": r[1]} for r in cursor.fetchall()]
    conn.close()
    return render_template("pedido.html", productos=productos, categorias=categorias)


@app.route("/confirmar_pedido", methods=["POST"])
def confirmar_pedido():
    conn = connection()
    cursor = conn.cursor()

    nombre_cliente = request.form.get("nombre_cliente")
    telefono = request.form.get("telefono")
    tipo = request.form.get("tipo")
    zona = request.form.get("zona", "")
    notas = request.form.get("notas", "")

    # Calcular total
    ids = request.form.getlist("producto_id")
    cantidades = request.form.getlist("cantidad")
    precios = request.form.getlist("precio_unidad")

    total = 0
    for i in range(len(ids)):
        total += float(precios[i]) * int(cantidades[i])

    # Recargo por domicilio
    recargo = 0
    if tipo == "domicilio":
        recargo = 1.50
    total += recargo

    # Guardar pedido
    cursor.execute("""
        INSERT INTO Pedidos (nombre_cliente, telefono, tipo, zona, notas, total)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (nombre_cliente, telefono, tipo, zona, notas, total))
    pedido_id = cursor.lastrowid

    # Guardar líneas
    for i in range(len(ids)):
        cursor.execute("""
            INSERT INTO LineaPedido (pedido_id, producto_id, cantidad, precio_unidad)
            VALUES (?, ?, ?, ?)
        """, (pedido_id, int(ids[i]), int(cantidades[i]), float(precios[i])))

    conn.commit()
    conn.close()
    return render_template("pedido_ok.html", nombre=nombre_cliente, total=total, tipo=tipo, zona=zona)
@app.route("/admin/pedidos")
def admin_pedidos():
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT p.id, p.fecha, p.nombre_cliente, p.telefono, p.tipo, p.zona, p.estado, p.total
        FROM Pedidos p
        ORDER BY p.fecha DESC
    """)
    pedidos = [{"id": r[0], "fecha": r[1], "nombre": r[2], "telefono": r[3],
                "tipo": r[4], "zona": r[5], "estado": r[6], "total": r[7]}
               for r in cursor.fetchall()]
    conn.close()
    return render_template("admin_pedidos.html", pedidos=pedidos)

@app.route("/pedido_estado/<int:id>/<estado>")
def pedido_estado(id, estado):
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE Pedidos SET estado=? WHERE id=?", (estado, id))
    conn.commit()
    conn.close()
    return redirect("/admin/pedidos")
@app.route("/admin/pedido/<int:id>")
def admin_pedido_detalle(id):
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT p.id, p.fecha, p.nombre_cliente, p.telefono, p.tipo, p.zona, p.notas, p.estado, p.total
        FROM Pedidos p WHERE p.id = ?
    """, (id,))
    r = cursor.fetchone()
    pedido = {"id": r[0], "fecha": r[1], "nombre": r[2], "telefono": r[3],
              "tipo": r[4], "zona": r[5], "notas": r[6], "estado": r[7], "total": r[8]}
    cursor.execute("""
        SELECT pr.nombre, pr.ingredientes, l.cantidad, l.precio_unidad
        FROM LineaPedido l
        JOIN Productos pr ON l.producto_id = pr.id
        WHERE l.pedido_id = ?
    """, (id,))
    lineas = [{"nombre": r[0], "ingredientes": r[1], "cantidad": r[2], "precio": r[3]}
              for r in cursor.fetchall()]
    conn.close()
    return render_template("admin_pedido_detalle.html", pedido=pedido, lineas=lineas)
if __name__=="__main__":
	app.run(host="0.0.0.0",debug=True)
